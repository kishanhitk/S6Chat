import 'package:S6Chat/services/auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String uid;
  Dashboard({this.uid});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.person), onPressed: () {}),
        centerTitle: true,
        title: Text("S6 Chat"),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            color: Colors.amber,
            onPressed: () async {
              _auth.signOut();
            },
            child: Text(widget.uid),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}