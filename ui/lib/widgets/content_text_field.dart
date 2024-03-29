import 'package:flutter/material.dart';

class ContentTextField extends StatelessWidget {
  const ContentTextField({
    super.key,
    this.maxLines = 1000,
    required this.onChanged,
    required this.content,
    required this.controller,
  });

  final Function(String) onChanged;

  final String content;

  final TextEditingController controller;

  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 10,
      child: TextField(
        onChanged: onChanged,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        controller: controller,
        decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: 'Text Here',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    Key? key,
    this.radius,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
            // inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
