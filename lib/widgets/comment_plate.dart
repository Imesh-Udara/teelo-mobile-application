import 'package:flutter/material.dart';

class CommentPlate extends StatefulWidget {
  const CommentPlate({super.key});

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
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1667636753807-be27c6cfacab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
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
                        text: 'username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'some description here',
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '22/11/2022',
                      style: TextStyle(
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
              Icons.favorite,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
