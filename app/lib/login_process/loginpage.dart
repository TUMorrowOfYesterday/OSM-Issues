import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:app/navigationbar/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:image_cropper/image_cropper.dart';

import '../main.dart';
import '../globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> a_prefs = SharedPreferences.getInstance();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Center(
                              child: Text(
                                'Sign into your unique ID',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // textfield
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: TextField(
                              controller: myController,
                              onSubmitted: (value) async {
                                // if val exists in database resgister anfrage
                                // just enter save in sharedpref
                                // if val doenst exist
                                if (value != '') {
                                  var response = await http.post(
                                      Uri.parse(globals.serverUrl +
                                          'register?user=${myController.text}'),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      });
                                  // print(response.body);
                                  if (response.statusCode == 200 &&
                                      jsonDecode(response.body) == true) {
                                    // If the server did return a 201 CREATED response,
                                    // then parse the JSON.

                                    // save value to shared pref

                                    // fix push to the end
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    // If the server did not return a 201 CREATED response,
                                    // then throw an exception.
                                    // Maybe snackbar
                                    throw Exception('Failed to Register');
                                  }
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
                                hintText: 'Enter your unique ID',
                                fillColor: Colors.white,
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0FFAE6),
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0FFAE6)),
                                    borderRadius: BorderRadius.circular(6)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey[700]!.withOpacity(0.4)),
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
                        ]),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
