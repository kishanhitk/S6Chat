import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServices {
  final String uid;
  DataBaseServices({this.uid});
  final CollectionReference _doc = Firestore.instance.collection('users');
  Future createUserDatabase(String name, String phoneNo) async {
    return await _doc.document(uid).updateData({
      'uid': uid,
      'name': name,
      'phoneNo': phoneNo,
    });
  }
}
