import 'package:flutter/cupertino.dart';

class LayoutProvider {
  late double topBarHeight;
  late double indentation;

  LayoutProvider(BuildContext context) {
    var aspectratio =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (aspectratio >= 2) {
      topBarHeight = MediaQuery.of(context).size.width * 2.16 * 0.043;
    } else {
      topBarHeight = MediaQuery.of(context).size.width * 1.78 * 0.050;
    }
    indentation = MediaQuery.of(context).size.width * 0.06;
  }
}
