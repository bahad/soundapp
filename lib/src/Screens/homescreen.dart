import 'package:flutter/material.dart';
import 'package:soundapp/src/Screens/favoritepage.dart';
import 'package:soundapp/src/Screens/homepage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static List<Widget> _pages = <Widget>[
    HomePage(),
    FavoritePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          selectedItemColor: Colors.amberAccent,
          selectedIconTheme:
              const IconThemeData(color: Colors.amberAccent, size: 27),
          unselectedIconTheme:
              const IconThemeData(color: Colors.white, size: 24),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            if (mounted)
              setState(() {
                _selectedIndex = index;
              });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            )
          ],
        ),
        body: _pages.elementAt(_selectedIndex));
  }
}
