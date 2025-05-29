/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int totalDays = data['days'];
    final DateTime examDate = data['examDate'];

    if (topics.isEmpty || totalDays == 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = topics.length > 5 ? 3 : 2;
    final int studyDays = totalDays - revisionDays;

    final DateTime revisionStartDate = examDate.subtract(Duration(days: revisionDays));
    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = today.add(Duration(days: 1));
    final DateTime studyStartDate = proposedStudyStart;

    final int availableDays = revisionStartDate.difference(studyStartDate).inDays;

    if (availableDays <= 0 || studyDays <= 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      studyStartDate,
      revisionStartDate,
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );
  }

  Future<void> _saveSchedules() async {
    savedSchedules.add(newSchedule);
    final prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show success dialog and navigate to home
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Save"),
        content: Text("Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your study plan might not fit fully into the available time before the exam.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(Icons.save),
                label: Text('Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int days = data['days'];
    final DateTime examDate = data['examDate'];
    final DateTime startDate = examDate.subtract(Duration(days: days));

    schedule = generateSchedule(topics, days, startDate);

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: days,
      dailyPlan: schedule,
    );
  }

  Future<void> _saveSchedules() async {
    savedSchedules.add(newSchedule);
    final prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show success dialog and navigate to home
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {

              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Study Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "Your Daily Plan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final entry = schedule[index].entries.first;
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(entry.value.join(', ')),
                      leading:
                      Icon(Icons.calendar_today, color: Colors.deepPurple),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _saveSchedules,
              icon: Icon(Icons.save),
              label: Text('Save Schedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.green,
        tooltip: 'Exit',
       onPressed: () {
    Navigator.pop(context);

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    },
      ),
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int totalDays = data['days'];
    final DateTime examDate = data['examDate'];

    if (topics.isEmpty || totalDays == 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = topics.length > 5 ? 3 : 2;
    final int studyDays = totalDays - revisionDays;

    final DateTime revisionStartDate = examDate.subtract(Duration(days: revisionDays));
    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = today.add(Duration(days: 1));
    final DateTime studyStartDate = proposedStudyStart;

    final int availableDays = revisionStartDate.difference(studyStartDate).inDays;

    if (availableDays <= 0 || studyDays <= 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      studyStartDate,
      revisionStartDate,
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );
  }

  Future<void> _saveSchedules() async {
    savedSchedules.add(newSchedule);
    final prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson =
        savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show success dialog and navigate to home
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Save"),
        content: Text("Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your study plan might not fit fully into the available time before the exam.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(Icons.save),
                label: Text('Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For json.encode
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int days = data['days'];
    final DateTime examDate = data['examDate'];

    final DateTime startDate = examDate.subtract(Duration(days: days));
    schedule = generateSchedule(topics, days, startDate);

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: days,
      dailyPlan: schedule,
    );
  }

  Future<void> _saveSchedules() async {
    savedSchedules.add(newSchedule);
    final prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text('Schedule Saved!'),
        actions: [
          TextButton(
            onPressed: () {

              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false); // Go to Home
// Go to Home screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generated Schedule"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Exit without saving",
            onPressed: () {
              Navigator.pop(context); // Back to home without saving
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final entry = schedule[index].entries.first;
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.join(', ')),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveSchedules,
              child: Text('Save Schedule'),
            ),
          ),
        ],
      ),
    );
  }
/**/

 */
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int totalDays = data['days'];
    final DateTime examDate = data['examDate'];

    if (topics.isEmpty || totalDays == 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = topics.length > 5 ? 3 : 2;
    final int studyDays = totalDays - revisionDays;

    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = DateTime(today.year, today.month, today.day).add(Duration(days: 1));
    final DateTime revisionStartDate = examDate.subtract(Duration(days: revisionDays));

    final int availableDays = revisionStartDate.difference(proposedStudyStart).inDays + 1;

    if (availableDays <= 0 || studyDays <= 0 || availableDays < studyDays) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      proposedStudyStart,
      revisionStartDate,
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );
  }

  Future<void> _saveSchedules() async {
    savedSchedules.add(newSchedule);
    final prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show success dialog and navigate to home
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Save"),
        content: Text("Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your study plan might not fit fully into the available time before the exam.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(Icons.save),
                label: Text('Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    final List<String> topics = List<String>.from(data['topics']);
    final int totalDays = data['days'];
    final DateTime examDate = data['examDate'];

    isEditing = data['editing'] ?? false;

    if (topics.isEmpty || totalDays == 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = topics.length > 5 ? 3 : 2;
    final int studyDays = totalDays - revisionDays;

    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = DateTime(today.year, today.month, today.day).add(Duration(days: 1));
    final DateTime revisionStartDate = examDate.subtract(Duration(days: revisionDays));

    final int availableDays = revisionStartDate.difference(proposedStudyStart).inDays + 1;

    if (availableDays <= 0 || studyDays <= 0 || availableDays < studyDays) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      proposedStudyStart,
      revisionStartDate,
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your study plan might not fit fully into the available time before the exam.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    final List<String> topics = List<String>.from(data['topics']);
    final DateTime examDate = data['examDate'];
    isEditing = data['editing'] ?? false;

    if (topics.isEmpty || examDate.isBefore(DateTime.now())) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = DateTime(today.year, today.month, today.day).add(Duration(days: 1));
    final int totalDays = examDate.difference(proposedStudyStart).inDays + 1;

    if (totalDays <= 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = totalDays >= 3 ? 1 : 0;
    final int studyDays = totalDays - revisionDays;

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      proposedStudyStart,
      examDate.subtract(Duration(days: revisionDays)),
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  Schedule? newSchedule;
  List<Map<String, List<String>>> schedule = [];
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;
  bool isDataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isDataInitialized) return;

    final route = ModalRoute.of(context);
    if (route == null || route.settings.arguments == null) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final Map data = route.settings.arguments as Map;
    final List<String> topics = List<String>.from(data['topics']);
    final DateTime examDate = data['examDate'];
    isEditing = data['editing'] ?? false;

    if (topics.isEmpty || examDate.isBefore(DateTime.now())) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = DateTime(today.year, today.month, today.day).add(Duration(days: 1));
    final int totalDays = examDate.difference(proposedStudyStart).inDays + 1;

    if (totalDays <= 0) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = totalDays >= 3 ? 1 : 0;
    final int studyDays = totalDays - revisionDays;

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      proposedStudyStart,
      examDate.subtract(Duration(days: revisionDays)),
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }

    isDataInitialized = true;
  }

  Future<void> _saveSchedules() async {
    if (newSchedule == null) return;
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule!;
    } else {
      savedSchedules.add(newSchedule!);
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry.value.join(', ')),
                        leading: Icon(Icons.calendar_today,
                            color: Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    final List<String> topics = List<String>.from(data['topics']);
    final DateTime examDate = data['examDate'];
    isEditing = data['editing'] ?? false;

    if (topics.isEmpty || examDate.isBefore(DateTime.now())) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final DateTime today = DateTime.now();
    final DateTime proposedStudyStart = DateTime(today.year, today.month, today.day).add(Duration(days: 1));
    final int totalDays = examDate.difference(proposedStudyStart).inDays;

    if (totalDays < 1) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = totalDays >= 3 ? 1 : 0;
    final int studyDays = totalDays - revisionDays;

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      proposedStudyStart,
      examDate.subtract(Duration(days: revisionDays)),
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () => _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading: Icon(Icons.calendar_today,
                              color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    final List<String> topics = List<String>.from(data['topics']);
    final DateTime examDate = data['examDate'];
    isEditing = data['editing'] ?? false;

    final DateTime today = DateTime.now();
    final DateTime startDate = DateTime(today.year, today.month, today.day);
    final DateTime endDate = examDate.subtract(Duration(days: 1)); // One day before exam

    if (topics.isEmpty || endDate.isBefore(startDate)) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int totalDays = endDate.difference(startDate).inDays + 1;

    if (totalDays < 1) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    // Decide revision days: 1 day if totalDays >=3 else 0
    final int revisionDays = totalDays >= 3 ? 1 : 0;
    final int studyDays = totalDays - revisionDays;

    // Generate schedule from startDate to endDate (revision included in the last day(s) before exam)
    schedule = generateSmartSchedule(
      topics,
      studyDays,
      startDate,
      endDate.subtract(Duration(days: revisionDays)),
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () => _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading: Icon(Icons.calendar_today,
                              color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    final List<String> topics = List<String>.from(data['topics']);
    final DateTime examDate = data['examDate'];
    isEditing = data['editing'] ?? false;

    final DateTime today = DateTime.now();
    final DateTime startDate = DateTime(today.year, today.month, today.day);
    final DateTime endDate = examDate.subtract(Duration(days: 1));

    if (topics.isEmpty || endDate.isBefore(startDate)) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int totalDays = endDate.difference(startDate).inDays + 1;

    if (totalDays < 1) {
      setState(() {
        showWarning = true;
        schedule = [];
      });
      return;
    }

    final int revisionDays = totalDays >= 3 ? 1 : 0;
    final int studyDays = totalDays - revisionDays;

    schedule = generateSmartSchedule(
      topics,
      studyDays,
      startDate,
      endDate.subtract(Duration(days: revisionDays)),
      examDate,
    );

    newSchedule = Schedule(
      subject: data['subject'],
      topics: topics,
      examDate: examDate,
      daysToComplete: totalDays,
      dailyPlan: schedule,
    );

    if (isEditing) {
      editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
    }
  }

  // 🔥 Firestore Save Function
  Future<void> addSchedule(String title, String time) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add({
        'title': title,
        'time': time,
        'created_at': Timestamp.now(),
      });
    }
  }

  // 🧠 Save to SharedPreferences + Firestore
  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    // 👉 Save to Firestore as well
    for (var entry in schedule) {
      final day = entry.keys.first;
      final topics = entry[day]!;
      await addSchedule(day, topics.join(', '));
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(isEditing ? "Schedule updated successfully!" : "Schedule saved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () => _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading: Icon(Icons.calendar_today,
                              color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  late List<Map<String, List<String>>> schedule;
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    isEditing = data['isEditing'] ?? false;

    if (isEditing) {
      final Schedule scheduleToEdit = data['schedule'];
      schedule = scheduleToEdit.dailyPlan.cast<Map<String, List<String>>>();

    } else {
      final List<String> topics = List<String>.from(data['topics']);
      final DateTime examDate = data['examDate'];
      final String subject = data['subject'];

      final DateTime today = DateTime.now();
      final DateTime startDate = DateTime(today.year, today.month, today.day);
      final DateTime endDate = examDate.subtract(Duration(days: 1));

      if (topics.isEmpty || endDate.isBefore(startDate)) {
        setState(() {
          showWarning = true;
          schedule = [];
        });
        return;
      }

      final int totalDays = endDate.difference(startDate).inDays + 1;
      final int revisionDays = totalDays >= 3 ? 1 : 0;
      final int studyDays = totalDays - revisionDays;

      schedule = generateSmartSchedule(
        topics,
        studyDays,
        startDate,
        endDate.subtract(Duration(days: revisionDays)),
        examDate,
      );

      newSchedule = Schedule(
        subject: subject,
        topics: topics,
        examDate: examDate,
        daysToComplete: totalDays,
        dailyPlan: schedule,
      );
    }
  }


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final Map data = ModalRoute.of(context)!.settings.arguments as Map;
  //   final List<String> topics = List<String>.from(data['topics']);
  //   final DateTime examDate = data['examDate'];
  //   isEditing = data['editing'] ?? false;
  //
  //   final DateTime today = DateTime.now();
  //   final DateTime startDate = DateTime(today.year, today.month, today.day);
  //   final DateTime endDate = examDate.subtract(Duration(days: 1));
  //
  //   if (topics.isEmpty || endDate.isBefore(startDate)) {
  //     setState(() {
  //       showWarning = true;
  //       schedule = [];
  //     });
  //     return;
  //   }
  //
  //   final int totalDays = endDate.difference(startDate).inDays + 1;
  //
  //   if (totalDays < 1) {
  //     setState(() {
  //       showWarning = true;
  //       schedule = [];
  //     });
  //     return;
  //   }
  //
  //   final int revisionDays = totalDays >= 3 ? 1 : 0;
  //   final int studyDays = totalDays - revisionDays;
  //
  //   schedule = generateSmartSchedule(
  //     topics,
  //     studyDays,
  //     startDate,
  //     endDate.subtract(Duration(days: revisionDays)),
  //     examDate,
  //   );
  //
  //   newSchedule = Schedule(
  //     subject: data['subject'],
  //     topics: topics,
  //     examDate: examDate,
  //     daysToComplete: totalDays,
  //     dailyPlan: schedule,
  //   );
  //
  //   if (isEditing) {
  //     editingIndex = savedSchedules.indexWhere((s) => s.subject == data['subject']);
  //   }
  // }

  Future<void> addSchedule(String title, String time) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add({
        'title': title,
        'time': time,
        'created_at': Timestamp.now(),
      });
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    for (var entry in schedule) {
      final day = entry.keys.first;
      final topics = entry[day]!;
      await addSchedule(day, topics.join(', '));
    }

    // Save main schedule object as JSON to Firestore
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add(newSchedule.toJson());
    }

    List<String> schedulesJson = savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Schedule saved!")),
    );

    // Navigate to home screen
    //Navigator.popUntil(context, ModalRoute.withName('/home'));
    //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.pushReplacementNamed(context, '/home');



  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () => _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading: Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
        },
        child: Icon(Icons.home),
      ),
    );
  }
