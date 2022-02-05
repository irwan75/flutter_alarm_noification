import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
// import 'dart:ui';

// import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification.dart' as notify;

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate4';

// /// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Register the UI isolate's SendPort to allow for communication from the
//   // background isolate.
//   IsolateNameServer.registerPortWithName(
//     port.sendPort,
//     isolateName,
//   );

//   notify.initNotifications();

//   AndroidAlarmManager.initialize();

//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // // The background
  static SendPort uiSendPort;

  String kalimat = "isolateji";

  Future<void> showNotification(data) async {
    print("Dataku $data");
    var rand = Random();
    var hash = rand.nextInt(100);
    DateTime now = DateTime.now().toUtc().add(Duration(seconds: 1));

    await notify.singleNotification(
      now,
      "Hello $hash",
      "This is hello message",
      hash,
    );
    setState(() {
      kalimat = "okee boss";
    });
  }

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');
    // // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send("hi");
  }

  // @override
  // void initState() {
  //   super.initState();

  //   port.listen((data) async => await showNotification(data));

  //   runAlarm();
  // }

  // void runAlarm() async {
  //   await AndroidAlarmManager.periodic(
  //     Duration(minutes: 5),
  //     0,
  //     callback,
  //     rescheduleOnReboot: true,
  //     exact: true,
  //     wakeup: true,
  //   );
  //   print("OK");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$kalimat"),
          ],
        ),
      ),
    );
  }
}

// import 'dart:isolate';

// import 'package:android_alarm_manager/android_alarm_manager.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
//   Dio().get('https://www.gekongfei.cn/debug?_t=$now&isolate=$isolateId&function=$printHello');
// }

// void printHello() {
//   print("Mantapp");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final int helloAlarmID = 0;
//   await AndroidAlarmManager.initialize();
//   runApp(MyApp());
//   await AndroidAlarmManager.periodic(
//       Duration(seconds: 10), helloAlarmID, printHello);
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Hello, World'),
//       ),
//     );
//   }
// }
