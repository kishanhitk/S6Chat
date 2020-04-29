import 'package:S6Chat/screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String senderUid;
  ChatPage({this.senderUid});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        snapshot.data.documents[index]['uid'] ==
                                widget.senderUid
                            ? Container()
                            : ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      senderUid: widget.senderUid,
                                      snapshot: snapshot.data.documents[index],
                                    ),
                                  ),
                                ),
                                enabled: true,
                                leading: CircleAvatar(
                                  child: Icon(Icons.person),
                                  radius: 28,
                                  backgroundColor: Colors.black,
                                ),
                                title: Text(
                                  snapshot.data.documents[index]['name'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text("New message"),
                                trailing: Text(
                                  "7:24 PM",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                        Divider(
                          height: 5,
                          indent: 60,
                        )
                      ],
                    );
                  });
            }
          }),
    );
  }
}
