import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vedio_app/main.dart';

class FirebaseApi {
  //create an instance of Firebase Messaging
  final firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize notifications
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    //fetch the FCM token for this device
    final fCMToken = await firebaseMessaging.getToken();

    //print the token
    print('Token : $fCMToken');

    //initialize further settings for push noti
    initPushNotifications();
  }

  //function to handle received messages
  void handleMessage(RemoteMessage? message) {
    //if the message is null, do nothing
    if (message == null) return;

    //navigate to new screen
    navigatorKey.currentState?.pushNamed(
      '/video_viewer',
      arguments: message,
    );
  }

  //function to initialize foreground and background settings
  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
