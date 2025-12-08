import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



Future<void> uploadPostToDb(String username, String difficulty, List<String> postText, List<String> materials, List<String> tags) async {
try {
  await FirebaseFirestore.instance.collection("posts").add({
    "author": username, 
    "comment_count": 0, 
    "date": FieldValue.serverTimestamp(),
    "difficulty": difficulty,
    "likes": 0,
    "materials": materials,
    "post_text": postText,
    "tags": tags,
  });
} catch (e) {
  debugPrint(e.toString()); 
}
}

Future<void> postComment(String username, String date, String id, String postID, String commentText) async {
try {
  final originalPost = FirebaseFirestore.instance.collection("posts").doc(postID); 
  originalPost.collection("comments").add({
    "date": FieldValue.serverTimestamp(),
    "likes": 0,
    "text": commentText,
    "username": username,
  });
  originalPost.update({
    "comment_count": FieldValue.increment(1),
  });
} catch (e) {
  debugPrint(e.toString()); 
}
}

Future<void> likePost(String postID) async {
  try {
    final originalPost = FirebaseFirestore.instance.collection("posts").doc(postID); 
    originalPost.update({
      "likes": FieldValue.increment(1),
    });
  } catch (e) {
    debugPrint(e.toString()); 
  }
  }

Future<void> likeComment(String commentID) async {
  try {
    final originalComment = FirebaseFirestore.instance.collection("comment").doc(commentID); 
    originalComment.update({
      "likes": FieldValue.increment(1),
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}