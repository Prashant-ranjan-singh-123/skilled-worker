import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final IconData trailingIcon;
  final bool isNum;
  final Function onChange;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.trailingIcon,
    required this.isNum,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,

          ),
          onChanged: (_){
            onChange();
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(
              trailingIcon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500
            ),
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}
