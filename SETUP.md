# MA Tax CRM — Activar la nube (Fase 2)

El CRM ya funciona **local** (abre `index.html`, los datos se guardan en el navegador).
Para usarlo en la **nube** (mismo login de Mayor/EZBooks, visible para todo el equipo):

## 1) Crear la tabla en Supabase (una sola vez · ~30 seg)
1. Entra a https://supabase.com → tu proyecto (el mismo de Mayor).
2. Menú izquierdo → **SQL Editor** → **New query**.
3. Copia y pega TODO el contenido de `schema.sql` → **Run**.
   - Crea la tabla `crm_leads` con seguridad (RLS): solo usuarios autenticados del equipo ven/editan.

## 2) Entrar
1. Abre `index.html` en el navegador.
2. Arriba a la derecha → **☁︎ Conectar**.
3. Entra con el **mismo correo y contraseña** que usas en Mayor/EZBooks.
   - El indicador cambia a verde con tu email = estás en la nube.

## 3) Subir tus datos locales (si ya metiste clientes)
- Si la nube está vacía y tenías clientes locales, aparece una barra amarilla → **"Subir a la nube"**.

## Acceso desde el celular
El archivo local (`file://`) no abre en el teléfono. Para usarlo en el celular hay que **publicarlo en una URL**. Opciones (gratis):
- **GitHub Pages** (tienes `gh` conectado como wantedrize)
- **Cloudflare Pages** / **Netlify**

> EliBot lo puede desplegar — solo pide la palabra. El `config.js` lleva la *anon key* (publishable), que es segura para estar en el cliente: la data está protegida por RLS + login.

## Archivos
- `index.html` — el CRM (nube + local con fallback)
- `index-local.html` — respaldo del MVP solo-local
- `config.js` — apunta al proyecto Supabase (compartido con Mayor)
- `schema.sql` — la tabla `crm_leads` (correr una vez)
