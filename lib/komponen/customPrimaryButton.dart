import 'package:chasier/constans.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Function() onpress;
  final String title;
  CustomPrimaryButton({required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onpress,
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
