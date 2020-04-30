import 'package:S6Chat/models/user.dart';
import 'package:S6Chat/screens/otpPage.dart';
import 'package:S6Chat/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user != null)
      return Dashboard(
        uid: user.uid,
      );
    else
      return OtpPage();
  }
}
