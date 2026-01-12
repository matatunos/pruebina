# 📋 Guía Rápida - Agenda Telefónica

## Instalación Rápida

```bash
adb install -r agenda-app.apk
```

## Operaciones Básicas

### ➕ Agregar Contacto
1. Toca el botón **"+"** (esquina inferior derecha)
2. Completa: Nombre, Teléfono (obligatorio), Email (opcional)
3. Toca **"Guardar"**

### ✏️ Editar Contacto
1. Toca la **tarjeta del contacto**
2. Modifica los datos deseados
3. Toca **"Guardar"**

### 🗑️ Eliminar Contacto
1. Abre el **contacto**
2. Toca **"Eliminar"**
3. Confirma en el diálogo

---

## Elementos de Pantalla

```
┌──────────────────────────┐
│  AGENDA TELEFÓNICA   ≡   │  ← Header (Título + Menú)
├──────────────────────────┤
│                          │
│  📋 Lista de Contactos   │
│  ┌────────────────────┐  │
│  │ 👤 Nombre          │  │
│  │ 📱 +34 612345678   │  │
│  │ ✉️ email@test.com  │  │
│  └────────────────────┘  │
│                          │
│              ┌────────┐  │
│              │   ➕   │  │  ← FAB (Agregar)
│              └────────┘  │
└──────────────────────────┘
```

---

## Información Técnica

| Propiedad | Valor |
|-----------|-------|
| Nombre | Agenda Telefónica |
| Versión | 1.0.0 |
| Paquete | com.agenda.telefonos |
| Min SDK | 21 (Android 5.0+) |
| Tamaño | 5.5 MB |

---

## Validaciones

✅ **Nombre:** Opcional  
✅ **Teléfono:** Obligatorio  
✅ **Email:** Opcional (se valida si se ingresa)  

---

## Campos del Formulario

```
Nombre:     [_____________________]
Teléfono:   [_____________________] *
Email:      [_____________________]
            [Guardar] [Eliminar]
```

*Campo obligatorio

---

## Acciones Rápidas

| Acción | Ubicación |
|--------|-----------|
| Agregar contacto | Botón "+" en lista |
| Editar contacto | Toca la tarjeta |
| Eliminar | Botón "Eliminar" en edición |
| Volver | Botón "Atrás" o gesto |

---

## Colores Principales

🟪 **Primario:** #667eea  
🟨 **Acento:** #764ba2  
⬜ **Fondo:** #f5f5f5  

---

## Almacenamiento

- 📂 **Tipo:** SQLite (Almacenamiento local)
- 🔐 **Privacidad:** Datos solo en tu dispositivo
- 💾 **Persistencia:** Permanece al cerrar la app

---

## Troubleshooting

| Problema | Solución |
|----------|----------|
| No se guarda | Verifica que teléfono esté completo |
| App no abre | Reinstala: `adb install -r agenda-app.apk` |
| Contacto borrado | Sin recuperación, sé cuidadoso |
| Email inválido | Formato: usuario@dominio.com |

---

## Formato de Teléfono Válido

✅ +34 612 345 678  
✅ +1-555-0100  
✅ 612345678  
✅ 612 345 678  

---

## FAQ Rápidas

**¿Hay sincronización en la nube?**  
No, es almacenamiento completamente local.

**¿Hay búsqueda?**  
No en v1.0, planificada para v1.1.

**¿Hay límite de contactos?**  
Teóricamente miles, recomendado hasta 1000.

**¿Puedo exportar contactos?**  
No en v1.0, planificado para futuras versiones.

---

## Teclado y Entrada

- **Tocar campo:** Abre teclado
- **Escribir:** Ingresa texto
- **Aceptar:** Toca "Guardar"

---

## Atajos de Navegación

| Gesto | Acción |
|-------|--------|
| Toque en contacto | Abre editor |
| Scroll arriba/abajo | Desplaza lista |
| Toque en + | Nuevo contacto |
| Atrás (físico) | Regresa a lista |

---

## Estado Vacío

```
Sin contactos registrados

Toca el botón + para agregar
```

---

## Versión Actual

📦 **v1.0.0**  
📅 Enero 12, 2026  
✨ Primera versión pública  

---

## Próximas Características

🔍 Búsqueda (v1.1)  
📸 Fotos de perfil (v1.2)  
☁️ Sincronización en nube (v2.0)  

---

**¡Uso fácil y rápido!** 📱✨
