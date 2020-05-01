import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData icon;
  final Color buttonColor;
  Buttons({this.onTap, this.buttonColor, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey,
              //     blurRadius: 5.0, // has the effect of softening the shadow
              //     spreadRadius: 1.0, // has the effect of extending the shadow
              //     offset: Offset(
              //       2.0, // horizontal, move right 10
              //       5.0, // vertical, move down 10
              //     ),
              //   )
              // ],
              color: buttonColor,
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text, style: TextStyle(color: Colors.white, fontSize: 20)),
               icon!=null? SizedBox(
                  width: 5,
                ):SizedBox(),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        onTap: onTap);
  }
}
