# 📱 Manual de Usuario - Agenda Telefónica

## Introducción

La **Agenda Telefónica** es una aplicación Android moderna para gestionar tus contactos de manera fácil e intuitiva. Permite agregar, editar, buscar y eliminar contactos con información completa como nombre, teléfono y email.

### Requisitos del Sistema
- **Android 5.0+** (API 21 o superior)
- **Pantalla de 4.5 pulgadas mínimo**
- **50 MB de espacio disponible**

---

## 1. Instalación del APK

### Opción 1: Instalación por ADB (Línea de Comandos)
```bash
adb install -r agenda-app.apk
```

### Opción 2: Instalación Manual
1. Copia el archivo `agenda-app.apk` a tu dispositivo
2. Abre el gestor de archivos
3. Busca y toca el archivo `agenda-app.apk`
4. Autoriza la instalación desde "Fuentes desconocidas"
5. Toca "Instalar"

### Opción 3: Actualizar APK existente
```bash
adb install -r agenda-app.apk
```

---

## 2. Primera Pantalla - Lista de Contactos

### Descripción General

```
┌─────────────────────────────────────┐
│  🔷  AGENDA TELEFÓNICA         ≡   │
├─────────────────────────────────────┤
│                                     │
│  📋 LISTA DE CONTACTOS              │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 👤 Juan García                │ │
│  │    📱 +34 612 345 678         │ │
│  │    ✉️  juan@example.com       │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 👤 María López                │ │
│  │    📱 +34 623 456 789         │ │
│  │    ✉️  maria@example.com      │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 👤 Pedro Rodríguez            │ │
│  │    📱 +34 634 567 890         │ │
│  │    ✉️  pedro@example.com      │ │
│  └───────────────────────────────┘ │
│                                     │
│              ┌─────────┐            │
│              │    ➕   │            │
│              └─────────┘            │
│            (Agregar contacto)       │
└─────────────────────────────────────┘
```

### Elementos de la Pantalla

| Elemento | Descripción |
|----------|-------------|
| **Barra Superior** | Título "AGENDA TELEFÓNICA" con icono del menú |
| **Lista de Contactos** | Muestra todos los contactos guardados |
| **Tarjeta de Contacto** | Contiene: Nombre, teléfono y email |
| **Botón Flotante (+)** | Toca para agregar un nuevo contacto |

### Acciones Disponibles

#### Agregar un Contacto
1. Toca el botón **"+"** (flotante en la esquina inferior derecha)
2. Se abrirá la pantalla de crear contacto
3. Completa los datos (ver sección 3)

#### Editar un Contacto
1. Toca sobre la tarjeta del contacto que deseas editar
2. Se abrirá la pantalla de edición
3. Modifica los datos necesarios
4. Toca **"Guardar"**

#### Eliminar un Contacto
1. Toca sobre la tarjeta del contacto
2. En la pantalla de edición, toca **"Eliminar"**
3. Confirma la acción

#### Contacto Vacío
Si no hay contactos guardados, verás:
```
┌─────────────────────────────────────┐
│                                     │
│      Sin contactos registrados      │
│                                     │
│    Toca el botón + para agregar     │
│                                     │
│              ┌─────────┐            │
│              │    ➕   │            │
│              └─────────┘            │
│                                     │
└─────────────────────────────────────┘
```

---

## 3. Agregar o Editar Contacto

### Pantalla de Contacto

```
┌─────────────────────────────────────┐
│  ◀️  NUEVO CONTACTO         ⋯       │
├─────────────────────────────────────┤
│                                     │
│  📝 Formulario de Contacto          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Nombre del Contacto         │   │
│  │ [Juan García           ]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Teléfono (Requerido)        │   │
│  │ [+34 612 345 678       ]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Email (Opcional)            │   │
│  │ [juan@example.com      ]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────────┐  ┌──────────┐  ┌──┐ │
│  │ Guardar  │  │ Eliminar │  │  │ │
│  └──────────┘  └──────────┘  │  │ │
│                              └──┘ │
│                                     │
└─────────────────────────────────────┘
```

