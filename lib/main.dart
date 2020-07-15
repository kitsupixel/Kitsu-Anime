import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data/shows.dart';
import './data/episodes.dart';
import './data/links.dart';
import './data/filters.dart';

import './screens/home_screen.dart';
import './screens/all_shows_screen.dart';
import './screens/current_season_screen.dart';
import './screens/show_detail_screen.dart';
import './screens/episode_detail_screen.dart';
import './screens/preferences_screen.dart';
import './screens/latest_screen.dart';

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
        ),
        ChangeNotifierProvider<Episodes>(
          create: (_) => Episodes(),
        ),
        ChangeNotifierProvider<Links>(
          create: (_) => Links(),
        ),
        ChangeNotifierProvider<Filters>(
          create: (_) => Filters(),
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
            )),
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
  bool isSearching = false;

  Filters filterProvider;

  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _children = [
    {'title': 'Home', 'widget': HomeScreen()},
    {'title': 'Latest episodes', 'widget': LatestScreen()},
    {'title': 'Current Season', 'widget': CurrentSeasonScreen()},
    {'title': 'All Shows', 'widget': AllShowsScreen()},
  ];

  final popupMenuItems = ["Settings"];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateSearch() {
    if (searchController.text.isNotEmpty)
      filterProvider.updateSearch(searchController.text);
    else
      filterProvider.clearSearch();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_updateSearch);
  }

  @override
  Widget build(BuildContext context) {
    filterProvider = Provider.of<Filters>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text(_children[_currentIndex]['title'])
            : TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          if (_currentIndex == 0 || _currentIndex > 1)
            IconButton(
                icon: Icon(!isSearching ? Icons.search : Icons.close),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.text = '';
                      filterProvider.clearSearch();
                    }
                  });
                }),
          // PopupMenuButton(onSelected: (String choice) {
          //   if (choice == 'Settings') {
          //     Navigator.of(context).pushNamed(PreferencesScreen.routeName);
          //   }
          // }, itemBuilder: (ctx) {
          //   return popupMenuItems.map((choice) {
          //     return PopupMenuItem<String>(value: choice, child: Text(choice));
          //   }).toList();
          // }),
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
                icon: Icon(Icons.calendar_today), title: Text('Curr. Season')),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              title: Text('All Shows'),
            ),
          ]),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }
}
