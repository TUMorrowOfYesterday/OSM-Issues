import 'dart:math';

import 'package:app/camera.dart';
import 'package:flutter/material.dart';

class CurrentChallegene extends StatefulWidget {
  const CurrentChallegene({super.key});

  @override
  State<CurrentChallegene> createState() => _CurrentChallegeneState();
}

class _CurrentChallegeneState extends State<CurrentChallegene> {
  // distance to goal
  double distance = 2;
  int count = 0;

  void setState(VoidCallback fn) {
    // implement setState when distance reduce
    // distance = getdistancetoGoal
    super.setState(fn);
  }

  int random = 0;
  final List emoji = [
    "(>_<)",
    "(·_·)",
    "(o^^)o",
    "(='X'=)",
    "(^_^)b",
    "(;-;)",
    "(^-^*)",
    "(·.·)",
    "٩(◕‿◕｡)۶",
    "(* ^ ω ^)",
    "(´ ∀ ` *)",
    "٩(◕‿◕｡)۶",
    "(o^▽^o)",
    "(⌒▽⌒)☆",
    "<(￣︶￣)>",
    "ヽ(・∀・)ﾉ",
    "(´｡• ω •｡`)",
    "(￣ω￣)",
    "(o･ω･o)",
    "(＠＾◡＾)",
    "ヽ(*・ω・)ﾉ",
    "(o_ _)ﾉ彡☆",
    "(^人^)",
    "(o´▽`o)",
    "(*´▽`*)",
    "｡ﾟ( ﾟ^∀^ﾟ)ﾟ｡",
    "( ´ ω ` )",
    "(≧◡≦)",
    "(o´∀`o)",
    "(´• ω •`)",
    "(＾▽＾)",
    "(⌒ω⌒)",
    "∑d(°∀°d)",
    "╰(▔∀▔)╯",
    "(─‿‿─)",
    "(*^‿^*)",
    "ヽ(o^ ^o)ﾉ",
    "(✯◡✯)",
    "(◕‿◕)",
    "(*≧ω≦*)",
    "(☆▽☆)"
  ];
  final double borderRadius = 15.0;

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
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    const Text(
                      "My Challenges",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.43,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  color: Color(0xFFDBDBDB), width: 1))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            const Text(
                              "Ongoing challenges",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // if you are closer than 3 meters
                    if (distance < 3)
                      InkWell(
                        onTap: () {
                          // open Camera app
                          Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation, secAnimation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: const Offset(0, 0))
                                  .animate(CurvedAnimation(
                                      parent: animation, curve: Curves.linear)),
                              child: CameraExampleHome(),
                            );
                          }));
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
                              colors: [Color(0xFFC030E6), Color(0xFF8865F7)],
                              begin: Alignment(-1.0, -2.0),
                              end: Alignment(1.0, 2.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Take Picture',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(27.0)),
                            gradient: LinearGradient(
                              colors: [Color(0x0FC030E6), Color(0x0F8865F7)],
                              begin: Alignment(-1.0, -2.0),
                              end: Alignment(1.0, 2.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Take Picture',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          count += 1;
                          var x = Random();
                          random = x.nextInt(emoji.length - 1);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          emoji[random],
                          style: TextStyle(
                            fontSize: 44,
                            color: Color(count <= 30 ? 0xFFB0B3B8 : 0xAF0FFAE6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
