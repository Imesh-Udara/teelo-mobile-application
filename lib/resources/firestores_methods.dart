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

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "post_success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