### Campos del Formulario

| Campo | Tipo | Descripción |
|-------|------|-------------|
| **Nombre** | Texto | Nombre completo del contacto |
| **Teléfono** | Texto | Número de teléfono (requerido) |
| **Email** | Texto | Correo electrónico (opcional) |

### Validaciones

- ✅ **Nombre**: Puede estar vacío
- ✅ **Teléfono**: Campo obligatorio
- ✅ **Email**: Se valida si se ingresa (debe ser formato válido)

### Cómo Agregar un Contacto

#### Paso 1: Ir a Nueva Contacto
```
1. En la pantalla principal
2. Toca el botón flotante "➕"
3. Se abre la pantalla de nuevo contacto
```

#### Paso 2: Ingresar Datos
```
1. Campo "Nombre": 
   Toca y escribe "Juan García"

2. Campo "Teléfono": 
   Toca y escribe "+34 612 345 678"
   (Este campo es obligatorio)

3. Campo "Email":
   Toca y escribe "juan@example.com"
   (Opcional)
```

#### Paso 3: Guardar
```
1. Toca el botón "Guardar"
2. Se regresa a la lista de contactos
3. El contacto aparece en la lista
```

### Cómo Editar un Contacto

#### Paso 1: Seleccionar Contacto
```
1. En la lista de contactos
2. Toca la tarjeta del contacto a editar
3. Se abre la pantalla de edición
```

#### Paso 2: Modificar Datos
```
1. Toca el campo a modificar
2. Borra el contenido anterior
3. Escribe el nuevo valor
```

#### Paso 3: Guardar Cambios
```
1. Toca el botón "Guardar"
2. Los cambios se guardran inmediatamente
3. Regresa a la lista
```

### Cómo Eliminar un Contacto

#### Paso 1: Abrir Contacto
```
1. Toca la tarjeta del contacto
2. Se abre la pantalla de edición
```

#### Paso 2: Eliminar
```
1. Toca el botón "Eliminar"
2. Confirma la acción en el diálogo
3. El contacto se elimina permanentemente
```

---

## 4. Características Principales

### 🎨 Interfaz Moderna
- Colores degradados atractivos (morado a azul)
- Iconos intuitivos y claros
- Diseño responsive (funciona en diferentes tamaños)

### 📊 Gestión de Contactos
- ✅ Agregar contactos
- ✅ Editar información
- ✅ Eliminar contactos
- ✅ Almacenamiento local (SQLite)

### 💾 Almacenamiento
- Los contactos se guardan en una base de datos SQLite
- Los datos persisten incluso cerrando la app
- Seguro: no se comparten datos externos

### 🎯 Diseño Material
- Botón flotante de acción (FAB)
- RecyclerView para lista eficiente
- Campos de texto con validación

---

## 5. Paleta de Colores

```
┌─────────────────────────────────────┐
│ 🟪 Primario:     #667eea (Morado)   │
│ 🟦 Oscuro:       #5568d3 (Azul)     │
│ 🟨 Acento:       #764ba2 (Púrpura)  │
│ ⬜ Fondo:        #f5f5f5 (Gris)     │
│ ⬛ Texto:        #333333 (Negro)    │
└─────────────────────────────────────┘
```

---

## 6. Solución de Problemas

### Problema: La app no abre
**Solución:**
1. Verifica que tengas Android 5.0 o superior
2. Reinstala el APK: `adb install -r agenda-app.apk`
3. Borra caché: `adb shell pm clear com.agenda.telefonos`

### Problema: No se guarda el contacto
**Solución:**
1. Verifica que el campo "Teléfono" esté completo
2. Toca "Guardar" correctamente
3. Espera a que desaparezca el teclado

### Problema: Se borra un contacto por error
**Limitación:**
- Actualmente no hay recuperación de contactos eliminados
- Se recomienda ser cuidadoso al presionar "Eliminar"
- **Futuro:** Agregar papelera de reciclaje

