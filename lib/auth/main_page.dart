import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugas_kelompok/auth/auth_pages.dart';
import 'package:tugas_kelompok/firebase/test_firestore.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return fireStore();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
