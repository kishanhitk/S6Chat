import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.snapshot, this.senderUid});
  final String senderUid;
  final DocumentSnapshot snapshot;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  String receiveruid;
  @override
  void initState() {
    super.initState();
    setState(() {
      receiveruid = widget.snapshot['uid'];
    });
  }

  @override
  final _db = Firestore.instance;

  final _textController = TextEditingController();
  String text;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: <Widget>[
            CircleAvatar(
              child: Icon(Icons.person),
              radius: 23,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Text(widget.snapshot['name'])
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {
                print(receiveruid);
              }),
          IconButton(
              icon: Icon(Icons.call),
              onPressed: () async {
                print(widget.senderUid);

                // await AuthService().signOut();
                // Navigator.pop(context);
              }),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Group Info"),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/wall.jpg"), fit: BoxFit.cover)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Form(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                      controller: _textController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                          prefixIcon: Icon(
                            Icons.tag_faces,
                            size: 28,
                          ),
                          suffixIcon: Icon(Icons.attach_file)),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 26,
                        child: IconButton(
                          onPressed: () async {
                            _textController.clear();
                            await _db
                                .collection('messages')
                                .document(widget.senderUid)
                                .collection(receiveruid)
                                .add({
                              'text': text,
                              'senderID': widget.senderUid,
                              'receiverID': receiveruid,
                              'timeStamp': FieldValue.serverTimestamp()
                            });
                            await _db
                                .collection('messages')
                                .document(receiveruid)
                                .collection(widget.senderUid)
                                .add({
                              'text': text,
                              'senderID': widget.senderUid,
                              'receiverID': receiveruid,
                              'timeStamp': FieldValue.serverTimestamp()
                            });
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xFF075E55),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(widget.senderUid)
          .collection(receiveruid)
          .orderBy('timeStamp', descending: false)
          //.orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollToBottom());
            //  _scrollToBottom();
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    print(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      // child: Text(snapshot['text'])
      child: Container(
        alignment: snapshot['senderID'] == widget.senderUid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderID'] == widget.senderUid
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Text(
          snapshot['text'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        Text(
          snapshot['timeStamp'].toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }
}
