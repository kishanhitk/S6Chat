// import 'package:S6Chat/models/user.dart';
// import 'package:S6Chat/services/auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:S6Chat/services/database.dart';
// import 'package:provider/provider.dart';

// class UserRegPage extends StatefulWidget {
//   final String uid;
//   String phoneNo;
//   UserRegPage({this.phoneNo, this.uid});
//   @override
//   _UserRegPageState createState() => _UserRegPageState();
// }

// class _UserRegPageState extends State<UserRegPage> {
//   String name = "default";
//   final user = Provider.of<User>(context);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           DataBaseServices(uid: user.uid)
//               .createUserDatabase(name, widget.phoneNo);
//         },
//         label: Text("Get Started"),
//       ),
//       body: Container(
//         child: Center(
//           child: Form(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     name = value;
//                   });
//                 },
//               )
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }
