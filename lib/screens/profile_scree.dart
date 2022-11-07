import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/utils/utils.dart';
import 'package:teelo_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postCountLength = 0;
  int showFollowers = 0;
  int showFollowing = 0;
  bool isFollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnapkey = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      //need to get post lenght
      var postSnapkey = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postCountLength = postSnapkey.docs.length;
      userData = userSnapkey.data()!;
      showFollowers = userSnapkey.data()!['followers'].length;
      showFollowing = userSnapkey.data()!['following'].length;
      isFollowing = userSnapkey
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: Text(
          userData['username'],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      backgroundImage: NetworkImage(userData['imageUrl']),
                      radius: 42,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              stateColumn(postCountLength, "posts  "),
                              stateColumn(showFollowers, "  followers  "),
                              stateColumn(showFollowing, "  following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid?
                              FollowButton(
                                text: 'Edit Profile',
                                profileBackgroundColor: mobileBackgroundColor,
                                textColor: primaryColor,
                                profileBorderColor: Colors.grey,
                                function: () {},
                              ): isFollowing ?FollowButton(
                                text: 'Unfollow',
                                profileBackgroundColor: Colors.white10,
                                textColor: Colors.black12,
                                profileBorderColor: Colors.grey,
                                function: () {},
                              ): FollowButton(
                                text: 'Follow',
                                profileBackgroundColor: Colors.red,
                                textColor: Colors.white12,
                                profileBorderColor: Colors.red,
                                function: () {},
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              userData['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(userData['bio']),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Column stateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
