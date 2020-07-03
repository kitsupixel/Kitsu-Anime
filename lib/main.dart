import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:preferences/preferences.dart';

import './data/shows.dart';
import './data/episodes.dart';
import './data/links.dart';

import './screens/home_screen.dart';
import './screens/all_shows_screen.dart';
import './screens/current_season_screen.dart';
import './screens/show_detail_screen.dart';
import './screens/episode_detail_screen.dart';
import './screens/preferences_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContextcontext) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Shows>(
          create: (_) => Shows(),
        ),
        ChangeNotifierProvider<Episodes>(
          create: (_) => Episodes(),
        ),
        ChangeNotifierProvider<Links>(
          create: (_) => Links(),
        ),
      ],
      child: MaterialApp(
        title: 'Kitsu\'s Anime',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.deepOrange,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
          ) 
        ),
        home: Home(),
        routes: {
          ShowDetailScreen.routeName: (ctx) => ShowDetailScreen(),
          EpisodeDetailScreen.routeName: (ctx) => EpisodeDetailScreen(),
          PreferencesScreen.routeName: (ctx) => PreferencesScreen()
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Map<String,dynamic>> _children = [
    {'title': 'Home', 'widget': HomeScreen()},
    {'title': 'Latest episodes', 'widget': AllShowsScreen()},
    {'title': 'Current Season', 'widget': CurrentSeasonScreen()},
    {'title': 'All Shows', 'widget': AllShowsScreen()},
  ];

  final popupMenuItems = [
    "Settings"
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_children[_currentIndex]['title']),
        actions: [

          if (_currentIndex > 1)
          IconButton(icon: Icon(Icons.search), onPressed: () {

          }),
          PopupMenuButton(
            onSelected: (String choice) {
              if (choice == 'Settings') {
                Navigator.of(context).pushNamed(PreferencesScreen.routeName);
              }
            },
            itemBuilder: (ctx) {
            return popupMenuItems.map((choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice)
                );
            }).toList(); 
          }),
        ],
      ),
      body: _children[_currentIndex]['widget'],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped, // new
          currentIndex: _currentIndex,
          backgroundColor: Theme.of(context).primaryColor,
          showUnselectedLabels: false,
          selectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed),
              title: Text('Latest'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Curr. Season')),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              title: Text('All Shows'),
            ),
          ]),
    );
  }
}
