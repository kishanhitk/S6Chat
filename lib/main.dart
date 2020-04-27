import 'package:S6Chat/models/user.dart';
import 'package:S6Chat/screens/homeLanding.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:S6Chat/screens/userRegPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color(0xFF075E55)),
        home: LandingPage(),
      ),
    );
  }
}
