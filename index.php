<?php
// Archivo de datos
$dataFile = 'contacts.json';

// Inicializar archivo si no existe
if (!file_exists($dataFile)) {
    file_put_contents($dataFile, json_encode([]));
}

// Cargar contactos
$contacts = json_decode(file_get_contents($dataFile), true) ?? [];

// Procesar formulario
$message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        if ($_POST['action'] === 'add' || $_POST['action'] === 'update') {
            $name = trim($_POST['name'] ?? '');
            $phone = trim($_POST['phone'] ?? '');
            $email = trim($_POST['email'] ?? '');
            
            if (empty($name) || empty($phone)) {
                $message = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> El nombre y teléfono son requeridos</div>';
            } else {
                if ($_POST['action'] === 'add') {
                    $contacts[] = [
                        'id' => time(),
                        'name' => $name,
                        'phone' => $phone,
                        'email' => $email
                    ];
                    $message = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Contacto agregado exitosamente</div>';
                } else {
                    $id = (int)($_POST['id'] ?? 0);
                    foreach ($contacts as &$contact) {
                        if ($contact['id'] === $id) {
                            $contact['name'] = $name;
                            $contact['phone'] = $phone;
                            $contact['email'] = $email;
                            $message = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Contacto actualizado exitosamente</div>';
                            break;
                        }
                    }
                }
                file_put_contents($dataFile, json_encode($contacts));
            }
        } elseif ($_POST['action'] === 'delete') {
            $id = (int)($_POST['id'] ?? 0);
            $contacts = array_filter($contacts, fn($c) => $c['id'] !== $id);
            $contacts = array_values($contacts);
            file_put_contents($dataFile, json_encode($contacts));
            $message = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Contacto eliminado</div>';
        }
    }
}

$editingContact = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    foreach ($contacts as $contact) {
        if ($contact['id'] === $id) {
            $editingContact = $contact;
            break;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agenda de Teléfonos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-address-book"></i> Mi Agenda</h1>
            <p>Gestiona tus contactos de teléfono fácilmente</p>
        </div>

        <div class="content">
            <!-- Formulario -->
            <div class="form-section">
                <h2>
                    <i class="fas fa-plus-circle section-icon"></i>
                    <?php echo $editingContact ? 'Editar Contacto' : 'Nuevo Contacto'; ?>
                </h2>

                <?php if ($message) echo $message; ?>

                <form method="POST">
                    <input type="hidden" name="action" value="<?php echo $editingContact ? 'update' : 'add'; ?>">
                    <?php if ($editingContact): ?>
                        <input type="hidden" name="id" value="<?php echo $editingContact['id']; ?>">
                    <?php endif; ?>

                    <div class="form-group">
                        <label><i class="fas fa-user"></i> Nombre</label>
                        <input type="text" name="name" placeholder="Ej: Juan Pérez" 
                               value="<?php echo htmlspecialchars($editingContact['name'] ?? ''); ?>" required>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-phone"></i> Teléfono</label>
                        <input type="tel" name="phone" placeholder="Ej: +34 612 345 678" 
                               value="<?php echo htmlspecialchars($editingContact['phone'] ?? ''); ?>" required>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-envelope"></i> Correo (Opcional)</label>
                        <input type="email" name="email" placeholder="Ej: correo@ejemplo.com" 
                               value="<?php echo htmlspecialchars($editingContact['email'] ?? ''); ?>">
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-<?php echo $editingContact ? 'save' : 'plus'; ?>"></i>
                            <?php echo $editingContact ? 'Actualizar' : 'Agregar'; ?>
                        </button>
                        <?php if ($editingContact): ?>
                            <button type="button" class="btn-cancel" onclick="window.location.href='?'">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                        <?php endif; ?>
                    </div>
                </form>
            </div>

            <!-- Lista de Contactos -->
            <div class="contacts-section">
                <h2>
                    <i class="fas fa-list section-icon"></i>
                    Contactos (<?php echo count($contacts); ?>)
                </h2>

                <?php if (empty($contacts)): ?>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <p>No hay contactos aún<br><small>¡Crea uno para comenzar!</small></p>
                    </div>
                <?php else: ?>
                    <div class="contact-list">
                        <?php foreach ($contacts as $contact): ?>
                            <div class="contact-card">
                                <div class="contact-info">
                                    <h3><i class="fas fa-user-circle"></i> <?php echo htmlspecialchars($contact['name']); ?></h3>
                                    <p><i class="fas fa-phone"></i> <?php echo htmlspecialchars($contact['phone']); ?></p>
                                    <?php if (!empty($contact['email'])): ?>
                                        <p><i class="fas fa-envelope"></i> <?php echo htmlspecialchars($contact['email']); ?></p>
                                    <?php endif; ?>
                                </div>
                                <div class="contact-actions">
                                    <a href="?edit=<?php echo $contact['id']; ?>" class="btn-edit">
                                        <i class="fas fa-edit"></i> Editar
                                    </a>
                                    <form method="POST" style="display: inline;" 
                                          onsubmit="return confirm('¿Eliminar este contacto?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?php echo $contact['id']; ?>">
                                        <button type="submit" class="btn-delete">
                                            <i class="fas fa-trash"></i> Eliminar
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</body>
</html>
