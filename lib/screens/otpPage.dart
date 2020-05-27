import 'package:S6Chat/reusable/components.dart';
import 'package:S6Chat/reusable/constants.dart';
import 'package:S6Chat/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

String phone, verificationID, smsCode, name;

class _OtpPageState extends State<OtpPage> {
  final formkey = GlobalKey<FormState>();
  bool smsSent = false;
  bool verComplete = false;
  bool readonly = false;
  bool sendingOtp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: verComplete
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 3.3,
                      child: Image.asset('assets/banner.png')),
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          smsSent
                              ? Container()
                              : TextFormField(
                                  decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.person),
                                      hintText: "Name"),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                          smsSent
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          smsSent
                              ? Container()
                              : TextFormField(
                                  decoration: kInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.phone),
                                      // prefixText: "+91-",
                                      hintText: "Phone"),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    setState(() {
                                      phone = "+91" + value;
                                    });
                                  },
                                ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: sendingOtp
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("Sending OTP.")
                                      ],
                                    ),
                                  )
                                : smsSent
                                    ? Container()
                                    : Buttons(
                                      icon: CupertinoIcons.forward,
                                        buttonColor:
                                            Colors.black ?? Color(0xEE075E55),
                                        text: "Send OTP",
                                        onTap: () {
                                          print(phone);
                                          setState(() {
                                            readonly = true;
                                          });
                                          verifyPhone(phone);
                                          setState(() {
                                            sendingOtp = true;
                                          });
                                        },
                                      ),
                          ),
                          smsSent
                              ? TextFormField(
                                  textAlign: TextAlign.center,
                                  decoration: kInputDecoration,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      smsCode = value;
                                    });
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          smsSent
                              ? Buttons(
                                icon: Icons.verified_user,
                                  buttonColor:
                                      Colors.black ?? Color(0xEE075E55),
                                  text: "Verify OTP",
                                  onTap: () {
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

  void _showToast() {
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
      _showToast();
      setState(() {
        this.smsSent = true;
        this.sendingOtp = false;
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
