import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_delegate.dart';
import '../Notifiers/theme_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
      // 1. Define the Drawer (The slide-out menu)
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,),
              child: Text('Menu', style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: 32)),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text('My Collections', style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: 24) ),
              onTap: () {
                Navigator.pushNamed(context, '/MyCollectionsPage');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).textTheme.titleLarge!.color),
              title: Text('User Settings', style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: 24)),
              onTap: () {
                Navigator.pushNamed(context, '/UserSettingsPage');
              },
            ),
            SwitchListTile(
              title: Text('High Contrast', style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color, fontSize: 24)),
              value: Provider.of<ThemeNotifier>(context).isHighContrast, // Read the value
              onChanged: (bool newValue) {
                themeNotifier.toggleTheme(); // Call the toggle method
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("Featured"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
        // This is the built-in Flutter method.
        // You must pass the context and your custom delegate (created below)
              showSearch(
                context: context, 
                delegate: MySearchDelegate()
              );
            },
          )
        ],
      ),
      body: 
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 20; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Button ${i + 1} pressed');
                      },
                      child: Text('Button ${i + 1}'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}