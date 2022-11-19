import 'package:app/placeholderpage.dart';
import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'Provider/layoutprovider.dart';

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
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => {},
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.15,
                        width: MediaQuery.of(context).size.width * 0.55,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                                  child: const Icon(Icons.person),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18.0),
                                  child: Text(
                                    'My Avatar',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
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
    ));
  }
}
