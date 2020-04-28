import 'package:S6Chat/screens/GroupChatPage.dart';
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
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                        thickness: 0.3,
                      ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GrpChatPage(
                                      senderUid: widget.senderUid,
                                      snapshot: snapshot.data.documents[index],
                                    ))),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person),
                        ),
                        title: Text(snapshot.data.documents[index]['name']),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
