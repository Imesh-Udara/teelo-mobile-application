import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teelo_flutter/resources/auth_methods.dart';
import 'package:teelo_flutter/responsive/mobile_screen_layout.dart';
import 'package:teelo_flutter/responsive/responsive_layout_screen.dart';
import 'package:teelo_flutter/screens/login_screen.dart';
import 'package:teelo_flutter/utils/colors.dart';
import 'package:teelo_flutter/utils/utils.dart';
import 'package:teelo_flutter/widgets/text_field_input.dart';

import '../responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioaddController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoadingAni = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioaddController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List imageGallery = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imageGallery;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoadingAni = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioaddController.text,
        file: _image!);
    if (!mounted) return;

    if (res != 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
      showSnackBar(res, context);
    } else {}
    setState(() {
      _isLoadingAni = false;
    });

    print(res);
  }

  void loginNavigation() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          //svg imag
          SvgPicture.asset(
            'assets/Teelo.svg',
            // color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 16,
          ),

          //circulare widget for Image
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-photo-183042379.jpg'),
                    ),
              Positioned(
                bottom: -10,
                left: 78,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(
                    Icons.add_a_photo,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
          TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'Enter your Username',
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter your Email',
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: 'Enter your Password',
            textInputType: TextInputType.text,
            isPass: true,
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _bioaddController,
              hintText: 'Enter your Bio',
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: signUpUser,
            child: Container(
              child: _isLoadingAni
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text('Sign Up'),
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                color: blueColor,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          //This another row foe signup line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Already have an account? "),
              ),
              GestureDetector(
                onTap: loginNavigation,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    )));
  }
}
