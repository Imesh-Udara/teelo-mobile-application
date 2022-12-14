import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teelo_flutter/models/user.dart';
import 'package:teelo_flutter/providers/user_provider.dart';
import 'package:teelo_flutter/resources/firestores_methods.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/utils/utils.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionsController = TextEditingController();
  //for loading
  bool _isLoadingIndicator = false;

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    //loarding indicator
    setState(() {
      _isLoadingIndicator = true;
    });
    try {
      String res = await FirestoresMethods().uploadPost(
          uid, _descriptionsController.text, _file!, username, profileImage);
      if (res == "post_success") {
        setState(() {
          _isLoadingIndicator = false;
        });
        showSnackBar('Posted!!', context);
        showclearBackground();
      } else {
        setState(() {
          _isLoadingIndicator = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void showclearBackground() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: showclearBackground,
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.imageUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
              // centerTitle: true,
            ),
            body: Column(
              children: [
                _isLoadingIndicator
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.46,
                      child: TextField(
                        controller: _descriptionsController,
                        decoration: InputDecoration(
                          hintText: 'Write a Something',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      width: 44,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 480,
                      child: AspectRatio(
                        aspectRatio: 487,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 64,
                      width: 100,
                        child: TextButton(onPressed: () => _selectImage(context),
                        child: Text('Change'),
                          
                        ),
                      
                    ),
                  ],
                ),

              ],
            ),
          );
  }
}
