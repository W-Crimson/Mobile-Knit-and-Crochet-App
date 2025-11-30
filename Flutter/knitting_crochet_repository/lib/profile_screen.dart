import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';


class Profile {
  final String uid;
  final String? email;
  final String? username;
  final String? userBio;
  final List<String> bookmarkedPosts;
  final List<String> createdPosts; 
  final int? Followers;
  final int? Likes; 

  Profile({
    required this.uid,
    this.email,
    required this.username,
    this.userBio = "I'm a new user on this website, hello!",
    required this.bookmarkedPosts,
    required this.createdPosts,
    this.Followers = 0,
    this.Likes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "Username": username,
      "userBio": userBio,
      "bookmarkedPosts": bookmarkedPosts,
      "createdPosts": createdPosts,
      "Followers": Followers,
      "Likes": Likes,
    };
  }
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map["uid"],
      email: map["email"],
      username: map["username"],
      userBio: map["userBio"],
      bookmarkedPosts: List<String>.from(map["bookmarkedPosts"]),
      createdPosts: List<String>.from(map["createdPosts"]),
      Followers: map["Followers"],
      Likes: map["Likes"],
    );
}
}
class ProfileService {
    final CollectionReference _profileCollection = FirebaseFirestore.instance.collection("profile");
    Future<void> createNewProfile(Profile profile) async {
    try {
      final profileDoc = await _profileCollection.doc(profile.uid).get();
      if (!profileDoc.exists) {
        await _profileCollection.doc(profile.uid).set(profile.toMap());
      }
    } catch (e) {
      debugPrint("Error creating profile. Check to see if the account already exists.");
      rethrow; 
    }
    }
  Future<Profile?> getProfile(String uid) async {
  try {
    final docSnapshot = await _profileCollection.doc(uid).get();
    if (docSnapshot.exists) {
      return Profile.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      debugPrint("Profile document does not exist for uid: $uid");
      return null;
    }
  } catch (e) {
    debugPrint("Error retrieving profile: $e");
    return null;
  }
}
  Future<void> updateProfile(Profile profile) async {
    try {
      await _profileCollection.doc(profile.uid).update(profile.toMap());
    } catch (e) {
      debugPrint("Error updating profile: $e");
      rethrow;
    }
  }
  Future<void> deleteProfile(String uid) async {
    try {
      await _profileCollection.doc(uid).delete();
        } catch (e) {
      debugPrint("Error deleting profile: $e");
      rethrow;
  }
  }

  }
class CollectionUtil {

}



// front end stuff
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> getUserProfile() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data found.'));
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Username: ${data['username']}",
                    style: const TextStyle(fontSize: 20)),
                Text("Email: ${data['email']}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}