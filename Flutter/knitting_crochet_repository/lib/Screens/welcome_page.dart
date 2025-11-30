import 'package:flutter/material.dart';

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