import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class SettingsUrl extends StatefulWidget {
  const SettingsUrl({super.key});

  @override
  State<SettingsUrl> createState() => _SettingsUrlState();
}

class _SettingsUrlState extends State<SettingsUrl> {
  final myController = TextEditingController();
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
                      "Change Url",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        controller: myController,
                        onSubmitted: (value) async {
                          if (value != '') {
                            globals.serverUrl = value;
                          }
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700]!.withOpacity(0.4)),
                          hintText: 'Enter new Url',
                          fillColor: Colors.white,
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF0FFAE6),
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF0FFAE6)),
                              borderRadius: BorderRadius.circular(6)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey[700]!.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                    ),
                    InkWell(
                      onTap: () {
                        if (myController.text != '')
                          globals.serverUrl = myController.text;
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.25,
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
                            'Change',
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
