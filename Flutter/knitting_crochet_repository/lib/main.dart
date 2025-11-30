import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _submitSignUp() async {
    // 1. Validate the entire form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = Provider.of<AuthNotifier>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // 2. ⭐ Call the Firebase registration method ⭐
      await authService.signUpWithEmail(email, password);
      
      // 3. SUCCESS: Navigate to the Home screen
      Navigator.pushReplacementNamed(context, '/HomePage'); 

    } catch (errorMessage) {
      // 4. ERROR: Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... Scaffold and Form structure
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Email Field (Same as Login)
                _buildEmailField(),
                const SizedBox(height: 16.0),
                // Password Field (Same as Login)
                _buildPasswordField(),
                const SizedBox(height: 16.0),
                // Confirm Password Field (New)
                _buildConfirmPasswordField(),
                const SizedBox(height: 32.0),
                
                // Sign Up Button with Loading State
                _buildSignUpButton(),
                
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => Navigator.pop(context), // Go back to Login
                  child: const Text('Already have an account? Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper methods for cleaner build function (replace with your actual field code)
  Widget _buildEmailField() { /* ... implementation with _emailController ... */ return TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())); }
  Widget _buildPasswordField() { /* ... implementation with _passwordController ... */ return TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()), obscureText: true); }
  
  // Custom Validation for Password Confirmation
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match'; // Crucial check
        }
        return null;
      },
    );
  }
  
  Widget _buildSignUpButton() {
    final auth = Provider.of<AuthNotifier>(context);
    return ElevatedButton(
      onPressed: auth.isLoading ? null : _submitSignUp,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: auth.isLoading
          ? const SizedBox(
              height: 20, 
              width: 20, 
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
            )
          : const Text('Create Account'),
    );
  }
}

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signUpWithEmail(String email, String password) async {
  _setLoading(true);

  try {
    // The key difference: use createUserWithEmailAndPassword
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Note: If you need to save user data (like name, profile image)
    // to Firestore, you would do it here using the new user's UID:
    // await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
    //   'email': email,
    //   'createdAt': FieldValue.serverTimestamp(),
    // });

  } on FirebaseAuthException catch (e) {
    String message = 'An error occurred during sign-up.';
    if (e.code == 'email-already-in-use') {
      message = 'This email is already registered.';
    } else if (e.code == 'weak-password') {
      message = 'The password is too weak.';
    }
    _setLoading(false);
    throw message;
  } catch (e) {
    _setLoading(false);
    throw 'An unexpected error occurred.';
  }

  _setLoading(false);
}

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);

    try {
      // 1. Call the Firebase sign-in method
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Success is handled automatically by FirebaseAuth's StreamBuilder
      // which should be listening for User changes in your main app file.

    } on FirebaseAuthException catch (e) {
      // 2. Handle specific Firebase errors (e.g., wrong password)
      String message = 'An error occurred. Please check your credentials.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      _setLoading(false);
      // 3. Throw the error so the UI can catch and display it
      throw message; 
    } catch (e) {
      // Handle generic errors
      _setLoading(false);
      throw 'An unexpected error occurred.';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
class ThemeNotifier with ChangeNotifier {
  bool _isHighContrast = false;

  bool get isHighContrast => _isHighContrast;

  void toggleTheme() {
    _isHighContrast = !_isHighContrast;
    notifyListeners(); // Tells all listening widgets to rebuild
  }
}

// Standard Theme (Example)
final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Color(0xFFE0E0E0), // Light gray
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

// High Contrast Theme
final ThemeData highContrastTheme = ThemeData(
  brightness: Brightness.light,
  // Use pure white background and pure black foreground for maximum contrast
  primaryColor: Color(0xFF1C304A), // Highly visible accent color
  scaffoldBackgroundColor: Color(0xFF046B99),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFFB3EFFF), // Highly visible text color
      fontWeight: FontWeight.bold, // Increase readability
    ),
    titleLarge: TextStyle(color: Color(0xFFB3EFFF),),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF1C304A), // High-contrast button color
  ),
);

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
        '/HomePage': (context) => HomePage(),
        '/SignUpScreen': (context) => SignUpScreen(),
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
                Navigator.pushNamed(context, '/SignUpScreen');
              },
              child: const Text('Create Account'),
            ),
            SizedBox(height: 12,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/HomePage');
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
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//Add in login features
  final _formKey = GlobalKey<FormState>(); //Global key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = Provider.of<AuthNotifier>(context, listen: false);
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // 1. Call the async sign-in method
      await authService.signInWithEmail(email, password);
      
      // 2. SUCCESS: Navigate to the Home screen (Login page is replaced)
      // Note: You should have a route named '/home' defined in your MaterialApp
      Navigator.pushReplacementNamed(context, '/HomePage'); 

    } catch (errorMessage) {
      // 3. ERROR: Display the error message in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
}
  
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 1. Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                       return 'Please enter a valid email';
                    }
                    return null; // Input is valid
                  },
                ),
                
                const SizedBox(height: 16.0),

                // 2. Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Hides the input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null; // Input is valid
                  },
                ),

                const SizedBox(height: 32.0),

                // 3. Login Button
                // Replace your old ElevatedButton with this:
                Consumer<AuthNotifier>(
                  builder: (context, auth, child) {
                    return ElevatedButton(
                      onPressed: auth.isLoading ? null : _submitLogin, // Disable button while loading
                      style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: auth.isLoading
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      )
                    : const Text('Log In'),
                  );
                },
              ),
              ]
            )
          )
        )
      )
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

class MySearchDelegate extends SearchDelegate {
  
  // Dummy data to search through
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Pear",
    "Watermelon",
    "Oranges",
    "Blueberries",
    "Strawberries",
    "Raspberries",
  ];

  // 1. Build the "Clear" (X) button on the right
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search bar text
        },
      ),
    ];
  }

  // 2. Build the "Back" arrow on the left
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search, return nothing
      },
    );
  }

  // 3. Show Results (What appears when user hits "Enter")
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // 4. Show Suggestions (What appears while typing)
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result; // Fill the search bar with this suggestion
            showResults(context); // Force show results
          },
        );
      },
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
     throw UnimplementedError();
  }
}
class UserSettingPage extends StatefulWidget {
  const UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    @override
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SwitchListTile(
        title: Text('High Contrast Mode'),
        value: Provider.of<ThemeNotifier>(context).isHighContrast, // Read the value
        onChanged: (bool newValue) {
          themeNotifier.toggleTheme(); // Call the toggle method
        },
      ),
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