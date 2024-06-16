import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const lightTextTheme = TextTheme(
  displayLarge: TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: Colors.black,
    decorationStyle: TextDecorationStyle.wavy,
    color: Colors.blue,
  ),
);


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: lightTextTheme,
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      // primary: Color.fromRGBO(64,123,255,1),
      primary: HexColor('#1F41BB'),
      // primary: Color.fromRGBO(205,170,125,1),
      onPrimary: Colors.black,
      secondary: Color.fromRGBO(64,123,255,0.4),
      // secondary: Color.fromRGBO(139,105,20,0.8),
      onSecondary: Colors.grey,
      error: Color.fromRGBO(255,15,15, 0.6),
      onError: Color.fromRGBO(255,15,15, 0.6),
      background: Color.fromRGBO(250,250,250, 1),
      onBackground: Colors.white,
      surface: Color.fromRGBO(123, 145, 190, 1.0), // nav bar actice cirle
      // surface: Color.fromRGBO(255,248,220, 1), // nav bar actice cirle
      onSurface: Color.fromRGBO(241, 237, 247, 1)
  ),
);

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: const ColorScheme(
//       brightness: Brightness.light,
//       primary: Color.fromRGBO(205,170,125,1),
//       onPrimary: Colors.black,
//       secondary: Color.fromRGBO(139,105,20,0.8),
//       onSecondary: Colors.grey,
//       error: Color.fromRGBO(255,15,15, 0.6),
//       onError: Color.fromRGBO(255,15,15, 0.6),
//       background: Color.fromRGBO(250,250,250, 1),
//       onBackground: Colors.white,
//       surface: Color.fromRGBO(255,248,220, 1), // nav bar actice cirle
//       onSurface: Color.fromRGBO(241, 237, 247, 1)
//   ),
// );


// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme(
//       brightness: Brightness.dark,
//       primary: Color.fromRGBO(0,173,181,0.8),
//       onPrimary: Color.fromRGBO(238,238,238,0.8),
//       secondary: Color.fromRGBO(57,62,70,1),
//       onSecondary: Color.fromRGBO(238,238,238,0.4),
//       error: Color.fromRGBO(255,15,15, 0.6),
//       onError: Color.fromRGBO(255,15,15, 0.6),
//       background: Color.fromRGBO(34,40,49,1),
//       onBackground: Color.fromRGBO(238,238,238, 1),
//       surface: Color.fromRGBO(238,238,238, 1),
//       onSurface: Color.fromRGBO(241, 237, 247, 1)
//   ),
// );


// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme(
//       brightness: Brightness.dark,
//       primary: Color.fromRGBO(39,55,77,1),
//       onPrimary: Colors.black,
//       secondary: Color.fromRGBO(82,109,130,0.8),
//       onSecondary: Colors.grey,
//       error: Color.fromRGBO(255,15,15, 0.6),
//       onError: Color.fromRGBO(255,15,15, 0.6),
//       background: Color.fromRGBO(221,230,237, 1),
//       onBackground: Colors.white,
//       surface: Color.fromRGBO(157,178,191, 1), // nav bar actice cirle
//       onSurface: Color.fromRGBO(241, 237, 247, 1)
//   ),
// );


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: lightTextTheme,
  colorScheme: ColorScheme(
      brightness: Brightness.dark,
      // primary: Color.fromRGBO(64,123,255,1),
      primary: HexColor('#1F41BB'),
      // primary: Color.fromRGBO(205,170,125,1),
      onPrimary: Colors.black,
      secondary: Color.fromRGBO(64,123,255,0.4),
      // secondary: Color.fromRGBO(139,105,20,0.8),
      onSecondary: Colors.grey,
      error: Color.fromRGBO(255,15,15, 0.6),
      onError: Color.fromRGBO(255,15,15, 0.6),
      background: Color.fromRGBO(250,250,250, 1),
      onBackground: Colors.white,
      surface: Color.fromRGBO(123, 145, 190, 1.0), // nav bar actice cirle
      // surface: Color.fromRGBO(255,248,220, 1), // nav bar actice cirle
      onSurface: Color.fromRGBO(241, 237, 247, 1)
  ),
);
