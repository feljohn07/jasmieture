import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Firstname,'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Middlename,'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Lastname,'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Age,'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Section'),
          ),
        ],
      ),
    );
  }
}
