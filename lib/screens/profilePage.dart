import 'package:S6Chat/screens/profileEdit.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({this.uid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final _doc = snapshot.data;
        return Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          "https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-thumb.jpg"),
                  height: MediaQuery.of(context).size.height / 5,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 80,
                  left: 130,
                  right: 130,
                  child: Align(
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      backgroundImage: _doc['dpUrl'] == null
                          ? AssetImage('assets/icon.png')
                          : NetworkImage(_doc['dpUrl']),
                      radius: 70,

                      // radius: 70,
                      // backgroundImage: NetworkImage(_doc['dpUrl']),
                      // backgroundColor: Color(0x662D78FF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              _doc['name'],
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 10),
            Text(
              _doc['phoneNo'],
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                  color: Colors.black45),
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.green[400],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditingPage(
                      registeredName: _doc['name'],
                    ),
                  ),
                );
                //  var img =  ImagePicker.pickImage(source: ImageSource.gallery);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            RaisedButton(
              color: Colors.red[400],
              onPressed: () {
                AuthService().signOut();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}