*/
/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  List<Map<String, List<String>>> schedule = [];
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null) return;

    isEditing = data['isEditing'] ?? false;

    if (isEditing) {
      final Schedule scheduleToEdit = data['schedule'];
      schedule = scheduleToEdit.dailyPlan.cast<Map<String, List<String>>>();
      newSchedule = scheduleToEdit;
    } else {
      final List<String> topics = List<String>.from(data['topics']);
      final DateTime examDate = data['examDate'];
      final String subject = data['subject'];

      final DateTime today = DateTime.now();
      final DateTime startDate = DateTime(today.year, today.month, today.day);
      final DateTime endDate = examDate.subtract(Duration(days: 1));

      if (topics.isEmpty || endDate.isBefore(startDate)) {
        setState(() {
          showWarning = true;
          schedule = [];
        });
        return;
      }

      final int totalDays = endDate.difference(startDate).inDays + 1;
      final int revisionDays = totalDays >= 3 ? 1 : 0;
      final int studyDays = totalDays - revisionDays;

      schedule = generateSmartSchedule(
        topics,
        studyDays,
        startDate,
        endDate.subtract(Duration(days: revisionDays)),
        examDate,
      );

      newSchedule = Schedule(
        subject: subject,
        topics: topics,
        examDate: examDate,
        daysToComplete: totalDays,
        dailyPlan: schedule,
      );
    }
  }

  Future<void> addSchedule(String title, String time) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add({
        'title': title,
        'time': time,
        'created_at': Timestamp.now(),
      });
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    for (var entry in schedule) {
      final day = entry.keys.first;
      final topics = entry[day]!;
      await addSchedule(day, topics.join(', '));
    }

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add(newSchedule.toJson());
    }

    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Schedule saved!")),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () =>
                          _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading:
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/scheduler_helper.dart';
import '../models/schedule_model.dart';
import '../data/schedule_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  List<Map<String, List<String>>> schedule = [];
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  // Assuming savedSchedules is defined somewhere globally or within your app state
  List<Schedule> savedSchedules = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data = ModalRoute.of(context)?.settings.arguments as Map?;
    if (data == null) return;

    isEditing = data['isEditing'] ?? false;

    if (isEditing) {
      final Schedule scheduleToEdit = data['schedule'];
      schedule = scheduleToEdit.dailyPlan.cast<Map<String, List<String>>>();
      newSchedule = scheduleToEdit;
      // Optionally find index to update later if you need
      editingIndex = savedSchedules.indexWhere((s) => s == scheduleToEdit);
    } else {
      final String subject = data['subject'];
      final List<String> topics = List<String>.from(data['topics']);
      final DateTime examDate = data['examDate'];

      final DateTime today = DateTime.now();
      final DateTime startDate = DateTime(today.year, today.month, today.day);
      final DateTime endDate = examDate.subtract(Duration(days: 1));

      if (topics.isEmpty || endDate.isBefore(startDate)) {
        setState(() {
          showWarning = true;
          schedule = [];
        });
        return;
      }

      final int totalDays = endDate.difference(startDate).inDays + 1;
      final int revisionDays = totalDays >= 3 ? 1 : 0;
      final int studyDays = totalDays - revisionDays;

      schedule = generateSmartSchedule(
        topics,
        studyDays,
        startDate,
        endDate.subtract(Duration(days: revisionDays)),
        examDate,
      );

      newSchedule = Schedule(
        subject: subject,
        topics: topics,
        examDate: examDate,
        daysToComplete: totalDays,
        dailyPlan: schedule,
      );
    }
  }

  Future<void> addSchedule(String title, String time) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add({
        'title': title,
        'time': time,
        'created_at': Timestamp.now(),
      });
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    // Save each day's plan to Firestore
    for (var entry in schedule) {
      final day = entry.keys.first;
      final topics = entry[day]!;
      await addSchedule(day, topics.join(', '));
    }

    // Save the entire schedule object to Firestore for backup or reference
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add(newSchedule.toJson());
    }

    // Save all schedules locally as JSON strings
    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Schedule saved!")),
    );
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () =>
                          _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading:
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Go Home',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Icon(Icons.home),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoGenerateScreen extends StatefulWidget {
  @override
  _AutoGenerateScreenState createState() => _AutoGenerateScreenState();
}

