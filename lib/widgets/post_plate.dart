import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teelo_flutter/models/user.dart';
import 'package:teelo_flutter/providers/user_provider.dart';
import 'package:teelo_flutter/resources/firestores_methods.dart';
import 'package:teelo_flutter/screens/postcomments_screen.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/widgets/fire_animation.dart';

class PostPlate extends StatefulWidget {
  final snapkey;
  const PostPlate({super.key, required this.snapkey});

  @override
  State<PostPlate> createState() => _PostPlateState();
}

class _PostPlateState extends State<PostPlate> {
  bool isFireAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snapkey['profileImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.snapkey['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: const ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          FirestoresMethods().deletedthePost(
                                              widget.snapkey['postId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert_outlined),
                )
              ],
            ),
          ),
          //Image of post section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoresMethods().firePost(
                  widget.snapkey['postId'], user.uid, widget.snapkey['likes']);
              setState(() {
                isFireAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.34,
                  width: double.infinity,
                  child: Image.network(
                    widget.snapkey['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  opacity: isFireAnimating ? 1 : 0,
                  duration: const Duration(milliseconds: 240),
                  child: FireAnimation(
                    child: const Icon(
                      Icons.whatshot,
                      color: Colors.white,
                      size: 110,
                    ),
                    isAnimatingicon: isFireAnimating,
                    duration: const Duration(
                      milliseconds: 420,
                    ),
                    onEnd: () {
                      setState(() {
                        isFireAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //Like comment section on post
          Row(
            children: [
              FireAnimation(
                isAnimatingicon: widget.snapkey['likes'].contains(user.uid),
                smallFire: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoresMethods().firePost(
                          widget.snapkey['postId'],
                          user.uid,
                          widget.snapkey['likes']);
                    },
                    icon: widget.snapkey['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.whatshot,
                            color: Color.fromARGB(255, 54, 136, 244),
                          )
                        : const Icon(Icons.whatshot)),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.tips_and_updates_outlined,
                    color: Color.fromARGB(255, 248, 50, 50),
                  )),
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                              snapkey: widget.snapkey),
                        ),
                      ),
                  icon: const Icon(
                    Icons.wechat,
                  )),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.share),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.vertical_align_bottom_outlined),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),

          //comments and description of the post
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                  child: Text(
                    '${widget.snapkey['likes'].length} fires', //string interpolation
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snapkey['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '     ${widget.snapkey['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all 1400 comments',
                      style: TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    //This is timestamp so we can't enter like other things
                    //So we use intl package
                    DateFormat.yMMMd().format(
                      widget.snapkey['publishedDate'].toDate(),
                    ),
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
