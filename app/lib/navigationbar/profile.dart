import 'dart:ui';

import 'package:app/Challenge/currentchallenge.dart';
import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../Provider/layoutprovider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late LayoutProvider userProvider;
  @override
  Widget build(BuildContext context) {
    var topBarHeight = LayoutProvider(context).topBarHeight;
    var indentation = LayoutProvider(context).indentation;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: const [
            //     Padding(
            //       padding: EdgeInsets.only(top: 10),
            //       child: Text('Profile'),
            //     )
            //   ],
            // ),
            Expanded(
              child: SingleChildScrollView(
                // Bounce Bounce
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      const Center(
                        child: ClipOval(
                            child: Image(
                                width: 200,
                                image: AssetImage('assets/avatar/sloth.jpg'))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30.0,
                            child: const Icon(
                              Icons.person,
                              size: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              'My Avatar',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            CustomRoute(
                              destination: const CurrentChallegene(),
                              darken: true,
                            )),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.55,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            gradient: LinearGradient(
                              colors: [Color(0xAF18E299), Color(0xAF0FFAE6)],
                              begin: Alignment(-1.0, -2.0),
                              end: Alignment(1.0, 2.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 12.0,
                                    child: const Icon(Icons.task,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                    child: Text(
                                      'My Challenges',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRoute extends PageRouteBuilder {
  final Widget destination;
  final bool darken;

  CustomRoute({required this.destination, this.darken = false})
      : super(
            opaque: false,
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child,
            ) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return Stack(
                children: <Widget>[
                  FrostTransition(
                    animation: new Tween<double>(
                      begin: 0.0,
                      end: 5.0,
                    ).animate(animation),
                    darken: darken,
                  ),
                  /*FadeTransition(
                opacity: animation,
                child: child,
              ),*/
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                    ).animate(animation),
                    child: child,
                  )
                ],
              );
            },
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
            ) {
              return destination;
            });
}

class FrostTransition extends AnimatedWidget {
  final Animation<double> animation;
  final bool darken;

  FrostTransition({required this.animation, required this.darken})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) => new BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
        child: Container(
          color: darken
              ? Colors.black.withOpacity(animation.value * 0.1)
              : Colors.white.withOpacity(0.0),
        ),
      );
}