import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../postFunctions.dart';

class MakePostPage extends StatefulWidget {
  const MakePostPage({super.key});

  @override
  State<MakePostPage> createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  final TextEditingController postTextController = TextEditingController();
  final TextEditingController materialsController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  String selectedDifficulty = "Beginner";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Difficulty Dropdown
              DropdownButtonFormField(
                value: selectedDifficulty,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Difficulty"),
                items: ["Beginner", "Intermediate", "Advanced"].map((difficulty) {
                  return DropdownMenuItem(value: difficulty, child: Text(difficulty));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ),

              SizedBox(height: 16),

              // Post Text
              TextField(
                controller: postTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Post Text",
                ),
              ),

              SizedBox(height: 16),

              // Materials (comma separated)
              TextField(
                controller: materialsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Materials (comma separated)",
                ),
              ),

              SizedBox(height: 16),

              // Tags
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tags (comma separated)",
                ),
              ),

              SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("Upload Post"),
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("You are not logged in")),
                      );
                      return;
                    }

                    String username = user.email!.split("@")[0]; // TEMP username

                    await uploadPostToDb(
                      username,
                      selectedDifficulty,
                      postTextController.text.trim(),
                      materialsController.text.trim().split(","),
                      tagsController.text.trim().split(","),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Post Uploaded!")),
                    );

                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}