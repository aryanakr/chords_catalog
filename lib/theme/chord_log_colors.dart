import 'package:flutter/material.dart';


class ChordLogColors {
  static const primary = Color(0xFFEA8058);
  static const secondary = Color(0xFFFFEFBB);
  static const bodyColor =  Color(0xFFFF9E30);

  static const Map<int, Color> _primaryMap = {
    50:Color.fromRGBO(234, 128, 88, 0.1),
    100:Color.fromRGBO(234, 128, 88, 0.2),
    200:Color.fromRGBO(234, 128, 88, 0.3),
    300:Color.fromRGBO(234, 128, 88, 0.4),
    400:Color.fromRGBO(234, 128, 88, 0.5),
    500:Color.fromRGBO(234, 128, 88, 0.6),
    600:Color.fromRGBO(234, 128, 88, 0.7),
    700:Color.fromRGBO(234, 128, 88, 0.8),
    800:Color.fromRGBO(234, 128, 88, 0.9),
    900:Color.fromRGBO(234, 128, 88, 1),
  };

  static const Map<int, Color> _secondaryMap = {
    50:Color.fromRGBO(255, 239, 187, 0.1),
    100:Color.fromRGBO(255, 239, 187, 0.2),
    200:Color.fromRGBO(255, 239, 187, 0.3),
    300:Color.fromRGBO(255, 239, 187, 0.4),
    400:Color.fromRGBO(255, 239, 187, 0.5),
    500:Color.fromRGBO(255, 239, 187, 0.6),
    600:Color.fromRGBO(255, 239, 187, 0.7),
    700:Color.fromRGBO(255, 239, 187, 0.8),
    800:Color.fromRGBO(255, 239, 187, 0.9),
    900:Color.fromRGBO(255, 239, 187, 1),
  };

  static const materialPrimary = MaterialColor(0xFFEA8058, _primaryMap);
  static const materialSecondary = MaterialColor(0xFFFFEFBB, _secondaryMap);

  static const backGroundGradient = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [0.2, 0.8],
              colors: [
                bodyColor,
                secondary,
              ],
            );

  static const mainBackgroundColor = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      secondary,
      Color.fromARGB(255, 253, 150, 33),
    ],
  );
}
 