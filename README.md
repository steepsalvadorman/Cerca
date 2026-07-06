# Cerca

App de servicios técnicos a domicilio: conecta clientes con técnicos/equipos
verificados, con contacto directo o licitación entre técnicos.

- `lib/` — app Flutter, organizada por feature (ver `lib/features/`; el
  estado y dominio compartido de la app vive en `lib/features/cerca/`).
- `backend/` — backend en Rust (Axum + Postgres), ver `backend/README.md`
  para desarrollo local.

## Ramas y ambientes

- **`develop`**: rama de trabajo diario. Un push aquí solo corre chequeos
  livianos (`flutter analyze`, `cargo check`) — no despliega nada. Úsala
  para probar todo localmente (app + backend corriendo en tu máquina).
- **`main`**: producción. Un push aquí:
  - Despliega el backend a Fly.io (`.github/workflows/backend-deploy.yml`,
    solo si tocaste algo en `backend/`).
  - Compila y distribuye el APK vía Firebase App Distribution, apuntando
    al backend en producción (`.github/workflows/android-distribute.yml`).

Flujo normal: trabajas y pusheas en `develop`, y cuando algo está listo
para salir, se mergea `develop` → `main` (PR o merge directo).

## Correr en local

Ver `backend/README.md` para levantar el backend. Para la app:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080   # backend local, emulador Android
```
