/*import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/add_topics_screen.dart';
import 'screens/set_exam_date_screen.dart';
import 'screens/auto_generate_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addSubject': (context) => AddSubjectScreen(),
        '/addTopics': (context) => AddTopicsScreen(),
        '/setExamDate': (context) => SetExamDateScreen(),
        '/autoGenerate': (context) => AutoGenerateScreen(),
      },
      // onGenerateRoute is only needed if you are dynamically passing data
      onGenerateRoute: (RouteSettings settings) {
        // This ensures that if a route is not found, it does not throw a null check error.
        if (settings.name == '/addSubject') {
          return MaterialPageRoute(builder: (context) => AddSubjectScreen());
        } else if (settings.name == '/addTopics') {
          return MaterialPageRoute(builder: (context) => AddTopicsScreen());
        } else if (settings.name == '/setExamDate') {
          return MaterialPageRoute(builder: (context) => SetExamDateScreen());
        } else if (settings.name == '/autoGenerate') {
          return MaterialPageRoute(builder: (context) => AutoGenerateScreen());
        }
        return null; // In case of undefined routes
      },
      // Handles undefined or incorrect routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: Text("Page Not Found")),
            body: Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/add_topics_screen.dart';
import 'screens/set_exam_date_screen.dart';
import 'screens/auto_generate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addSubject': (context) => AddSubjectScreen(),
        '/addTopics': (context) => AddTopicsScreen(),
        '/setExamDate': (context) => SetExamDateScreen(),
        '/autoGenerate': (context) => AutoGenerateScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/addSubject') {
          return MaterialPageRoute(builder: (context) => AddSubjectScreen());
        } else if (settings.name == '/addTopics') {
          return MaterialPageRoute(builder: (context) => AddTopicsScreen());
        } else if (settings.name == '/setExamDate') {
          return MaterialPageRoute(builder: (context) => SetExamDateScreen());
        } else if (settings.name == '/autoGenerate') {
          return MaterialPageRoute(builder: (context) => AutoGenerateScreen());
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: Text("Page Not Found")),
            body: Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/add_topics_screen.dart';
import 'screens/set_exam_date_screen.dart';
import 'screens/auto_generate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure Flutter binding initialized before async calls
  await Firebase.initializeApp();             // Initialize Firebase before running app
  runApp(const MyApp());                       // Run the root app widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/': (context) => HomeScreen(),
        '/addSubject': (context) => AddSubjectScreen(),
        '/addTopics': (context) => AddTopicsScreen(),
        '/setExamDate': (context) => SetExamDateScreen(),
        '/autoGenerate': (context) => AutoGenerateScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text("Page Not Found")),
            body: const Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}*/
/*import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/add_topics_screen.dart';
import 'screens/set_exam_date_screen.dart';
import 'screens/auto_generate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/addSubject': (context) => AddSubjectScreen(),
        '/addTopics': (context) => AddTopicsScreen(),
        '/setExamDate': (context) => SetExamDateScreen(),
        '/autoGenerate': (context) => AutoGenerateScreen(),
      },


      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/addSubject') {
          return MaterialPageRoute(builder: (context) => AddSubjectScreen());
        } else if (settings.name == '/addTopics') {
          return MaterialPageRoute(builder: (context) => AddTopicsScreen());
    } else if (settings.name == '/setExamDate') {
    return MaterialPageRoute(builder: (context) => SetExamDateScreen());
    } else if (settings.name == '/autoGenerate') {
    return MaterialPageRoute(builder: (context) => AutoGenerateScreen());
    }
    return null;
  },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text("Page Not Found")),
            body: const Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Import your Firebase options generated by flutterfire configure
import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Initialized'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Firebase + Flutter!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}*/
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/add_topics_screen.dart';
import 'screens/set_exam_date_screen.dart';
import 'screens/auto_generate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/addSubject': (context) => AddSubjectScreen(),
        '/addTopics': (context) => AddTopicsScreen(),
        '/setExamDate': (context) => SetExamDateScreen(),
        '/autoGenerate': (context) => AutoGenerateScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/addSubject':
            return MaterialPageRoute(builder: (context) => AddSubjectScreen());
          case '/addTopics':
            return MaterialPageRoute(builder: (context) => AddTopicsScreen());
          case '/setExamDate':
            return MaterialPageRoute(builder: (context) => SetExamDateScreen());
          case '/autoGenerate':
            return MaterialPageRoute(builder: (context) => AutoGenerateScreen());
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: const Text("Page Not Found")),
            body: const Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}
