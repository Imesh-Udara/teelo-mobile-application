import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teelo_flutter/models/user.dart';
import 'package:teelo_flutter/providers/user_provider.dart';
import 'package:teelo_flutter/resources/firestores_methods.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/widgets/comment_plate.dart';

class CommentsScreen extends StatefulWidget {
  final snapkey;
  const CommentsScreen({super.key, required this.snapkey});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  //for the comment text
  final TextEditingController _commentingController = TextEditingController();
  //commenting text
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snapkey['postId'])
            .collection('comments')
            .orderBy('publishedDate', descending: true) //set the comment for decending
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentPlate(
              snapkey: (snapshot.data! as dynamic).docs[index].data()
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(
            left: 16,
            right: 8,
            bottom: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 14.0, right: 8, bottom: 8),
                  child: TextField(
                    controller: _commentingController,
                    decoration: InputDecoration(
                      hintText: 'Comment what you feel ${user.username} ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoresMethods().postTheComment(
                    widget.snapkey['postId'],
                    _commentingController.text,
                    user.uid,
                    user.username,
                    user.imageUrl,
                  );
                  setState(() {
                    _commentingController.text = "";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
