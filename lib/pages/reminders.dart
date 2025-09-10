import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersState();
}

class _RemindersState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Welcome to the Reminders Page'));
  }
}