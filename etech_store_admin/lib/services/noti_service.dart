import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/monitoring/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Contants {
static Future<String> getAccessToken() async {
  await dotenv.load(fileName: 'assets/noti.env');

  final serviceAccountJson = {
    "type": dotenv.env['TYPE'],
    "project_id": dotenv.env['PROJECT_ID'],
    "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
    "private_key": dotenv.env['PRIVATE_KEY'],
    "client_email": dotenv.env['CLIENT_EMAIL'],
    "client_id": dotenv.env['CLIENT_ID'],
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": dotenv.env['CLIENT_X509_CERT_URL'],
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging",
  ];

  http.Client client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);

  client.close();

  return credentials.accessToken.data;
}


  static Future<void> sendNotificationToUser(String uid, String title, String body) async {
    try {
      // Lấy token từ Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        String tokenUser = userDoc.get('token');

        if (tokenUser.isNotEmpty) {
          final String serverAccessTokenKey = await getAccessToken();

          String endPoinFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/etechstore-abe5c/messages:send';

          final Map<String, dynamic> message = {
            'message': {
              'token': tokenUser,
              'notification': {"title": title, "body": body},
              'data': {
                "uid": uid,
               }
            }
          };

          final http.Response response = await http.post(Uri.parse(endPoinFirebaseCloudMessaging),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $serverAccessTokenKey',
              },
              body: jsonEncode(message));

          if (response.statusCode == 200) {
            print("Notification sent successfully.");
          } else {
            print("Failed to send FCM message: ${response.statusCode}");
          }
        } else {
          print("User token is empty");
        }
      } else {
        print("User does not exist");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
  /* static const String BASE_URL = 'POST https://fcm.googleapis.com/v1/projects/etechstore-abe5c/messages:send';

  static String KEY_SERVER = '';

  static String SENDER_ID = '';
}

class NotificationService {
  Future<bool> pushNotifications({required String title, body, token}) async {
    Map<String, dynamic> payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
        "sound": "defauld",
      }
    };
    String dataNotifications = jsonEncode(payload);

    var response = await http.post(Uri.parse(Contants.BASE_URL), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key= ${Contants.KEY_SERVER}',
      body: dataNotifications,
    });
    debugPrint(response.body.toString());
    return true;
  } */
}
