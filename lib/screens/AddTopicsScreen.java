import 'package:flutter/material.dart';

class AddTopicsScreen extends StatefulWidget {
  @override
  _AddTopicsScreenState createState() => _AddTopicsScreenState();
}

class _AddTopicsScreenState extends State<AddTopicsScreen> {
  final List<String> topics = [];
  final TextEditingController _topicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String subject = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("📚 Add Topics for $subject"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    labelText: "Enter a Topic (optional)",
                    hintText: "e.g. Algebra, Probability",
                    prefixIcon: Icon(Icons.topic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                if (_topicController.text.trim().isNotEmpty) {
                  setState(() {
                    topics.add(_topicController.text.trim());
                    _topicController.clear();
                  });
                }
              },
              icon: Icon(Icons.add),
              label: Text("Add Topic"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: topics.isEmpty
                  ? Center(
                      child: Text(
                        "No topics added yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) => Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                          title: Text(topics[index]),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/setExamDate',
                    arguments: {'subject': subject, 'topics': topics},
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
