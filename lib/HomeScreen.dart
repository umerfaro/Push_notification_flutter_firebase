import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices=NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Notification Demo"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {

            notificationServices.getDeviceToken().then((value) async{
             // here we will send the notifications but this is static
              // for makign dynamic we will use firebase cloud functions
              // first we fetched store data in firebase cloud firestore
              // then use that data to send notifiacation thorugh this method
              var data = {
                'to' : value.toString(),//device token on which we will send the notifications
                'priority' : 'high',
                'notification' : {
                  'title' : 'oya' ,
                  'body' : 'sab theek ha bass chal raha ha' ,
                  "sound": "jetsons_doorbell.mp3"
                },
                'android': {
                  'notification': {
                    'notification_count': 23,
                  },
                },
                'data' : {
                  'type' : 'msj' ,
                  'id' : 'Umer farooq'
                }
              };
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),

                 body: jsonEncode(data),
             headers: {
               'Content-Type': 'application/json; charset=UTF-8',
               'Authorization' : 'key=AAAATalKPNc:APA91bH52QbMHv2dINHWU-5xGy7uhmU9phXU_qWI4zR5yIYrBjwWOhByw6mMyr_7dT6orKDkzge_-8ZlvaRqYCv-CPdsfaCHI8FaviRWQMDjwU8LOb3l5YvGY69VERYng7PSKGGXxWHO'
             }

             );

            });
          },
          child: Text("Send notifications"),
        )
      ),
    );
  }
}
