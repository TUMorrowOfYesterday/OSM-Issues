import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Placeholderpage extends StatefulWidget {
  const Placeholderpage({super.key});

  @override
  State<Placeholderpage> createState() => _PlaceholderpageState();
}

class _PlaceholderpageState extends State<Placeholderpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Test')),
    );
  }
}
