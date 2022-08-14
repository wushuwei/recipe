import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Price> fetchData() async {
  final String btcUrl =
      'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD';
  final String demoUrl = 'https://jsonplaceholder.typicode.com/albums/1';
  final response = await http.get(Uri.parse(btcUrl));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // return Album.fromJson(jsonDecode(response.body));
    return Price.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

//{"USD":24134.76}
class Price {
  final double price_in_usd;

  const Price({
    required this.price_in_usd,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(price_in_usd: json['USD']);
  }
}

/*
{
  "userId": 1,
  "id": 1,
  "title": "quidem molestiae enim"
}
 */
class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Future<Album> futureAlbum;
  late Future<Price> futurePrice;

  @override
  void initState() {
    super.initState();
    futurePrice = fetchData();
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
          title: const Text('Bitcoin Price'),
        ),
        body: Center(
          child: FutureBuilder<Price>(
            future: futurePrice,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.price_in_usd.toString());
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
