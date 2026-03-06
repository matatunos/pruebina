#!/bin/bash
################################################################################
# Nextcloud Audit Log Importer - Professional Edition
# Version: 2.0.0
# Description: Imports Nextcloud audit.log into MySQL/MariaDB in real-time
#              with deduplication, batch inserts, and SIEM-grade auditing
# Author: Enterprise Security Tools
# License: MIT
################################################################################

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

# Default config file location
CONFIG_FILE="${CONFIG_FILE:-/etc/nextcloud-audit-importer/config.conf}"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

# Required variables (with defaults)
LOG_FILE="${NC_AUDIT_LOG:-/var/www/nextcloud/data/audit.log}"
STATE_FILE="${STATE_FILE:-/var/lib/nextcloud-audit-importer/last_position}"
DB_NAME="${DB_NAME:-nextcloud_logs}"
DB_USER="${DB_USER:-nextcloud_audit}"
MYSQL_CONFIG="${MYSQL_CONFIG:-/etc/nextcloud-audit-importer/.my.cnf}"
BATCH_SIZE="${BATCH_SIZE:-100}"
PROCESS_INTERVAL="${PROCESS_INTERVAL:-5}"
IMPORTER_LOG="${IMPORTER_LOG:-/var/log/nextcloud-audit-importer.log}"
MAX_LOG_SIZE="${MAX_LOG_SIZE:-10485760}" # 10MB

# Counters
PROCESSED=0
INSERTED=0
SKIPPED=0
ERRORS=0

################################################################################
# LOGGING FUNCTIONS
################################################################################

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$IMPORTER_LOG"
}

log_info() { log "INFO" "$@"; }
log_warn() { log "WARN" "$@"; }
log_error() { log "ERROR" "$@"; }
log_debug() { 
    if [[ "${DEBUG:-0}" == "1" ]]; then
        log "DEBUG" "$@"
    fi
}

rotate_log() {
    if [[ -f "$IMPORTER_LOG" ]]; then
        local size=$(stat -f%z "$IMPORTER_LOG" 2>/dev/null || stat -c%s "$IMPORTER_LOG" 2>/dev/null || echo 0)
        if [[ $size -gt $MAX_LOG_SIZE ]]; then
            mv "$IMPORTER_LOG" "$IMPORTER_LOG.old"
            log_info "Log rotated (size: $size bytes)"
        fi
    fi
}

################################################################################
# DATABASE FUNCTIONS
################################################################################

mysql_exec() {
    mysql --defaults-extra-file="$MYSQL_CONFIG" "$DB_NAME" -sN "$@"
}

mysql_exec_multiline() {
    mysql --defaults-extra-file="$MYSQL_CONFIG" "$DB_NAME" <<EOF
$1
EOF
}

check_db_connection() {
    if ! mysql_exec -e "SELECT 1;" &>/dev/null; then
        log_error "Cannot connect to MySQL database"
        return 1
    fi
    log_debug "Database connection OK"
    return 0
}

