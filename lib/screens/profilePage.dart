import 'package:S6Chat/reusable/components.dart';
import 'package:S6Chat/screens/profileEdit.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 200,
                    width: 2000,
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 130,
                  right: 130,
                  child: InkWell(
                    onTap: () {
                      print("object");
                      showDialog(
                        context: (context),
                        builder: (BuildContext context) {
                          return Hero(
                            tag: "dp",
                            child: Dialog(
                                child:
                                    CachedNetworkImage(imageUrl: _doc['dpUrl'])
                                // Image.network(
                                //   _doc['dpUrl'],
                                // ),
                                ),
                          );
                        },
                      );
                    },
                    child: Align(
                      child: Hero(
                        tag: "dp",
                        child: _doc['dpUrl'] != null
                            ? CachedNetworkImage(
                                imageUrl: _doc['dpUrl'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.black12,
                                backgroundImage: AssetImage('assets/icon.png'),
                                radius: 70,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              _doc['name'],
              style: GoogleFonts.roboto(
                fontSize: 40
              ),
              // style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, ),
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
            Buttons(
              onTap: () {
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
              text: "Edit Profile",
              buttonColor: Colors.black,
              icon: Icons.edit,
            ),
            SizedBox(height: 10),
            Buttons(
              text: "Log out",
              buttonColor: Colors.red[500],
              onTap: () {
                showDialog(
                  context: (context),
                  builder: (BuildContext context) {
                    return Dialog(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 25),
                          child: FittedBox(
                            child: Text(
                              "Are you sure you want to log out?",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Buttons(
                              icon: Icons.check_circle_outline,
                              text: "YES",
                              buttonColor: Colors.red,
                              onTap: () async {
                                await AuthService().signOut();
                                Navigator.pop(context);
                              },
                            ),
                            Buttons(
                              buttonColor: Colors.green,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              text: "NO",
                              icon: Icons.remove_circle_outline,
                            )
                          ],
                        ),
                        SizedBox(height: 30)
                      ],
                    )
                        // Image.network(
                        //   _doc['dpUrl'],
                        // ),
                        );
                  },
                );
                //AuthService().signOut();
              },
              icon: Icons.exit_to_app,
            ),
          ],
        );
      },
    ));
  }
}
