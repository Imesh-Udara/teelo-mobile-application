import 'dart:js';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teelo_flutter/models/post.dart';
import 'package:teelo_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoresMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //uploading post function
  Future<String> uploadPost(
    String uid,
    String description,
    Uint8List file,
    String username,
    String profileImage,
  ) async {
    String res = "Oh Somthing wrong!!";
    try {
      String imageUrl =
          await StorageMethods().uploadImageStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        publishedDate: DateTime.now(),
        postUrl: imageUrl,
        profileImage: profileImage,
        likes: [],
      );
//await ????
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "post_success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //fire post == like post methods
  Future<void> firePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //post the comment
  Future<void> postTheComment(String postId, String text, String uid,
      String name, String profilePictr) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePictr': profilePictr,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'publishedDate': DateTime.now(),
        });
      } else {
        print('comment section is Empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete the post

  Future<void> deletedthePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  //following user methods
  Future<void> followTheUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapkey =
          await _firestore.collection('users').doc(uid).get();
      List following = (snapkey.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      }else{
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
