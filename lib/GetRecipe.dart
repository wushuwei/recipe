import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/RandomRecipe.dart';

Future<RandomRecipe> fetchData() async {
  final String dataUrl =
      'https://api.spoonacular.com/recipes/random?apiKey=c2943c1350bc4083a3fbc02d3a09e5b0&number=1&tags=beef,chicken';

  final response = await http.get(Uri.parse(dataUrl));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // return Album.fromJson(jsonDecode(response.body));
    return RandomRecipe.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<RandomRecipe> futureRandomRecipe;

  @override
  void initState() {
    super.initState();
    futureRandomRecipe = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin Price',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Random Recipe'),
        ),
        body: Center(
          child: FutureBuilder<RandomRecipe>(
            future: futureRandomRecipe,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data!.recipes[0].summary);
                String textConent = "";
                String imageLink = "https://spoonacular.com/recipeImages/641975-556x370.jpg";
                if(snapshot.data!.recipes!.first.summary != null){
                  textConent = snapshot.data!.recipes!.first.summary.toString();
                }

                return Column(children: <Widget>[
                  Text(snapshot.data!.recipes!.first.title!),
                  Image.network(imageLink),
                ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
