import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/RandomRecipe.dart';

Future<RandomRecipe> fetchData() async {
  final String dataUrl =
      'https://api.spoonacular.com/recipes/random?apiKey=c2943c1350bc4083a3fbc02d3a09e5b0&number=1&tags=chicken,cheeze';

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

                return Column(children: <Widget>[
                  Text(snapshot.data!.recipes!.first.title!),
                  Image.network(snapshot.data!.recipes!.first.image!),
                  Html(
                    data: snapshot.data!.recipes!.first.summary!,
                    // Styling with CSS (not real CSS)
                    style: {
                      'h1': Style(color: Colors.red),
                      'p': Style(color: Colors.black87, fontSize: FontSize.medium),
                      'ul': Style(margin: const EdgeInsets.symmetric(vertical: 20))
                    },
                  ),
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
