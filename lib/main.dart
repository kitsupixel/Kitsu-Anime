import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data/shows.dart';

import './screens/all_shows_screen.dart';
import './screens/show_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Shows>(
          create: (_) => Shows(),
        )
      ],
      child: MaterialApp(
        title: 'Kitsu\'s Anime',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Kitsu\'s Anime"),
          ),
          body: AllShowsScreen(),
        ),
        routes: {
          ShowDetailScreen.routeName: (ctx) => ShowDetailScreen(),
        },
      ),
    );
  }
}
