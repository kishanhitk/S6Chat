import 'package:S6Chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  child: Image.network(
                    "https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-thumb.jpg",
                    scale: 1,
                    fit: BoxFit.fill,
                  ),
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
                      radius: 70,
                      backgroundImage: NetworkImage(
                          "https://scontent-bom1-1.xx.fbcdn.net/v/t1.0-9/s960x960/45403612_1016987948505521_8622775694356643840_o.jpg?_nc_cat=105&_nc_sid=85a577&_nc_ohc=a0Gy2k0WLJQAX-UwUcT&_nc_ht=scontent-bom1-1.xx&_nc_tp=7&oh=8509ef4671fe151791e72555ebd6ebb0&oe=5F02A6B1"),
                      backgroundColor: Color(0x662D78FF),
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
            SizedBox(height: 30),
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
