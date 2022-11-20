import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../camera.dart';

class NewChallenge extends StatefulWidget {
  final int issueId;

  const NewChallenge({super.key, required this.issueId});

  @override
  State<NewChallenge> createState() => _NewChallengeState();
}

class _NewChallengeState extends State<NewChallenge> {
  double distance = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, //Colors.black.withOpacity(0.6),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFBFBFB),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    Text(
                      "New Challenge" + widget.issueId.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(),
                    SizedBox(
                      height: 20,
                    ),
                    // TODO if you are close than 3meter
                    if (distance < 3)
                      InkWell(
                        onTap: () {
                          // Accept challenge
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(27.0)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF18E299), Color(0xFF0FFAE6)],
                              begin: Alignment(-1.0, -2.0),
                              end: Alignment(1.0, 2.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Accept Challenge',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