init_database() {
    log_info "Initializing database schema..."
    
    mysql_exec_multiline "
    CREATE TABLE IF NOT EXISTS audit (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        time DATETIME NOT NULL,
        user VARCHAR(255) NOT NULL,
        ip VARCHAR(64),
        action VARCHAR(255) NOT NULL,
        file TEXT,
        user_agent TEXT,
        request_id VARCHAR(64),
        app VARCHAR(64),
        version VARCHAR(16),
        log_hash VARCHAR(64) UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_time (time),
        INDEX idx_user (user),
        INDEX idx_action (action),
        INDEX idx_ip (ip),
        INDEX idx_app (app)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    "
    
    log_info "Database schema initialized"
}

batch_insert() {
    local -a batch=("$@")
    
    if [[ ${#batch[@]} -eq 0 ]]; then
        return 0
    fi
    
    local sql="INSERT IGNORE INTO audit (time, user, ip, action, file, user_agent, request_id, app, version, log_hash) VALUES "
    local values=""
    
    for entry in "${batch[@]}"; do
        if [[ -n "$values" ]]; then
            values+=","
        fi
        values+="$entry"
    done
    
    sql+="$values;"
    
    log_debug "Executing batch insert with ${#batch[@]} records"
    
    if mysql_exec_multiline "$sql"; then
        INSERTED=$((INSERTED + ${#batch[@]}))
        return 0
    else
        log_error "Batch insert failed"
        ERRORS=$((ERRORS + ${#batch[@]}))
        return 1
    fi
}

################################################################################
# STATE MANAGEMENT
################################################################################

load_state() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "0"
    fi
}

save_state() {
    local position="$1"
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "$position" > "$STATE_FILE"
}

################################################################################
# LOG PROCESSING
################################################################################

escape_sql() {
    local str="$1"
    # Escape backslashes first, then single quotes for SQL
    echo "$str" | sed "s/\\\\/\\\\\\\\/g; s/'/''/g"
}

generate_hash() {
    local data="$1"
    echo -n "$data" | sha256sum | awk '{print $1}'
}

parse_log_entry() {
    local line="$1"
    
    # Parse JSON using jq
    local time=$(echo "$line" | jq -r '.time // empty' | cut -d'+' -f1 | cut -d'.' -f1)
    local user=$(echo "$line" | jq -r '.user // "system"')
    local ip=$(echo "$line" | jq -r '.remoteAddr // "127.0.0.1"')
    local message=$(echo "$line" | jq -r '.message // empty')
    local user_agent=$(echo "$line" | jq -r '.userAgent // empty')
    local request_id=$(echo "$line" | jq -r '.reqId // empty')
    local app=$(echo "$line" | jq -r '.app // empty')
    local version=$(echo "$line" | jq -r '.version // empty')
    
    # Validate required fields
    if [[ -z "$time" ]] || [[ -z "$message" ]]; then
        log_debug "Skipping invalid entry: missing required fields"
        return 1
    fi
    
    # Extract file from message (if exists)
    local file=""
    if [[ "$message" =~ .*:\ (.+)$ ]]; then
        file="${BASH_REMATCH[1]}"
    fi
    
    # Generate unique hash for deduplication
    local hash=$(generate_hash "$time|$user|$ip|$message|$request_id")
    
    # Escape values
    time=$(escape_sql "$time")
    user=$(escape_sql "$user")
    ip=$(escape_sql "$ip")
    message=$(escape_sql "$message")
    file=$(escape_sql "$file")
    user_agent=$(escape_sql "$user_agent")
    request_id=$(escape_sql "$request_id")
    app=$(escape_sql "$app")
    version=$(escape_sql "$version")
    
    # Return SQL VALUES clause
    echo "('$time','$user','$ip','$message','$file','$user_agent','$request_id','$app','$version','$hash')"
}

process_log() {
    local start_position=$(load_state)
    log_info "Starting log processing from byte position: $start_position"
    
    if [[ ! -f "$LOG_FILE" ]]; then
        log_error "Audit log file not found: $LOG_FILE"
        return 1
    fi
    
    local current_size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null)
    
    # Check if log was rotated (file is smaller than last position)
    if [[ $current_size -lt $start_position ]]; then
        log_warn "Log file rotated detected (size: $current_size < position: $start_position). Resetting position to 0"
        start_position=0
    fi
    
    local -a batch=()
    local line_count=0
    
    # Read from last position
    while IFS= read -r line; do
        PROCESSED=$((PROCESSED + 1))
        line_count=$((line_count + 1))
        
        # Check if line is valid JSON
        if ! echo "$line" | jq empty 2>/dev/null; then
            log_debug "Skipping invalid JSON line: ${line:0:100}..."
            SKIPPED=$((SKIPPED + 1))
            continue
        fi
        
        # Parse entry
        local entry=$(parse_log_entry "$line")
        
        if [[ -n "$entry" ]]; then
            batch+=("$entry")
        else
            SKIPPED=$((SKIPPED + 1))
        fi
        
        # Batch insert when batch size reached
        if [[ ${#batch[@]} -ge $BATCH_SIZE ]]; then
            batch_insert "${batch[@]}"
            batch=()
        fi
    done < <(tail -c +$((start_position + 1)) "$LOG_FILE")
    
    # Insert remaining records
    if [[ ${#batch[@]} -gt 0 ]]; then
        batch_insert "${batch[@]}"
    fi
    
    # Save new position
    local new_position=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null)
    save_state "$new_position"
    
    log_info "Processing complete: Processed=$PROCESSED, Inserted=$INSERTED, Skipped=$SKIPPED, Errors=$ERRORS"
}

################################################################################
# REAL-TIME MONITORING
################################################################################

monitor_log() {
    log_info "Starting real-time monitoring mode..."
    log_info "Watching: $LOG_FILE"
    log_info "Press Ctrl+C to stop"
    
    # Initial processing
    process_log
    
    # Monitor for changes
    if command -v inotifywait &>/dev/null; then
        # Linux with inotify
        log_info "Using inotifywait for file monitoring"
        while true; do
            inotifywait -e modify -e create "$LOG_FILE" 2>/dev/null
            sleep 1
            process_log
        done
    else
        # Fallback: polling
        log_warn "inotifywait not available, using polling mode (install inotify-tools for better performance)"
        while true; do
            sleep "$PROCESS_INTERVAL"
            process_log
        done
    fi
}

################################################################################
# MAINTENANCE FUNCTIONS
################################################################################

cleanup_old_logs() {
    local days="${1:-90}"
    log_info "Cleaning up audit logs older than $days days..."
    
    local deleted=$(mysql_exec -e "DELETE FROM audit WHERE time < DATE_SUB(NOW(), INTERVAL $days DAY);")
    log_info "Deleted $deleted old records"
}

show_stats() {
    log_info "=== Audit Database Statistics ==="
    
    local total=$(mysql_exec -e "SELECT COUNT(*) FROM audit;")
    log_info "Total records: $total"
    
    local users=$(mysql_exec -e "SELECT COUNT(DISTINCT user) FROM audit;")
    log_info "Unique users: $users"
    
    local oldest=$(mysql_exec -e "SELECT MIN(time) FROM audit;")
    log_info "Oldest record: $oldest"
    
    local newest=$(mysql_exec -e "SELECT MAX(time) FROM audit;")
    log_info "Newest record: $newest"
    
    log_info "Top 5 users by activity:"
    mysql_exec -e "SELECT user, COUNT(*) as count FROM audit GROUP BY user ORDER BY count DESC LIMIT 5;" | while read -r line; do
        log_info "  $line"
    done
}

################################################################################
# SIGNAL HANDLERS
################################################################################

cleanup() {
    log_info "Shutting down gracefully..."
    show_stats
    exit 0
}

trap cleanup SIGINT SIGTERM

################################################################################
# MAIN
################################################################################

main() {
    rotate_log
    log_info "=========================================="
    log_info "Nextcloud Audit Log Importer v2.0.0"
    log_info "=========================================="
    
    # Check dependencies
    for cmd in mysql jq sha256sum; do
        if ! command -v $cmd &>/dev/null; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    # Check database connection
    if ! check_db_connection; then
        log_error "Cannot proceed without database connection"
        exit 1
    fi
    
    # Initialize database
    init_database
    
    # Parse command
    local command="${1:-monitor}"
    
    case "$command" in
        monitor|watch|daemon)
            monitor_log
            ;;
        once|run)
            process_log
            ;;
        stats)
            show_stats
            ;;
        cleanup)
            cleanup_old_logs "${2:-90}"
            ;;
        init-db)
            log_info "Database already initialized"
            ;;
        *)
            echo "Usage: $0 {monitor|once|stats|cleanup [days]|init-db}"
            echo ""
            echo "Commands:"
            echo "  monitor    - Watch log file and process new entries in real-time (default)"
            echo "  once       - Process log file once and exit"
            echo "  stats      - Show database statistics"
            echo "  cleanup    - Remove old records (default: 90 days)"
            echo "  init-db    - Initialize database schema"
            exit 1
            ;;
    esac
}

main "$@"
