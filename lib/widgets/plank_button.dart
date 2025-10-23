// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dino_run/core/shared/colors.dart';
import 'package:flutter/material.dart';

class PlankButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  const PlankButton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/plank wood.png'),
          ),
        ),
        child: Center(child: Text(label, style: TextStyle(fontSize: 24, color: colorBlack))),
      ),
    );
  }
}
