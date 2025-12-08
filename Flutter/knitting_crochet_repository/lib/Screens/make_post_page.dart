import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../postFunctions.dart';


/* 

I NEED TO ADD IMAGE UPLOAD SUPPORT FOR EACH STEP.

*/
class MakePostPage extends StatefulWidget {
  const MakePostPage({super.key});

  @override
  State<MakePostPage> createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  final TextEditingController _postTextBox = TextEditingController();
  final TextEditingController _materialsBox = TextEditingController(); 
  final TextEditingController _tagsBox = TextEditingController(); 
  
  String _difficulty = 'Easy';
  final List<String> _difficultyOptions = ['Easy', 'Medium', 'Hard', 'Expert'];

  final String _username = FirebaseAuth.instance.currentUser?.email ?? "Anonymous";

  @override
  void dispose() {
    _postTextBox.dispose();
    _materialsBox.dispose();
    _tagsBox.dispose();
    super.dispose();
  }

  void _submitPost() async {
    if (_postTextBox.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter post instructions')),
      );
      return;
    }

    List<String> materials = _materialsBox.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    List<String> tags = _tagsBox.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    List<String> postTextSteps = _postTextBox.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    await uploadPostToDb(
      _username, 
      _difficulty,
      postTextSteps,
      materials,
      tags,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded successfully!')),
      );
      Navigator.pop(context); // Go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Posting as: $_username", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Choose the difficulty level of your post',
                  border: OutlineInputBorder(),
                ),
                items: _difficultyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _difficulty = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _materialsBox,
                decoration: const InputDecoration(
                  labelText: 'Add your materials here:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Tags 
              TextField(
                controller: _tagsBox,
                decoration: const InputDecoration(
                  labelText: 'Tag your post: ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _postTextBox,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Instructions / Pattern',
                  hintText: 'Write your pattern details here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              //Submissions
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Upload Post', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
