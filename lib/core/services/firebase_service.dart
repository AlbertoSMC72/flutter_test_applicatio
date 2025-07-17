import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class FirebaseService {
  Future<String?> getFirebaseToken();
  Future<void> requestPermission();
  Future<void> setupTokenRefreshListener();
  Future<void> initializeNotifications();
  bool get isFirebaseAvailable;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Stream<RemoteMessage> get onMessage;
}

class FirebaseServiceImpl implements FirebaseService {
  FirebaseMessaging? _firebaseMessaging;
  bool _isInitialized = false;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  bool get isFirebaseAvailable => _isInitialized;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  FirebaseServiceImpl() {
    _initializeFirebase();
  }

  void _initializeFirebase() {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      _isInitialized = true;
      debugPrint('[DEBUG_FIREBASE] Firebase Messaging inicializado correctamente');
    } catch (e) {
      debugPrint('[DEBUG_FIREBASE] Error inicializando Firebase: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<String?> getFirebaseToken() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      debugPrint('[DEBUG_FIREBASE] Firebase no disponible, continuando sin token');
      return null;
    }

    try {
      String? token = await _firebaseMessaging!.getToken();
      debugPrint('[DEBUG_FIREBASE] Token obtenido: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      debugPrint('[DEBUG_FIREBASE] Error obteniendo token: $e');
      return null;
    }
  }

  @override
  Future<void> requestPermission() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      debugPrint('[DEBUG_FIREBASE] Saltando permisos - Firebase no disponible');
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

      debugPrint('[DEBUG_FIREBASE] Permisos: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('[DEBUG_FIREBASE] Error solicitando permisos: $e');
    }
  }

  @override
  Future<void> setupTokenRefreshListener() async {
    if (!_isInitialized || _firebaseMessaging == null) {
      debugPrint('[DEBUG_FIREBASE] Saltando listener - Firebase no disponible');
      return;
    }

    try {
      _firebaseMessaging!.onTokenRefresh.listen((newToken) {
        debugPrint('[DEBUG_FIREBASE] Token renovado: ${newToken.substring(0, 20)}...');
        // Aquí podrías enviar el nuevo token al servidor
      });
    } catch (e) {
      debugPrint('[DEBUG_FIREBASE] Error configurando listener: $e');
    }
  }

  @override
  Future<void> initializeNotifications() async {
    if (!_isInitialized) return;

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS, // Add if you need iOS support
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Set up foreground notification handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics, // Add if you need iOS support
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message:  {message.messageId}");
  // Puedes manejar notificaciones en background aquí
}