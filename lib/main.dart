import 'package:S6Chat/models/user.dart';
import 'package:S6Chat/screens/homeLanding.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
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
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                color: Colors.white ?? Color(0xFF6548D1) ?? Colors.black),
            primaryColor: Color(0xFF157AE1) ?? Color(0xFF075E55),
            textTheme: GoogleFonts.latoTextTheme()),
        home: LandingPage(),
      ),
    );
  }
}
