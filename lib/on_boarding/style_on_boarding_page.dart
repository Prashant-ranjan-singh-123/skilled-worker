import 'package:flutter/material.dart';

class TextStyleIs{
  TextStyle skip_and_next(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
      fontFamily: 'Roboto',
      color: Theme.of(context).colorScheme.background
    );
  }

  TextStyle heading(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 30,
        fontFamily: 'Roboto',
        color: Theme.of(context).colorScheme.onPrimary
    );
  }
  TextStyle subtitle(BuildContext context) {
    return TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Theme.of(context).colorScheme.onPrimary
    );
  }
}