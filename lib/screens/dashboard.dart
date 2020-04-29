import 'package:S6Chat/screens/chatPage.dart';
import 'package:S6Chat/screens/grpChatListPage.dart';
import 'package:S6Chat/screens/profilePage.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  final String uid;
  Dashboard({this.uid});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    registerNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      print(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(widget.uid)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void _showToast() {
    Fluttertoast.showToast(
        msg: "This feature is not ready yet.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        floatingActionButton: CircleAvatar(
            backgroundColor: Color(0xFF25D366),
            radius: 28,
            child: IconButton(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  _showToast();
                })),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "GROUPS",
              ),
              Tab(
                text: "CHAT",
              ),
              Tab(
                text: "PROFILE",
              ),
              Tab(
                text: "CALLS",
              ),
            ],
          ),
          title: Text("S6Chat"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 25,
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Text("New group"),
                  ),
                  PopupMenuItem(
                    child: Text("New broadcast"),
                  ),
                  PopupMenuItem(
                    child: Text("WhatsApp Web"),
                  ),
                  PopupMenuItem(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text("Starred messages"),
                    ),
                  ),
                  PopupMenuItem(
                    child: InkWell(
                        onTap: () async {
                          await _auth.signOut();
                        },
                        child: Text("Log Out")),
                  ),
                  PopupMenuItem(
                    child: Text("Settings"),
                  ),
                ],
              ),
            )
          ],
        ),
        body: TabBarView(children: [
          GrpChatListPage(
            senderUid: widget.uid,
          ),
          ChatPage(
            senderUid: widget.uid,
          ),
          ProfilePage(
            uid: widget.uid,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.phone_in_talk,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Coming Soon",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
