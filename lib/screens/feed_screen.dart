import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/widgets/post_plate.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/Teelo.svg',
          height: 32,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message_rounded))
        ],
      ),
      body: const PostPlate(),
    );
  }
}
