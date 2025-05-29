/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date

class SetExamDateScreen extends StatefulWidget {
  @override
  _SetExamDateScreenState createState() => _SetExamDateScreenState();
}

class _SetExamDateScreenState extends State<SetExamDateScreen> {
  DateTime? selectedDate;
  final _daysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("📅 Set Exam Date"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Exam Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Tap to pick a date"
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Icon(Icons.calendar_today, color: Colors.deepPurple),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Complete in how many days?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "e.g. 10",
                prefixIcon: Icon(Icons.timelapse),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate == null || _daysController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a date and enter days')),
                    );
                    return;
                  }

                  // Ensure valid input for the number of days
                  final days = int.tryParse(_daysController.text);
                  if (days == null || days <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid number of days')),
                    );
                    return;
                  }

                  // Proceed to the next screen with valid data
                  Navigator.pushNamed(
                    context,
                    '/autoGenerate',
                    arguments: {
                      'subject': data['subject'],
                      'topics': data['topics'],
                      'examDate': selectedDate,
                      'days': days,
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text("Next", style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SetExamDateScreen extends StatefulWidget {
  @override
  _SetExamDateScreenState createState() => _SetExamDateScreenState();
}

class _SetExamDateScreenState extends State<SetExamDateScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("📅 Set Exam Date"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Exam Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });

                  // Directly go to next screen after picking date
                  Navigator.pushNamed(
                    context,
                    '/autoGenerate',
                    arguments: {
                      'subject': data['subject'],
                      'topics': data['topics'],
                      'examDate': picked,
                    },
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Tap to pick a date"
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Icon(Icons.calendar_today, color: Colors.deepPurple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