class _AutoGenerateScreenState extends State<AutoGenerateScreen> {
  late Schedule newSchedule;
  List<Map<String, List<String>>> schedule = [];
  bool showWarning = false;
  bool isEditing = false;
  int? editingIndex;

  // Added generateSmartSchedule function here
  List<Map<String, List<String>>> generateSmartSchedule(
      List<String> topics,
      int studyDays,
      DateTime startDate,
      DateTime endDate,
      DateTime examDate,
      ) {
    List<Map<String, List<String>>> schedule = [];
    int topicIndex = 0;
    for (int i = 0; i < studyDays; i++) {
      DateTime currentDay = startDate.add(Duration(days: i));
      String dayKey = "${currentDay.day}/${currentDay.month}/${currentDay.year}";

      // Assign topics one per day cycling through list
      List<String> dayTopics = [];
      if (topics.isNotEmpty) {
        dayTopics.add(topics[topicIndex % topics.length]);
        topicIndex++;
      }

      schedule.add({dayKey: dayTopics});
    }
    return schedule;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null) return;

    isEditing = data['isEditing'] ?? false;

    if (isEditing) {
      final Schedule scheduleToEdit = data['schedule'];
      schedule = scheduleToEdit.dailyPlan.cast<Map<String, List<String>>>();
      newSchedule = scheduleToEdit;
    } else {
      final List<String> topics = List<String>.from(data['topics']);
      final DateTime examDate = data['examDate'];
      final String subject = data['subject'];

      final DateTime today = DateTime.now();
      final DateTime startDate = DateTime(today.year, today.month, today.day);
      final DateTime endDate = examDate.subtract(Duration(days: 1));

      if (topics.isEmpty || endDate.isBefore(startDate)) {
        setState(() {
          showWarning = true;
          schedule = [];
        });
        return;
      }

      final int totalDays = endDate.difference(startDate).inDays + 1;
      final int revisionDays = totalDays >= 3 ? 1 : 0;
      final int studyDays = totalDays - revisionDays;

      schedule = generateSmartSchedule(
        topics,
        studyDays,
        startDate,
        endDate.subtract(Duration(days: revisionDays)),
        examDate,
      );

      newSchedule = Schedule(
        subject: subject,
        topics: topics,
        examDate: examDate,
        daysToComplete: totalDays,
        dailyPlan: schedule,
      );
    }
  }

  Future<void> addSchedule(String title, String time) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add({
        'title': title,
        'time': time,
        'created_at': Timestamp.now(),
      });
    }
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    // You need to have savedSchedules list somewhere (make sure it is defined in your class or imported)
    // For now let's assume savedSchedules is global or passed in

    if (isEditing && editingIndex != null && editingIndex! >= 0) {
      savedSchedules[editingIndex!] = newSchedule;
    } else {
      savedSchedules.add(newSchedule);
    }

    for (var entry in schedule) {
      final day = entry.keys.first;
      final topics = entry[day]!;
      await addSchedule(day, topics.join(', '));
    }

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedules')
          .add(newSchedule.toJson());
    }

    List<String> schedulesJson =
    savedSchedules.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('schedules', schedulesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Schedule saved!")),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showConfirmationBeforeSave() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Confirm Update" : "Confirm Save"),
        content: Text(isEditing
            ? "Do you want to update this schedule?"
            : "Do you want to save this schedule?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveSchedules();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetailsDialog(String day, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(day),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: topics.map((topic) => Text("• $topic")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Schedule" : "Smart Study + Revision Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (showWarning)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cannot generate schedule. Please check your inputs.",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
            if (!showWarning)
              Text(
                isEditing ? "Updated Smart Plan" : "Your Daily Smart Plan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final entry = schedule[index].entries.first;
                    return GestureDetector(
                      onTap: () =>
                          _showScheduleDetailsDialog(entry.key, entry.value),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.join(', ')),
                          leading:
                          Icon(Icons.calendar_today, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 10),
            if (!showWarning)
              ElevatedButton.icon(
                onPressed: _showConfirmationBeforeSave,
                icon: Icon(isEditing ? Icons.update : Icons.save),
                label: Text(isEditing ? 'Update Schedule' : 'Save Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orange : Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: 'Exit',
        onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
        },
        child: Icon(Icons.home),
      ),
    );
  }
}

