import 'package:S6Chat/models/user.dart';
import 'package:S6Chat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User _fromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_fromFirebaseUser);
  }

  signOut() {
    _auth.signOut();
  }

  signIn({AuthCredential authCredential, String name, String phoneNo}) async {
    AuthResult result = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    await DataBaseServices(uid: user.uid).createUserDatabase(name, phoneNo);
  }

  signInOTP(smsCode, verId, name, phoneNo) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCredential: authCredential, name: name, phoneNo: phoneNo);
  }
}
