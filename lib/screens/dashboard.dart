import 'package:S6Chat/screens/GroupChatPage.dart';
import 'package:S6Chat/screens/chatPage.dart';
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GrpChatPage()));
                })),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.camera_alt),
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
          title: Text("WhatsApp"),
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
          Icon(Icons.chat),
          ChatPage(
            senderUid: widget.uid,
          ),
          ProfilePage(
            uid: widget.uid,
          ),
          Icon(Icons.chat),
        ]),
      ),
    );
  }
}

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         floatingActionButton: CircleAvatar(
//             backgroundColor: Color(0xFF25D366),
//             radius: 28,
//             child: IconButton(
//                 icon: Icon(
//                   Icons.message,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//                 onPressed: () {})),
//         appBar: AppBar(
//           bottom: TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.camera_alt),
//               ),
//               Tab(
//                 text: "CHAT",
//               ),
//               Tab(
//                 text: "STATUS",
//               ),
//               Tab(
//                 text: "CALLS",
//               ),
//             ],
//           ),
//           title: Text("WhatsApp"),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 icon: Icon(
//                   Icons.search,
//                   size: 25,
//                 ),
//                 onPressed: () {},
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: PopupMenuButton(
//                 itemBuilder: (BuildContext context) => [
//                   PopupMenuItem(
//                     child: Text("New group"),
//                   ),
//                   PopupMenuItem(
//                     child: Text("New broadcast"),
//                   ),
//                   PopupMenuItem(
//                     child: Text("WhatsApp Web"),
//                   ),
//                   PopupMenuItem(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                       child: Text("Starred messages"),
//                     ),
//                   ),
//                   PopupMenuItem(
//                     child: Text("Payments"),
//                   ),
//                   PopupMenuItem(
//                     child: Text("Settings"),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//         body: TabBarView(children: [
//           Icon(Icons.chat),
//            Text(widget.uid),
//           Icon(Icons.chat),
//           Icon(Icons.chat),
//         ]),
//       ),
//     );
//     ;
//   }
// }
