import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Tracks which page is selected
  int _selectedIndex = 0;

  //List of all pages
  final List<Widget> _pages = [
    WelcomePage(),
    LoginPage(),
    HomePage(),
    SearchPage(),
    UserSettingPage(),
    MyProfilePage(),
    AccessibilityPage(),
    PrivacySettingsPage(),
    SavedPostsPage(),
    MakePostPage(),
    AccessPostPage(),
    PopularPage(),
    CategoriesPage(),
    EnlargedInstructionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
