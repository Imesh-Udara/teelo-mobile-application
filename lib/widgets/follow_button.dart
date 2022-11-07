import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color profileBackgroundColor;
  final Color profileBorderColor;
  final String text;
  final Color textColor;
  const FollowButton({super.key, required this.profileBackgroundColor, required this.profileBorderColor, required this.text, required this.textColor, required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: profileBackgroundColor,
            border: Border.all(color: profileBorderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: 240,
          height: 30,
        ),
      ),
    );
  }
}
