import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

// class BoardElements {
//   final String uid;
//   final int score;
//   final int avatarId;

//   const BoardElements({
//     required this.uid,
//     required this.score,
//     required this.avatarId,
//   });

//   factory BoardElements.fromJson(Map<String, dynamic> json) {
//     return BoardElements(
//       uid: json['uid'],
//       score: json['score'],
//       avatarId: json['avatarId'],
//     );
//   }
// }

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List? boardList;

  List<Widget> mapToMarker() {
    List<Widget> results = [];
    if (boardList == null) return results;
    for (int i = 0; i < boardList!.length; i++) {
      results.add(Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // boardList
            if (i == 0)
              Text(
                "${i + 1}.  ",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              )
            else if (i == 1)
              Text(
                "${i + 1}.  ",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange),
              )
            else
              Text(
                "${i + 1}.  ",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            if (i == 0)
              Text(
                boardList![i][0] + "  ",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              )
            else if (i == 1)
              Text(
                boardList![i][0] + "  ",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange),
              )
            else
              Text(
                boardList![i][0] + "  ",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            if (i == 0)
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  boardList![i][1].toString(),
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
              )
            else if (i == 1)
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  boardList![i][1].toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  boardList![i][1].toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
          ],
        ),
      ));
    }

    return results;
  }

  void getLeaderboardList() async {
    try {
      var response =
          await http.get(Uri.parse(globals.serverUrl + "leaderboard"));
      // print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          boardList = jsonDecode(response.body);
          // print(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLeaderboardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Leaderboard',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                // Bounce Bounce
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Container(
                  // height: MediaQuery.of(context).size.height / 1.0,
                  padding: const EdgeInsets.only(top: 20, left: 32.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 30.0,
                            child: const Icon(
                              Icons.leaderboard,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              'Ranking',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // get ranking by getindex -= 1;
                      Column(children: mapToMarker()),
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