### Problema: Email no válido
**Solución:**
1. Verifica el formato: usuario@dominio.com
2. No incluyas espacios
3. Campo opcional: puedes dejar en blanco

---

## 7. Estructura de Datos

### Esquema de Contacto
```json
{
  "id": 1,
  "nombre": "Juan García",
  "telefono": "+34 612 345 678",
  "email": "juan@example.com"
}
```

### Base de Datos
- **Tabla:** contacts
- **Tipo:** SQLite
- **Ubicación:** Almacenamiento interno del dispositivo
- **Acceso:** Solo la app puede acceder

---

## 8. Especificaciones Técnicas

### Información de la App
```
Nombre:          Agenda Telefénica
Paquete:         com.agenda.telefonos
Versión:         1.0.0
Min SDK:         21 (Android 5.0)
Target SDK:      33 (Android 13)
Tamaño APK:      5.5 MB
```

### Dependencias
- AndroidX AppCompat
- Material Design Components
- RecyclerView
- ConstraintLayout
- SQLite Database

---

## 9. Atajos y Consejos

### Consejos Útiles
1. **Nombre largo:** Si el nombre es muy largo, se cortará con "..."
2. **Teléfono:** Puedes usar formatos diferentes (+34, +1, etc.)
3. **Email:** Asegúrate de escribir correctamente para futuros contactos

### Gestos
| Gesto | Acción |
|-------|--------|
| **Toque simple** | Abre/edita contacto |
| **Scroll** | Desplaza lista de contactos |
| **Toque en +** | Nuevo contacto |

---

## 10. Preguntas Frecuentes

### ¿Puedo exportar mis contactos?
**Respuesta:**
- Actualmente no hay opción de exportación
- **Futuro:** Se añadirá soporte para CSV/vCard

### ¿Hay límite de contactos?
**Respuesta:**
- Teóricamente: Miles de contactos
- Práctico: Depende del espacio disponible
- Recomendado: Hasta 1000 contactos para mejor rendimiento

### ¿Puedo sincronizar con Google Contacts?
**Respuesta:**
- Actualmente no, es almacenamiento local
- **Futuro:** Se planea integración con Google Contacts

### ¿Se pueden agrupar contactos?
**Respuesta:**
- Actualmente no hay categorías
- **Futuro:** Agregar favoritos y grupos

### ¿Hay búsqueda de contactos?
**Respuesta:**
- Actualmente no hay búsqueda
- **Futuro:** Búsqueda por nombre y teléfono

---

## 11. Permisos Necesarios

La app requiere:
- **Acceso a almacenamiento:** Para guardar contactos
- **Sin permisos de red:** Todos los datos son locales

Puedes verificar en:
```
Configuración > Aplicaciones > Agenda Telefónica > Permisos
```

---

## 12. Actualizaciones Futuras

### Versión 1.1 (Planificado)
- [ ] Búsqueda de contactos
- [ ] Favoritos
- [ ] Exportar a CSV

### Versión 1.2 (Planificado)
- [ ] Sincronización con Google Contacts
- [ ] Fotos de perfil
- [ ] Categorías de contactos

### Versión 2.0 (Planificado)
- [ ] Aplicación web complementaria
- [ ] Papelera de reciclaje
- [ ] Historial de llamadas

---

## 13. Soporte

### Reportar Problemas
- 📧 Email: support@agendatelefonica.com
- 🐛 GitHub Issues: [Reportar en GitHub]

### Donaciones
Si te gusta la app, considera:
- ⭐ Dar una reseña en Play Store
- 🔗 Compartir con amigos
- 💰 Donar para desarrollo futuro

---

## 14. Licencia

© 2026 Agenda Telefónica. Todos los derechos reservados.

---

## Versión del Manual
- **Versión:** 1.0
- **Fecha:** 12 de enero de 2026
- **Aplicable a:** Agenda Telefónica v1.0.0

---

**¡Gracias por usar Agenda Telefónica!** 📱✨
