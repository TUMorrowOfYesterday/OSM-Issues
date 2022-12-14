import 'package:app/navigationbar/homepage.dart';
import 'package:app/login_process/startpage.dart';
import 'package:app/navigationbar/leaderboard.dart';
import 'package:app/navigationbar/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  _MyAppState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _prefs,
        builder: (context, prefsnap) {
          if (prefsnap.hasData) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              // uid == null with shared preference
              home: (prefsnap.data!.getString("uid") == null)
                  ? StartPage()
                  : (() {
                      globals.userId = prefsnap.data!.getString("uid")!;
                      return MyHomePage();
                    })(),
            );
          } else
            return MaterialApp();
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        body: IndexedStack(
          children: <Widget>[
            Homepage(),
            LeaderBoard(),
            Profile(),
          ],
          index: index,
        ),
        bottomNavigationBar: NavigationBar(
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Homepage'),
            NavigationDestination(
                icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ));
  }
}
