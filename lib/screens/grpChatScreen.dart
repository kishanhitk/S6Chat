import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

class GrpChatScreen extends StatefulWidget {
  final String senderUid;
  GrpChatScreen({this.senderUid});
  @override
  _GrpChatScreenState createState() => _GrpChatScreenState();
}

class _GrpChatScreenState extends State<GrpChatScreen> {
  FocusNode textFieldFocus = FocusNode();

  bool showEmojiPicker = false;
  final _db = Firestore.instance;
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  String text;
  TextEditingController _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(widget.senderUid)
                .snapshots(),
            builder: (context, snapshot) {
              final _doc = snapshot.data;
              return Hero(
                tag: "FAB",
                child: Material(
                  child: Scaffold(
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
                            child: Image.asset("assets/splash.png"),
                            radius: 23,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Group")
                        ],
                      ),
                      // actions: <Widget>[
                      //   IconButton(
                      //     icon: Icon(Icons.video_call),
                      //     onPressed: () {},
                      //   ),
                      //   IconButton(
                      //       icon: Icon(Icons.call),
                      //       onPressed: () async {
                      //         print(widget.senderUid);

                      //         // await AuthService().signOut();
                      //         // Navigator.pop(context);
                      //       }),
                      //   PopupMenuButton(
                      //     itemBuilder: (BuildContext context) => [
                      //       PopupMenuItem(
                      //         child: Text("Group Info"),
                      //       ),
                      //     ],
                      //   ),
                      // ],
                    ),
                    body: Container(
                      decoration: BoxDecoration(color: Colors.black26),
                      child: Column(
                        children: <Widget>[
                          Flexible(child: messageList()),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Form(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: TextField(
                                    focusNode: textFieldFocus,
                                    onChanged: (value) {
                                      setState(() {
                                        text = value;
                                      });
                                    },
                                    controller: _textController,
                                    decoration: InputDecoration(
                                        hintText: "Enter your message here.",
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 5),
                                        prefixIcon: IconButton(
                                            onPressed: () => showEmojiPicker
                                                ? hideEmojiContainer()
                                                : showEmojiContainer(),
                                            icon: Icon(
                                              Icons.tag_faces,
                                              size: 28,
                                            )),
                                        suffixIcon: Icon(Icons.attach_file)),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 26,
                                      child: IconButton(
                                        onPressed: () async {
                                          await _db
                                              .collection('groupMessages')
                                              .add({
                                            'text': _textController.text,
                                            'senderID': widget.senderUid,
                                            'senderName': _doc['name'],
                                            'timeStamp':
                                                FieldValue.serverTimestamp()
                                          });
                                          _textController.clear();
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Color(0xFF075E55),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          showEmojiPicker
                              ? Container(child: emojiContainer())
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  emojiContainer() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        _textController.text = _textController.text + " " + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("groupMessages")
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          snapshot['senderName'].toString(),
          style: TextStyle(
            color: Colors.black45,
            fontSize: 13.0,
          ),
        ),
        Text(
          snapshot['text'],
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
