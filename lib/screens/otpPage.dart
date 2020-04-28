import 'package:S6Chat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

String phone, verificationID, smsCode, name;

class _TestState extends State<Test> {
  final formkey = GlobalKey<FormState>();
  bool smsSent = false;
  bool verComplete = false;
  bool readonly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome"),
        elevation: 0,
      ),
      body: verComplete
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/banner.png'),
                  ),
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            readOnly: readonly,
                            decoration: InputDecoration(
                              labelText: "Name",
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ),
                          TextFormField(
                            readOnly: readonly,
                            decoration: InputDecoration(labelText: "Phone"),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              setState(() {
                                phone = "+91" + value;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Color(0xEE075E55),
                              child: Text("Send OTP",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                print(phone);
                                readonly = false;
                                verifyPhone(phone);
                              },
                            ),
                          ),
                          smsSent
                              ? TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "Enter OTP"),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      smsCode = value;
                                    });
                                  },
                                )
                              : Container(),
                          smsSent
                              ? RaisedButton(
                                  color: Color(0xEE075E55),
                                  child: Text("Verify OTP",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    print(phone);
                                    AuthService().signInOTP(
                                        smsCode, verificationID, name, phone);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "OTP sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      setState(() {
        this.verComplete = true;
      });
      AuthService()
          .signIn(authCredential: authResult, name: name, phoneNo: phone);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print("${authException.message}");
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      showToast();
      setState(() {
        this.smsSent = true;
      });
      print(forceResend);

      verificationID = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationID = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
