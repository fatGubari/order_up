import 'package:flutter/material.dart';

class TextBuilder extends StatelessWidget {
  final String text;
  final double size;
  const TextBuilder(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
        ),
      ),
    );
  }
}
