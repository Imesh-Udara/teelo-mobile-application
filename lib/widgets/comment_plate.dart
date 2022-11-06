import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentPlate extends StatefulWidget {
  final snapkey;
  const CommentPlate({super.key, required this.snapkey});

  @override
  State<CommentPlate> createState() => _CommentPlateState();
}

class _CommentPlateState extends State<CommentPlate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snapkey['profilePictr']),
            radius: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.snapkey['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '  ${widget.snapkey['text']}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snapkey['publishedDate'].toDate()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.whatshot,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
