// core/utils/image_utils.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static const int maxFileSize = 2 * 1024 * 1024; // 2MB
  static const int maxWidth = 800;
  static const int maxHeight = 600;

  /// Convierte un archivo de imagen a base64
  static Future<String?> fileToBase64(File imageFile) async {
    try {
      // Verificar tamaño del archivo
      final fileSize = await imageFile.length();
      if (fileSize > maxFileSize) {
        throw Exception('La imagen es muy grande. Máximo 2MB permitido.');
      }

      // Leer bytes del archivo
      final bytes = await imageFile.readAsBytes();
      
      // Redimensionar imagen si es necesario
      final compressedBytes = await _compressImage(bytes);
      
      // Convertir a base64
      final base64String = base64Encode(compressedBytes);
      return base64String;
    } catch (e) {
      print('Error al convertir imagen a base64: $e');
      return null;
    }
  }

  /// Convierte base64 a MemoryImage para mostrar en Flutter
  static MemoryImage? base64ToMemoryImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    try {
      // Remover prefijo data:image si existe
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }

      final bytes = base64Decode(cleanBase64);
      return MemoryImage(bytes);
    } catch (e) {
      print('Error al convertir base64 a imagen: $e');
      return null;
    }
  }

  /// Widget para mostrar imagen desde base64 o URL
  static Widget buildImageWidget({
    String? base64Image,
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Placeholder por defecto
    final defaultPlaceholder = placeholder ?? 
      Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image,
          color: Colors.grey,
          size: 50,
        ),
      );

    // Error widget por defecto
    final defaultErrorWidget = errorWidget ??
      Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.broken_image,
          color: Colors.red,
          size: 50,
        ),
      );

    // Priorizar base64 sobre URL
    if (base64Image != null && base64Image.isNotEmpty) {
      final memoryImage = base64ToMemoryImage(base64Image);
      if (memoryImage != null) {
        return Image(
          image: memoryImage,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
        );
      }
    }

    // Usar URL si no hay base64
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return defaultPlaceholder;
        },
        errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
      );
    }

    // Mostrar placeholder si no hay imagen
    return defaultPlaceholder;
  }

  /// Selector de imagen con opciones
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 85,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      return null;
    }
  }

  /// Muestra diálogo para seleccionar fuente de imagen
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Seleccionar imagen',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFECEC3D)),
                title: const Text(
                  'Galería',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFECEC3D)),
                title: const Text(
                  'Cámara',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImage(source: ImageSource.camera);
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Comprimir imagen si excede el tamaño máximo
  static Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      // Decodificar imagen
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return bytes;

      // Redimensionar si es muy grande
      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image,
          width: image.width > maxWidth ? maxWidth : null,
          height: image.height > maxHeight ? maxHeight : null,
        );
      }

      // Comprimir como JPEG con calidad 85
      final compressedBytes = img.encodeJpg(image, quality: 85);
      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('Error al comprimir imagen: $e');
      return bytes;
    }
  }

  /// Validar si una cadena es base64 válida
  static bool isValidBase64(String value) {
    try {
      base64Decode(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener el tipo MIME de una imagen base64
  static String? getBase64MimeType(String base64String) {
    if (base64String.startsWith('data:image/')) {
      final end = base64String.indexOf(';');
      if (end != -1) {
        return base64String.substring(5, end); // Remover 'data:'
      }
    }
    return null;
  }

  /// Prefijo para base64 con tipo MIME
  static String addDataPrefix(String base64String, {String mimeType = 'image/jpeg'}) {
    if (base64String.startsWith('data:')) {
      return base64String;
    }
    return 'data:$mimeType;base64,$base64String';
  }

  /// Remover prefijo data: de base64
  static String removeDataPrefix(String base64String) {
    if (base64String.contains(',')) {
      return base64String.split(',').last;
    }
    return base64String;
  }
}