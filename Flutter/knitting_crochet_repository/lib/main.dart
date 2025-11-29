import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './postFunctions.dart';
import './authFunctions.dart';

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage(),

      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/LoginPage': (context) => LoginPage(),
        '/HomePage': (context) => HomePage(),
        '/AccountCreation': (context) => AccountCreation(),
        '/SearchPage' : (context) => SearchPage(),
        '/UserSettingPage' : (context) => UserSettingPage(),
        '/AccessibilityPage' : (context) => AccessibilityPage(),
        '/PrivacySettingsPage' : (context) => PrivacySettingsPage(),
        '/MyCollectionsPage' : (context) => MyCollectionsPage(),
        '/MakePostPage' : (context) => MakePostPage(),
        '/PopularPage' : (context) => PopularPage(),
        '/AccessPostPage' : (context) => AccessPostPage(),
        '/CategoriesPage' : (context) => CategoriesPage(),
        '/EnlargedInstructionsPage' : (context) => EnlargedInstructionsPage(),
      },
    );
  }
}
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Let\'s get started!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AccountCreation');
              },
              child: const Text('Create Account'),
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/HomePage');
              },
              child: const Text('Continue as Guest'),
            ),
            
          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/LoginPage');
          },
          child: const Text('Already have an account?'),
        ),
      ],
    );
  }
}

class AccountCreation extends StatelessWidget {
  const AccountCreation({super.key});
//Add in login features
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Or any other icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create Account', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
//Add in login features
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Or any other icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Home Page', style: TextStyle(fontSize: 24)),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/HomePage');
          }
          , child: const Text('Home')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/MyCollectionsPage');
          }
          , child: const Text('My Collections')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/UserSettingsPage');
          }
          , child: const Text('User Settings')),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Or any other icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: 
      
      SingleChildScrollView(
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
    );
  }
}
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class UserSettingPage extends StatelessWidget {
  const UserSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyCollectionsPage extends StatefulWidget {
  const MyCollectionsPage({super.key});

  @override
  State<MyCollectionsPage> createState() => MyCollectionsPageState();
}

class MyCollectionsPageState extends State<MyCollectionsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MakePostPage extends StatefulWidget {
  const MakePostPage({super.key});

  @override
  State<MakePostPage> createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class AccessPostPage extends StatefulWidget {
  const AccessPostPage({super.key});

  @override
  State<AccessPostPage> createState() => _AccessPostPageState();
}

class _AccessPostPageState extends State<AccessPostPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class EnlargedInstructionsPage extends StatefulWidget {
  const EnlargedInstructionsPage({super.key});

  @override
  State<EnlargedInstructionsPage> createState() => _EnlargedInstructionsPageState();
}

class _EnlargedInstructionsPageState extends State<EnlargedInstructionsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}