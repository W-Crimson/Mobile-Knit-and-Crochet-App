import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Notifiers/auth_notifier.dart'; // Import your authentication service

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