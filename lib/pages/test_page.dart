import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('TEST'),
          onPressed: () {
            FirebaseDatabase.instance.ref('test/').set({'test': true});
          },
        ),
      ),
    );
  }
}
