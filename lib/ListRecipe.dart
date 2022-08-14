import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Tutorial - googleflutter.com'),
      ),
      body: Center(
          child: Column(children: <Widget>[
            Text('Welcome to Flutter Tutorial on Image'),
            Image.network('https://spoonacular.com/recipeImages/641975-556x370.jpg'),
          ])),
    );
  }
}