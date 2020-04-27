import 'package:flutter/material.dart';

class GrpChatPage extends StatefulWidget {
  @override
  _GrpChatPageState createState() => _GrpChatPageState();
}

class _GrpChatPageState extends State<GrpChatPage> {
  @override
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
              radius: 25,
              backgroundColor: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Kishan Sharma")
          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://www.setaswall.com/wp-content/uploads/2019/08/Whatsapp-Wallpaper-120.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Card(
                color: Color(0xFFE2FFC7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "HElli",
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                        prefixIcon: Icon(
                          Icons.tag_faces,
                          size: 28,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.attach_file,
                                size: 28,
                              ),
                              Icon(
                                Icons.camera_alt,
                                size: 28,
                              )
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 26,
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xFF075E55),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
