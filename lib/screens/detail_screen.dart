/*import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class DetailScreen extends StatelessWidget {
  final Schedule schedule;
  DetailScreen({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${schedule.subject} Details')),
      body: ListView.builder(
        itemCount: schedule.dailyPlan.length,
        itemBuilder: (context, index) {
          final entry = schedule.dailyPlan[index].entries.first;
          return Card(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.join(', ')),
            ),
          );
        },
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class DetailScreen extends StatelessWidget {
  final Schedule schedule;
  final int index; // Pass index to identify which schedule to update

  DetailScreen({required this.schedule, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${schedule.subject} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/generator',
                arguments: {
                  'isEditing': true,
                  'schedule': schedule,
                  'index': index,
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: schedule.dailyPlan.length,
        itemBuilder: (context, index) {
          final entry = schedule.dailyPlan[index].entries.first;
          return Card(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.join(', ')),
            ),
          );
        },
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class DetailScreen extends StatelessWidget {
  final Schedule schedule;
  final int index; // Index used to track and update specific schedule

  const DetailScreen({
    Key? key,
    required this.schedule,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${schedule.subject} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigator.pushNamed(
              //   context,
              //   '/generator',
              //   arguments: {
              //     'isEditing': true,
              //     'schedule': schedule,
              //     'index': index,
              //   },
              Navigator.pushNamed(
                context,
                '/generator',
                arguments: {
                  'isEditing': true,
                  'schedule': schedule,
                  'index': index,
                },
              );


            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: schedule.dailyPlan.length,
        itemBuilder: (context, dayIndex) {
          final dayData = schedule.dailyPlan[dayIndex];
          final entry = dayData.entries.first;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(entry.key), // e.g., "Day 1"
              subtitle: Text(entry.value.join(', ')), // e.g., topics list
              leading: CircleAvatar(
                child: Text('${dayIndex + 1}'),
              ),
            ),
          );
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class DetailScreen extends StatelessWidget {
  final Schedule schedule;
  final int index;

  const DetailScreen({Key? key, required this.schedule, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Schedule Subject: ${schedule.subject}'); // debug print

    return Scaffold(
      appBar: AppBar(
        title: Text('${schedule.subject} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/generator',
                arguments: {
                  'isEditing': true,
                  'schedule': schedule,
                  'index': index,
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: schedule.dailyPlan.length,
        itemBuilder: (context, dayIndex) {
          final dayData = schedule.dailyPlan[dayIndex];
          final entry = dayData.entries.first;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.join(', ')),
              leading: CircleAvatar(child: Text('${dayIndex + 1}')),
            ),
          );
        },
      ),
    );
  }
}
