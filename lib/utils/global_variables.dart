import 'package:flutter/material.dart';
import 'package:teelo_flutter/screens/feed_screen.dart';
import 'package:teelo_flutter/screens/search_screen.dart';
import 'package:teelo_flutter/screens/upload_post_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  UploadPostScreen(),
  Text('notifi'),
  Text('profile'),
];
