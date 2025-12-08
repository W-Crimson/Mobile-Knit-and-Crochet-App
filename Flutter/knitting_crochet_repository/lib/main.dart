import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Screens/SignUpScreen.dart';
import 'Notifiers/auth_notifier.dart';
import 'Notifiers/theme_notifier.dart';
import 'Screens/login_page.dart';
import 'Screens/welcome_page.dart';
import 'Screens/home_page.dart';
import 'Screens/user_settings_page.dart';
import 'authFunctions.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()), // Your existing theme service
        ChangeNotifierProvider(create: (_) => AuthNotifier()), // ⭐ The new auth service ⭐
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    @override
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'MyApp',
      theme: themeNotifier.isHighContrast ? highContrastTheme : defaultTheme,
      home: WelcomePage(),

      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/LoginPage': (context) => LoginPage(),
        '/AuthScreen': (context) => AuthScreen(),
        '/HomePage': (context) => HomePage(),
        '/SignUpScreen': (context) => SignUpScreen(),
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