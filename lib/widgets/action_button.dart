import 'package:flutter/material.dart';

class ActionBtn extends StatelessWidget {
  const ActionBtn(
      {Key? key,
      required this.content,
      required this.color,
      required this.onPressed})
      : super(key: key);
  final String content;
  final Color color;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    dynamic style = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
    const estilo = TextStyle(
      fontSize: 18,
      fontFamily: 'Brand-bold',
    );
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            content,
            style: estilo,
          ),
        ),
      ),
    );
  }
}
