import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../Provider/layoutprovider.dart';

class CurrentChallegene extends StatelessWidget {
  final double borderRadius = 15.0;

  const CurrentChallegene({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(
          left: LayoutProvider(context).indentation,
          right: LayoutProvider(context).indentation,
          top: LayoutProvider(context).topBarHeight * 3.5,
          bottom: LayoutProvider(context).topBarHeight * 2,
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Column(
              verticalDirection: VerticalDirection.up,
              children: [
                SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 30.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFF2DDF8),
                            Color(0xFFEAE4FA),
                          ]),
                          borderRadius: BorderRadius.all(
                            Radius.circular(1000),
                          ),
                        ),
                        child: Center(
                          child: GradientText(
                            "Go Back",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            colors: [
                              Color(0xFFC030E6),
                              Color(0xFF8865F7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
