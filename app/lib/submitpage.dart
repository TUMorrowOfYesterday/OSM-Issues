import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class SubmitPage extends StatefulWidget {
  final XFile image;
  //final String serverAddr;

  const SubmitPage(
      {super.key, required this.image}); //, required this.serverAddr

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  String serverUrl = "172.20.10.7:5000"; //http://172.20.10.7:5000/

  @override
  void initState() {
    super.initState();
    var result = uploadImageHTTP(widget.image, "fix",
        8); //widget.image, 'https://${widget.serverAddr}/' ,
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<int> uploadImageHTTP(imageFile, user, issue) async {
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse(
        'http://' + serverUrl + "/upload_Issue?user=${user}&issue=${issue}");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile =
        http.MultipartFile('image', stream, length, filename: imageFile.path);

    request.files.add(multipartFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Status code: ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List list = jsonDecode(response.body);
      print(list[1]);
      return list[1];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed.');
    }
  }
}
