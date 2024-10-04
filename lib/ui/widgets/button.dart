// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.label,
    required this.onTap, required Color color, required Color style,
  }) : super(key: key);
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: primaryClr),
        width: 100,
        height: 45,
        child: Text(
          label,
          style: TextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
