import 'package:S6Chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.snapshot, this.senderUid});
  final String senderUid;
  final DocumentSnapshot snapshot;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;

  bool showEmojiPicker = false;
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

  String receiveruid;
  String receiverToken;
  @override
  void initState() {
    super.initState();
    setState(() {
      receiverToken = widget.snapshot['pushToken'];
      receiveruid = widget.snapshot['uid'];
    });
  }

  final _textController = TextEditingController();
  String text;
  final _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
 
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: <Widget>[
            widget.snapshot['dpUrl'] != null
                ? InkWell(
                    onTap: () {
                      print("object");
                      showDialog(
                        context: (context),
                        builder: (BuildContext context) {
                          return Hero(
                            tag: "dp",
                            child: Dialog(
                                child: CachedNetworkImage(
                                    imageUrl: widget.snapshot['dpUrl'])
                                // Image.network(
                                //   _doc['dpUrl'],
                                // ),
                                ),
                          );
                        },
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.snapshot['dpUrl'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 46.0,
                        height: 46.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 23,
                    backgroundColor: Colors.white,
                  ),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              widget.snapshot['name'],
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.fade,
            ))
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
        decoration: BoxDecoration(color: Colors.white),
        // decoration: BoxDecoration(
        //     // image: DecorationImage(
        //     //     image: AssetImage("assets/wall.jpg"), fit: BoxFit.cover)),
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
                        focusNode: textFieldFocus,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                          print(text);
                        },
                        controller: _textController,
                        decoration: InputDecoration(
                            hintText: "Enter your message here.",
                            fillColor: Colors.black12,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            prefixIcon: IconButton(
                                // onPressed: () {
                                //   print("Emozi");
                                //   if (!showEmojiPicker) {
                                //     hideKeyboard();
                                //     showEmojiContainer();
                                //   } else {
                                //     showKeyboard();
                                //     hideEmojiContainer();
                                //   }
                                // },
                                onPressed: () => showEmojiPicker
                                    ? hideEmojiContainer()
                                    : showEmojiContainer(),
                                icon: Icon(
                                  Icons.tag_faces,
                                  size: 28,
                                )),
                            suffixIcon: Icon(Icons.attach_file)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 26,
                        child: IconButton(
                          onPressed: () async {
                            await _db
                                .collection('messages')
                                .document(widget.senderUid)
                                .collection(receiveruid)
                                .add({
                              'text': _textController.text,
                              'senderID': widget.senderUid,
                              'receiverID': receiveruid,
                              'timeStamp': FieldValue.serverTimestamp(),
                              'receiverToken': receiverToken
                            });
                            await _db
                                .collection('messages')
                                .document(receiveruid)
                                .collection(widget.senderUid)
                                .add({
                              'text': _textController.text,
                              'senderID': widget.senderUid,
                              'receiverID': receiveruid,
                              'timeStamp': FieldValue.serverTimestamp(),
                              'receiverToken': receiverToken
                            });

                            _textController.clear();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor:
                            Color(0xFF157AE1) ?? Colors.black ?? (0xFF075E55),
                      ),
                    )
                  ],
                ),
              ),
            ),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        _textController.text = _textController.text + " " + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
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
        color: Color(0xFF157AE1),
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
            color: snapshot['senderID'] == widget.senderUid
                ? Colors.white
                : Colors.black,
            fontSize: 18.0,
          ),
        ),
        // Text(
        //   snapshot['timeStamp'].toString(),
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 18.0,
        //   ),
        // ),
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
        color: Colors.black12,
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
