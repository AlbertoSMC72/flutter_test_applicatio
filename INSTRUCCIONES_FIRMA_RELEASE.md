# 🚀 Instrucciones para Firmar tu App Flutter en Release

## ✅ Configuración Completada

He configurado todo lo necesario para firmar tu aplicación en modo release. Ahora solo necesitas completar estos pasos:

## 📋 Pasos a Seguir

### 1. **Generar el Keystore**
Ejecuta el archivo `generar_keystore_final.bat` haciendo doble clic.

**O manualmente en PowerShell:**
```powershell
cd "C:\Program Files\Android\Android Studio\jbr\bin"
.\keytool.exe -genkey -v -keystore "C:\Users\alber\Downloads\Test\flutter_application_1\android\app\upload-keystore.jks" -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Información que te pedirá:**
- Contraseña del keystore: **¡GUÁRDALA BIEN!**
- Nombre y Apellido: Tu nombre
- Unidad organizacional: Tu empresa o "Personal"
- Organización: Tu empresa o "Personal"
- Ciudad: Tu ciudad
- Estado: Tu estado/provincia
- Código de país: Tu código (ej: ES para España)

### 2. **Configurar las Contraseñas**
Edita el archivo `android/key.properties` y cambia:
```properties
storePassword=LA_CONTRASEÑA_QUE_USASTE
keyPassword=LA_CONTRASEÑA_QUE_USASTE
keyAlias=upload
storeFile=upload-keystore.jks
```

### 3. **Generar AAB Firmado**
```bash
flutter clean
flutter build appbundle --release
```

### 4. **Subir a Google Play Store**
El archivo estará en: `build/app/outputs/bundle/release/app-release.aab`

## 🔧 Archivos Configurados

✅ `android/app/build.gradle.kts` - Configuración de firma
✅ `android/key.properties` - Propiedades del keystore
✅ `generar_keystore_final.bat` - Script para generar keystore
✅ `.gitignore` - Protección de archivos sensibles

## ⚠️ Importante

- **NUNCA** subas `key.properties` o `upload-keystore.jks` a Git
- **GUARDA** una copia de seguridad del keystore
- **RECUERDA** la contraseña que uses
- Si pierdes el keystore, no podrás actualizar tu app en Play Store

## 🎯 Resultado Final

Una vez completados estos pasos, tu AAB estará firmado correctamente para Google Play Store y no recibirás más el error de "firmado en modo de depuración".

¿Necesitas ayuda con algún paso específico? 