import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;
  //

  //
  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future _onMessgeHandler(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStream.add(message.notification!.title.toString());
  }

  static Future initializeApp() async {
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessgeHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<String> getCellphoneToken() async {
    token = await FirebaseMessaging.instance.getToken();
    // print('😂😂😂 CLASE PRINCIPAL' + token.toString());
    return token.toString();
  }

  static closestream() {
    _messageStream.close();
  }

  static void sedNotifications(String token, String titulo, String content) {
    FirebaseDatabase.instance
        .ref('config/serverToken')
        .get()
        .then((snapshot) async {
      String accessToken = snapshot.value.toString();
      Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      http.post(
        url,
        headers: <String, String>{
          "Authorization": 'key=$accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, Object>{
            "notification": {"body": content, "title": titulo},
            "to": token
          },
        ),
      );
    });
  }
}
