import 'package:S6Chat/screens/grpChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GrpChatListPage extends StatefulWidget {
  GrpChatListPage({this.snapshot, this.senderUid});
  final String senderUid;
  final DocumentSnapshot snapshot;
  @override
  _GrpChatListPageState createState() => _GrpChatListPageState();
}

class _GrpChatListPageState extends State<GrpChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      print(widget.senderUid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GrpChatScreen(
                            senderUid: widget.senderUid,
                          ),
                        ),
                      );
                    },
                    enabled: true,
                    leading: CircleAvatar(
                      child: Image.asset("assets/splash.png"),
                      radius: 28,
                      backgroundColor: Colors.black,
                    ),
                    title: Text(
                      "Group",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("New message"),
                    trailing: Text(
                      "7:24 PM",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
