-- ============================================================================
-- Nextcloud Audit Database - Useful Queries
-- ============================================================================

-- 1. RECENT ACTIVITY
-- Last 100 events
SELECT time, user, ip, action, file
FROM audit
ORDER BY time DESC
LIMIT 100;

-- 2. FILE DOWNLOADS
-- Who downloaded what
SELECT time, user, ip, file
FROM audit
WHERE action LIKE '%download%'
ORDER BY time DESC;

-- 3. FILE UPLOADS
SELECT time, user, ip, file
FROM audit
WHERE action LIKE '%upload%' OR action LIKE '%created%'
ORDER BY time DESC;

-- 4. FILE DELETIONS (IMPORTANT FOR FORENSICS)
SELECT time, user, ip, file
FROM audit
WHERE action LIKE '%delete%' OR action LIKE '%removed%'
ORDER BY time DESC;

-- 5. FAILED LOGIN ATTEMPTS
SELECT time, user, ip, action
FROM audit
WHERE action LIKE '%failed%login%'
ORDER BY time DESC;

-- 6. USER ACTIVITY SUMMARY
SELECT 
    user,
    COUNT(*) as total_actions,
    COUNT(DISTINCT DATE(time)) as active_days,
    MIN(time) as first_seen,
    MAX(time) as last_seen
FROM audit
GROUP BY user
ORDER BY total_actions DESC;

-- 7. MOST DOWNLOADED FILES
SELECT 
    file,
    COUNT(*) as download_count,
    COUNT(DISTINCT user) as unique_users
FROM audit
WHERE action LIKE '%download%' AND file != ''
GROUP BY file
ORDER BY download_count DESC
LIMIT 50;

-- 8. ACTIVITY BY HOUR (find peak usage times)
SELECT 
    HOUR(time) as hour,
    COUNT(*) as actions
FROM audit
WHERE time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY hour
ORDER BY hour;

-- 9. EXTERNAL ACCESS (non-local IPs)
SELECT time, user, ip, action, file
FROM audit
WHERE ip NOT LIKE '127.%' 
  AND ip NOT LIKE '192.168.%'
  AND ip NOT LIKE '10.%'
  AND ip NOT REGEXP '^172\\.(1[6-9]|2[0-9]|3[01])\\.'
ORDER BY time DESC;

-- 10. SUSPICIOUS ACTIVITY (rapid downloads from same IP)
SELECT 
    ip,
    user,
    COUNT(*) as downloads,
    GROUP_CONCAT(DISTINCT file SEPARATOR ', ') as files
FROM audit
WHERE action LIKE '%download%'
  AND time >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
GROUP BY ip, user
HAVING downloads > 50
ORDER BY downloads DESC;

-- 11. SHARED FILES ACTIVITY
SELECT time, user, ip, action, file
FROM audit
WHERE action LIKE '%share%'
ORDER BY time DESC;

-- 12. FILE ACCESS BY USER
SELECT 
    DATE(time) as date,
    COUNT(*) as actions
FROM audit
WHERE user = 'USERNAME_HERE'
GROUP BY DATE(time)
ORDER BY date DESC;

-- 13. TOP ACTIVE IPs
SELECT 
    ip,
    COUNT(*) as actions,
    COUNT(DISTINCT user) as unique_users,
    MAX(time) as last_seen
FROM audit
GROUP BY ip
ORDER BY actions DESC
LIMIT 20;

-- 14. APPLICATION USAGE
SELECT 
    app,
    COUNT(*) as actions
FROM audit
WHERE app != ''
GROUP BY app
ORDER BY actions DESC;

-- 15. WEEKLY ACTIVITY REPORT
SELECT 
    YEARWEEK(time) as week,
    COUNT(*) as total_actions,
    COUNT(DISTINCT user) as active_users,
    COUNT(DISTINCT ip) as unique_ips
FROM audit
GROUP BY week
ORDER BY week DESC
LIMIT 12;

-- 16. FIND USER'S LAST 20 ACTIONS
SELECT time, ip, action, file
FROM audit
WHERE user = 'USERNAME_HERE'
ORDER BY time DESC
LIMIT 20;

-- 17. DATA EXFILTRATION DETECTION (multiple downloads by single user)
SELECT 
    user,
    ip,
    COUNT(*) as file_count,
    MIN(time) as started,
    MAX(time) as ended,
    TIMESTAMPDIFF(MINUTE, MIN(time), MAX(time)) as duration_minutes
FROM audit
WHERE action LIKE '%download%'
  AND time >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY user, ip
HAVING file_count > 100
ORDER BY file_count DESC;

-- 18. NEW USER FIRST ACTIVITY
SELECT 
    user,
    MIN(time) as first_activity,
    COUNT(*) as total_actions
FROM audit
GROUP BY user
ORDER BY first_activity DESC;

-- 19. DELETED FILES RECOVERY INFO
SELECT 
    time as deleted_at,
    user as deleted_by,
    file
FROM audit
WHERE action LIKE '%delete%'
  AND time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY time DESC;

-- 20. COMPLIANCE REPORT (all file access)
SELECT 
    DATE(time) as date,
    user,
    COUNT(*) as file_accesses,
    COUNT(DISTINCT file) as unique_files
FROM audit
WHERE action LIKE '%read%' OR action LIKE '%download%'
GROUP BY DATE(time), user
ORDER BY date DESC, file_accesses DESC;
