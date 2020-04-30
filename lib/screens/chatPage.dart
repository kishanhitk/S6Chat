import 'package:S6Chat/screens/chatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                                leading: snapshot.data.documents[index]
                                            ['dpUrl'] !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl: snapshot.data.documents[index]
                                            ['dpUrl'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : CircleAvatar(
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
