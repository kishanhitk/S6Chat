
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServices {
  final String uid;
  DataBaseServices({this.uid});
  final CollectionReference _doc = Firestore.instance.collection('users');
  Future createUserDatabase(String name, String phoneNo) async {
    return await _doc
        .document(uid)
        .updateData({'uid': uid, 'name': name, 'phoneNo': phoneNo,'dpUrl':"https://firebasestorage.googleapis.com/v0/b/s6-chat.appspot.com/o/Artboard%201.png?alt=media&token=b780c1a6-d94d-4a06-9b13-3de5a11cc8dc"});
  }
}
