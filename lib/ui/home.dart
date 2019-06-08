import 'package:flutter/material.dart';
import 'package:notodo_firebase/ui/notodo.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoToDo"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: NoToDoScreen(),
    );
  }
}


//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//        centerTitle: true,
//      ),
//    );
//  }
//}
