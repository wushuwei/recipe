import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/RandomRecipe.dart';

Future<RandomRecipe> fetchData(final String dataUrl ) async {

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

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'One Recipe every day';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }


}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final textFormFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: textFormFieldController,
            decoration: const InputDecoration(
              hintText: 'Enter your tags (such as chicken,beef)',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  // String urlString = 'https://api.spoonacular.com/recipes/random?apiKey=c2943c1350bc4083a3fbc02d3a09e5b0&number=1&tags=chicken,cheeze';
                  String query = textFormFieldController.text;
                  String urlString = 'https://api.spoonacular.com/recipes/random?apiKey=c2943c1350bc4083a3fbc02d3a09e5b0&number=1&tags=';
                  urlString += query;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetails(dataUrl: urlString,)
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}




// final String urlString = 'https://api.spoonacular.com/recipes/random?apiKey=c2943c1350bc4083a3fbc02d3a09e5b0&number=1&tags=chicken,cheeze';
// void main() => runApp(const RecipeDetails(String: urlString,));

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key, required this.dataUrl});

  final String dataUrl;


  @override
  State<RecipeDetails> createState() => _RecipeDetailsState(dataUrl: dataUrl);
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late Future<RandomRecipe> futureRandomRecipe;

  _RecipeDetailsState({required this.dataUrl});

  final String dataUrl;

  @override
  void initState() {
    super.initState();
    futureRandomRecipe = fetchData(dataUrl);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

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
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to first route when tapped.
                      Navigator.pop(context);
                    },
                    child: const Text('Go back!'),
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

    );
  }
}
