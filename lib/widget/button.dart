import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({required this.onPressed, required this.nameButton, super.key});
  final String nameButton;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xffff725e),
        ),
        onPressed: onPressed,
        child: Text(
          nameButton,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
