import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class FirebaseService {
  Future<String?> getFirebaseToken();
  Future<void> requestPermission();
  Future<void> setupTokenRefreshListener();
  bool get isFirebaseAvailable;
}

class FirebaseServiceImpl implements FirebaseService {
  FirebaseMessaging? _firebaseMessaging;
  bool _isInitialized = false;

  @override
  bool get isFirebaseAvailable => _isInitialized;

  FirebaseServiceImpl() {
    _initializeFirebase();
  }

  void _initializeFirebase() {
    try {
      // Verificar si Firebase está disponible
      if (Firebase.apps.isNotEmpty) {
        _firebaseMessaging = FirebaseMessaging.instance;
        _isInitialized = true;
        print('[DEBUG_FIREBASE] Firebase inicializado correctamente');
      } else {
        print('[DEBUG_FIREBASE] Firebase no está disponible');
        _isInitialized = false;
      }
    } catch (e) {
      print('[DEBUG_FIREBASE] Error inicializando Firebase: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<String?> getFirebaseToken() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      print('[DEBUG_FIREBASE] Firebase no disponible, continuando sin token');
      return null;
    }

    try {
      String? token = await _firebaseMessaging!.getToken();
      print('[DEBUG_FIREBASE] Token obtenido: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      print('[DEBUG_FIREBASE] Error obteniendo token: $e');
      return null;
    }
  }

  @override
  Future<void> requestPermission() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      print('[DEBUG_FIREBASE] Saltando permisos - Firebase no disponible');
      return;
    }

    try {
      NotificationSettings settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('[DEBUG_FIREBASE] Permisos: ${settings.authorizationStatus}');
    } catch (e) {
      print('[DEBUG_FIREBASE] Error solicitando permisos: $e');
    }
  }

  @override
  Future<void> setupTokenRefreshListener() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      print('[DEBUG_FIREBASE] Saltando listener - Firebase no disponible');
      return;
    }

    try {
      _firebaseMessaging!.onTokenRefresh.listen((newToken) {
        print('[DEBUG_FIREBASE] Token renovado: ${newToken.substring(0, 20)}...');
        // Aquí podrías enviar el nuevo token al servidor
      });
    } catch (e) {
      print('[DEBUG_FIREBASE] Error configurando listener: $e');
    }
  }
}