import 'package:app/login_process/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2 -
                        MediaQuery.of(context).size.height / 6,
                  ),
                  // Add your Logo
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 33,
                  ),
                  Text(
                    "Discover amazing adventures around you",
                    style: TextStyle(color: Color(0xFF939DA8), fontSize: 14),
                  )
                ],
              ),
              //Get Started Button
              Column(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secAnimation) {
                      return SlideTransition(
                          position: Tween<Offset>(
                                  begin: Offset(1, 0), end: Offset(0, 0))
                              .animate(CurvedAnimation(
                                  parent: animation, curve: Curves.linear)),
                          child: LoginPage());
                    })),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(27.0)),
                        gradient: LinearGradient(
                          colors: [Color(0xFF18E299), Color(0xFF0FFAE6)],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secAnimation) {
                      return SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: const Offset(0, 0))
                              .animate(CurvedAnimation(
                                  parent: animation, curve: Curves.linear)),
                          child: LoginPage());
                    })),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0
                              ? MediaQuery.of(context).size.height * 0.02
                              : 0),
                      child: Center(
                        child: GradientText(
                          '',
                          colors: [Color(0xFF18E299), Color(0xFF0FFAE6)],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
