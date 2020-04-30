import 'package:S6Chat/screens/chatPage.dart';
import 'package:S6Chat/screens/grpChatListPage.dart';
import 'package:S6Chat/screens/grpChatScreen.dart';
import 'package:S6Chat/screens/profilePage.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        floatingActionButton: CircleAvatar(
            backgroundColor: Colors.black ?? Color(0xFF25D366),
            radius: 28,
            child: Hero(
              tag: "FAB",
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrpChatScreen(
                              senderUid: widget.uid,
                            ),
                          ));
                    }),
              ),
            )),
        appBar: AppBar(
          backgroundColor: Colors.black,
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
          title: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("S6",
                    style: GoogleFonts.parisienne(color: Colors.black)),
              )),
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: PopupMenuButton(
            //     itemBuilder: (BuildContext context) => [
            //       PopupMenuItem(
            //         child: Text("New group"),
            //       ),
            //       PopupMenuItem(
            //         child: Text("New broadcast"),
            //       ),
            //       PopupMenuItem(
            //         child: Text("WhatsApp Web"),
            //       ),
            //       PopupMenuItem(
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 10.0),
            //           child: Text("Starred messages"),
            //         ),
            //       ),
            //       PopupMenuItem(
            //         child: InkWell(
            //             onTap: () async {
            //               await _auth.signOut();
            //             },
            //             child: Text("Log Out")),
            //       ),
            //       PopupMenuItem(
            //         child: Text("Settings"),
            //       ),
            //     ],
            //   ),
            // )
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
