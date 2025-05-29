/*List<Map<String, List<String>>> generateSmartSchedule(
    List<String> topics,
    int studyDays,
    DateTime studyStartDate,
    DateTime revisionStartDate,
    DateTime examDate,
    ) {
  final List<Map<String, List<String>>> schedule = [];

  // Divide topics across studyDays
  int topicsPerDay = (topics.length / studyDays).ceil();
  int currentIndex = 0;

  for (int i = 0; i < studyDays; i++) {
    final dayTopics = topics.sublist(
      currentIndex,
      currentIndex + topicsPerDay > topics.length ? topics.length : currentIndex + topicsPerDay,
    );
    final date = studyStartDate.add(Duration(days: i));
    schedule.add({formatDate(date): dayTopics});
    currentIndex += topicsPerDay;
  }

  // Add fixed revision for 2 days before exam
  for (int i = 0; i < 2; i++) {
    final date = revisionStartDate.add(Duration(days: i));
    schedule.add({formatDate(date): ["Revision"]});
  }

  return schedule;
}

String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
*/
/*import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

Future<void> saveSchedule(List<Map<String, List<String>>> schedule) async {
  for (var daySchedule in schedule) {
    String date = daySchedule.keys.first;
    List<String> topics = daySchedule.values.first;

    await _firestore.collection('schedules').doc(date).set({
      'date': date,
      'topics': topics,
    });
  }
}

List<Map<String, List<String>>> generateSmartSchedule(
    List<String> topics,
    int studyDays,
    DateTime studyStartDate,
    DateTime revisionStartDate,
    DateTime examDate,
    ) {
  final List<Map<String, List<String>>> schedule = [];

  if (topics.isEmpty || studyDays <= 0) return schedule;

  if (studyDays == 1) {
    schedule.add({formatDate(studyStartDate): topics});
    return schedule;
  }

  int topicsPerDay = (topics.length / studyDays).ceil();
  int currentIndex = 0;

  for (int i = 0; i < studyDays && currentIndex < topics.length; i++) {
    final dayTopics = topics.sublist(
      currentIndex,
      (currentIndex + topicsPerDay > topics.length)
          ? topics.length
          : currentIndex + topicsPerDay,
    );
    final date = studyStartDate.add(Duration(days: i));
    schedule.add({formatDate(date): dayTopics});
    currentIndex += topicsPerDay;
  }

  final revisionDate = revisionStartDate;
  if (revisionDate.isAfter(studyStartDate)) {
    schedule.add({formatDate(revisionDate): ["Revision"]});
  }

  return schedule;
}
*/import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart'; // Your Schedule model import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Schedule> schedules = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle no logged-in user case
      setState(() {
        schedules = [];
        isLoading = false;
      });
      return;
    }

    userId = user.uid;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .get();

      schedules = snapshot.docs
          .map((doc) => Schedule.fromJson(doc.data()))
          .toList();

    } catch (e) {
      print('Error fetching schedules: $e');
      schedules = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Schedules')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Schedules')),
      body: schedules.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No schedules available.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add your auto-generate schedules logic here
                print('Auto-generate schedules button pressed');
              },
              child: Text('Auto Generate Schedules'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(schedule.subject),
              subtitle: Text(
                  'Exam Date: ${schedule.examDate.toLocal().toString().split(' ')[0]}'
              ),
              onTap: () {
                // Optionally: Navigate to details screen
              },
            ),
          );
        },
      ),
    );
  }
}
