import 'dart:io';

import 'package:S6Chat/models/cloud_storage_result.dart';
import 'package:S6Chat/models/user.dart';
import 'package:S6Chat/services/cloud_storage.dart';
import 'package:S6Chat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileEditingPage extends StatefulWidget {
  final String registeredName;
  ProfileEditingPage({this.registeredName});
  @override
  _ProfileEditingPageState createState() =>
      _ProfileEditingPageState(newname: registeredName);
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  String newname;
  _ProfileEditingPageState({this.newname});
  final _db = Firestore.instance;
  Future<String> getTempDir() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print(tempPath);
    return tempPath;
  }

  bool uploading = false;

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  File selectedImage;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                height: 200,
                width: 200,
                child: InkWell(
                  onTap: () async {
                    var file = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (file != null) {
                      setState(() {
                        selectedImage = file;
                      });
                    }
                  },
                  child: selectedImage == null
                      ? Center(child: Text("Select new profile photo."))
                      : CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 70,
                          backgroundImage: FileImage(selectedImage),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      newname = val;
                    });
                  }
                },
                decoration: InputDecoration(
                    hintText: widget.registeredName, hintStyle: TextStyle()),
              ),
            ),
            RaisedButton(
              color: Colors.green[300],
              onPressed: () async {
                if (selectedImage != null) {
                  setState(() {
                    uploading = true;
                  });
                  var tempPath = await getTempDir();

                  File compressedImage = await testCompressAndGetFile(
                      selectedImage, tempPath + "/img.jpg");
                  CloudStorageResult cloudStorageResult =
                      await CloudStorageService().uploadImage(
                          imageToUpload: compressedImage, title: "DP");

                  _db
                      .collection("users")
                      .document(user.uid)
                      .updateData({"dpUrl": cloudStorageResult.imageUrl});
                  setState(() {
                    uploading = false;
                  });
                  _showToast();
                  print(cloudStorageResult.imageUrl);
                }
                _db
                    .collection("users")
                    .document(user.uid)
                    .updateData({"name": newname});
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            uploading
                ? Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Compressing and uploading image\nDon't press back or exit the app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

void _showToast() {
  Fluttertoast.showToast(
      msg: "Profile Photo updated. \nGo back and see your new profile pic.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER);
}
