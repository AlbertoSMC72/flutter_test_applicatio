import 'package:firebase_messaging/firebase_messaging.dart';

class MyFirebaseMessagingService {
  static Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Handle initial message
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when app is opened from terminated state
    });
  }
}