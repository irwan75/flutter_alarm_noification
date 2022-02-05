import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocalNotifications(),
    );
  }
}

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('ic_notification');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  int a = 1;

  Future _showNotificationWithSound(int a) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id $a',
        'your channel name $a',
        'your channel description $a',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            playSound: true,
            onlyAlertOnce: true,
            channelShowBadge: true,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'please subscribe my channel', notificationDetails,
        payload: 'Default_Sound');
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(minutes: 1));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    for (int i = 1; i < 4; i++) {
      await flutterLocalNotificationsPlugin.schedule(i, 'Hello there',
          'please subscribe my channel', timeDelayed, notificationDetails);
    }
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print("Payload dalam if $payLoad");
    }
    print("Payload diluar if $payLoad");

    // we can set navigator to navigate another screen
  }

  // Future<void> onSelectNotifications(String payload) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SecondScreen(payload)),
  //   );
  // }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<List<PendingNotificationRequest>> retrieveListNotification() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Set State",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                await flutterLocalNotificationsPlugin.cancelAll();
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Candel Notification",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                _showNotificationWithSound(a);
                a++;
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Show Notification",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            // FlatButton(
            //   color: Colors.blue,
            //   onPressed: _showNotificationWithSound,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(
            //       "Show Notification",
            //       style: TextStyle(fontSize: 20.0, color: Colors.white),
            //     ),
            //   ),
            // ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                _showNotificationsAfterSecond();
                a++;
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Show Notification After Sec",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FutureBuilder<List<PendingNotificationRequest>>(
              future: retrieveListNotification(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var hasil = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: hasil.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("id ${hasil[index].id}"),
                            Text("title ${hasil[index].title}"),
                            Text("body ${hasil[index].body}"),
                            Text("payload ${hasil[index].payload}"),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            // FlatButton(
            //   color: Colors.blue,
            //   onPressed: _showNotificationsAfterSecond(),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(
            //       "Show Notification after few sec",
            //       style: TextStyle(fontSize: 20.0, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
