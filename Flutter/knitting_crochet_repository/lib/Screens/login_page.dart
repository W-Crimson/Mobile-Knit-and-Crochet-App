import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Notifiers/auth_notifier.dart';

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