/*import 'package:flutter/material.dart';
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Schedules')),
      body: savedSchedules.isEmpty
          ? Center(child: Text('No schedules yet'))
          : ListView.builder(
        itemCount: savedSchedules.length,
        itemBuilder: (context, index) {
          final s = savedSchedules[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(s.subject),
              subtitle: Text('Complete in ${s.daysToComplete} days by ${s.examDate.toLocal().toString().split(' ')[0]}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(schedule: s),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              child: Text('Auto Generate'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Custom (Coming soon)'),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.from(
        examDate.subtract(Duration(days: 1)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode, // unique id per subject
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(schedule: schedule),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(
                                schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Reminder set for ${schedule.subject}!")),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime =
    tz.TZDateTime.from(examDate.subtract(Duration(days: 1)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(schedule: schedule),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(
                                schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Reminder set for ${schedule.subject}!")),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime =
    tz.TZDateTime.from(examDate.subtract(Duration(days: 1)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      schedule: schedule,
                      index: index, // ✅ FIXED: Pass required index
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(
                                schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Reminder set for ${schedule.subject}!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime =
    tz.TZDateTime.from(examDate.subtract(Duration(days: 1)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      schedule: schedule,
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(
                                schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Reminder set for ${schedule.subject}!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomGeneratorScreen()),
                );
                await loadSchedules(); // Refresh the list when returning
              },
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Added

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// ✅ Logout function
void logoutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/lib/screens/login_screen.dart'); // Replace with your login route
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime =
    tz.TZDateTime.from(examDate.subtract(Duration(days: 1)), tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [ // ✅ Logout button added here
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      schedule: schedule,
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(
                                schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Reminder set for ${schedule.subject}!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }
  // ✅ Logout function
  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/lib/screens/login_screen.dart'); // Replace with your login route
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.from(
      examDate.subtract(Duration(days: 1)),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      schedule: schedule,
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Reminder set for ${schedule.subject}!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// ✅ Logout function
void logoutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/login');

}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSchedules();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap action here
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.from(
      examDate.subtract(Duration(days: 1)),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('schedules') ?? [];
    savedSchedules.clear();
    savedSchedules.addAll(data.map((e) => Schedule.fromJson(json.decode(e))));
    setState(() {});
  }

  Future<void> _deleteSchedule(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedSchedules.removeAt(index);
    });
    final updatedData = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: savedSchedules.isEmpty
          ? Center(
        child: Text(
          'No schedules yet!',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: savedSchedules.length,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final schedule = savedSchedules[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      schedule: schedule,
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subject,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📅 Exam Date: ${schedule.examDate.toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "📖 Days to Complete: ${schedule.daysToComplete}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _deleteSchedule(index),
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await scheduleReminder(schedule.examDate, schedule.subject);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Reminder set for ${schedule.subject}!"),
                              ),
                            );
                          },
                          icon: Icon(Icons.alarm),
                          label: Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/addSubject'),
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void logoutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/login');
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final scheduledTime = tz.TZDateTime.from(
      examDate.subtract(Duration(days: 1)),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('schedules')
            .orderBy('created_at')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final schedules = snapshot.data!.docs;

          if (schedules.isEmpty) {
            return Center(
              child: Text(
                'No schedules yet!',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: schedules.length,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final data = schedules[index].data() as Map<String, dynamic>;
              final subject = data['subject'] ?? 'No Subject';
              final examDate = data['examDate'] != null
                  ? DateTime.parse(data['examDate'])
                  : DateTime.now();
              final daysToComplete = data['daysToComplete']?.toString() ?? '0';
              final topics = List<String>.from(data['topics'] ?? []);
              final dailyPlan = List<Map<String, dynamic>>.from(data['dailyPlan'] ?? []);


              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    final topics = List<String>.from(data['topics'] ?? []);

                    final dailyPlan = List<Map<String, dynamic>>.from(data['dailyPlan'] ?? []);

                    final scheduleData = Schedule(
                      subject: subject,
                      examDate: examDate,
                      daysToComplete: int.parse(daysToComplete),
                      topics: topics,
                      dailyPlan: dailyPlan,
                    );


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          schedule: scheduleData,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "📅 Exam Date: ${examDate.toString().split(' ')[0]}",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "📖 Days to Complete: $daysToComplete",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('schedules')
                                    .doc(schedules[index].id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                              label: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await scheduleReminder(examDate, subject);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                    Text("Reminder set for $subject!"),
                                  ),
                                );
                              },
                              icon: Icon(Icons.alarm),
                              label: Text("Set Reminder"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result =
                await Navigator.pushNamed(context, '/addSubject');
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ Schedule saved!')),
                  );
                }
              },
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Implement if needed
              },
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void logoutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/login');
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final scheduledTime = tz.TZDateTime.from(
      examDate.subtract(Duration(days: 1)),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('schedules')
            .orderBy('created_at')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final schedules = snapshot.data!.docs;

          if (schedules.isEmpty) {
            return Center(
              child: Text(
                'No schedules yet!',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: schedules.length,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final data = schedules[index].data() as Map<String, dynamic>;
              final subject = data['subject']?.toString() ??
                  'No Subject'; // ✅ Make sure this gets the subject
              final examDate = data['examDate'] != null
                  ? DateTime.parse(data['examDate'])
                  : DateTime.now();
              final daysToComplete = data['daysToComplete']?.toString() ?? '0';
              final topics = List<String>.from(data['topics'] ?? []);
              final dailyPlan = List<Map<String, dynamic>>.from(
                  data['dailyPlan'] ?? []);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    final scheduleData = Schedule(
                      subject: subject,
                      examDate: examDate,
                      daysToComplete: int.parse(daysToComplete),
                      topics: topics,
                      dailyPlan: dailyPlan,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(
                              schedule: scheduleData,
                              index: index,
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject, // ✅ This will now correctly show the subject
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "📅 Exam Date: ${examDate.toString().split(' ')[0]}",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "📖 Days to Complete: $daysToComplete",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('schedules')
                                    .doc(schedules[index].id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                              label: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await scheduleReminder(examDate, subject);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Reminder set for $subject!"),
                                  ),
                                );
                              },
                              icon: Icon(Icons.alarm),
                              label: Text("Set Reminder"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                    context, '/addSubject');
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ Schedule saved!')),
                  );
                }
              },
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Reserved for Custom Button logic
              },
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/schedule_model.dart';
import 'detail_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void logoutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/login');
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap if needed
  }

  Future<void> scheduleReminder(DateTime examDate, String subject) async {
    final androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Exam Schedules',
      channelDescription: 'Reminder for upcoming exams',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final scheduledTime = tz.TZDateTime.from(
      examDate.subtract(Duration(days: 1)),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      subject.hashCode,
      '📚 Reminder: $subject Exam',
      'Prepare for your upcoming $subject exam!',
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('📚 My Exam Schedules'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('schedules')
            .orderBy('created_at')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final schedules = snapshot.data!.docs;

          if (schedules.isEmpty) {
            return Center(
              child: Text(
                'No schedules yet!',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: schedules.length,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final data = schedules[index].data() as Map<String, dynamic>;
              final subject = data['subject']?.toString() ?? 'No Subject';
              final examDateStr = data['examDate']?.toString();
              final examDate = examDateStr != null
                  ? DateTime.tryParse(examDateStr)
                  : null;
              final examDateFormatted = examDate != null
                  ? DateFormat('dd MMM yyyy').format(examDate)
                  : 'No Date';
              final daysToComplete = data['daysToComplete']?.toString() ?? '0';
              final topics = List<String>.from(data['topics'] ?? []);
              final dailyPlan = List<Map<String, dynamic>>.from(data['dailyPlan'] ?? []);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    final scheduleData = Schedule(
                      subject: subject,
                      examDate: examDate ?? DateTime.now(),
                      daysToComplete: int.parse(daysToComplete),
                      topics: topics,
                      dailyPlan: dailyPlan,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          schedule: scheduleData,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "📅 Exam Date: $examDateFormatted",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "📖 Days to Complete: $daysToComplete",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('schedules')
                                    .doc(schedules[index].id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                              label: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (examDate != null) {
                                  await scheduleReminder(examDate, subject);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Reminder set for $subject!"),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.alarm),
                              label: Text("Set Reminder"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/addSubject');
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ Schedule saved!')),
                  );
                }
              },
              icon: Icon(Icons.auto_awesome),
              label: Text('Auto Generate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Reserved for Custom Button logic
              },
              icon: Icon(Icons.edit_calendar),
              label: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Schedule')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('schedules').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No schedules found.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final date = data['date'] ?? 'No Date';
              final topics = List<String>.from(data['topics'] ?? []);

              return ListTile(
                title: Text(date),
                subtitle: Text(topics.join(', ')),
              );
            },
          );
        },
      ),
    );
  }
}
