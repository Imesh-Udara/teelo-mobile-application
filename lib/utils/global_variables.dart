import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teelo_flutter/screens/feed_screen.dart';
import 'package:teelo_flutter/screens/profile_scree.dart';
import 'package:teelo_flutter/screens/search_screen.dart';
import 'package:teelo_flutter/screens/upload_post_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const UploadPostScreen(),
  const Text('notifi'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
