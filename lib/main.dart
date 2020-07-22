import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isSearching = false;
  bool _isFirstTime = false;

  double _progress = 0;

  Filters _filterProvider;

  final _searchController = TextEditingController();

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
    if (this._searchController.text.isNotEmpty)
      this._filterProvider.updateSearch(this._searchController.text);
    else
      this._filterProvider.clearSearch();
  }

  void _setProgress(double value) {
    this._progress = value;
    if (this._progress == 1.0) {
      setState(() {
        this._isFirstTime = false;
        prefs.setBool('isFirstTime', false);
      });
    }
  }

  SharedPreferences prefs;

  initFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      this._isFirstTime = (prefs.getBool('isFirstTime') ?? true);
    });
  }

  @override
  void initState() {
    super.initState();

    initFirstTime();

    // Start listening to changes.
    this._searchController.addListener(_updateSearch);
  }

  Widget _buildSplash(double progress) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 127, 0, 1),
        body: Center(
            heightFactor: double.infinity,
            widthFactor: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    'assets/icon/icon.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(
                  'Initializing...\nPlease wait...',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          value: progress,
                        ),
                        Text(
                          "${(progress * 100).toInt()}%",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this._filterProvider = Provider.of<Filters>(context, listen: false);
    final showProvider = Provider.of<Shows>(context);

    showProvider.shows;
    _setProgress(showProvider.progress);

    return this._isFirstTime
        ? _buildSplash(showProvider.progress)
        : Scaffold(
            appBar: AppBar(
              title: !this._isSearching
                  ? Text(_children[_currentIndex]['title'])
                  : TextField(
                      autofocus: true,
                      controller: this._searchController,
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
                if (_currentIndex > 1)
                  IconButton(
                      icon:
                          Icon(!this._isSearching ? Icons.search : Icons.close),
                      onPressed: () {
                        setState(() {
                          this._isSearching = !this._isSearching;
                          if (!this._isSearching) {
                            this._searchController.text = '';
                            this._filterProvider.clearSearch();
                          }
                        });
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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    this._searchController.dispose();
    super.dispose();
  }
}
