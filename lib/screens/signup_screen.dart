import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    print(res);

    setState(() {
      _isLoading = false;
    });

    if (res != 'Success!') {
      showSnakBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),

          // svg instagram logo
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),

          const SizedBox(
            height: 25,
          ),

          // circular Avatar
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
                          "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: selectImage,
                ),
              )
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          // username text field input
          TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Enter your username",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 24,
          ),

          // email text field input
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),

          const SizedBox(
            height: 24,
          ),

          // passsword text field input
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: "Enter your password",
            textInputType: TextInputType.text,
            isPass: true,
          ),

          const SizedBox(
            height: 24,
          ),

          //bio text field input
          TextFieldInput(
              textEditingController: _bioController,
              hintText: "Enter your bio",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 24,
          ),

          // Signup Button
          InkWell(
            onTap: signupUser,
            child: Container(
              child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor),): const Text('Sign Up'),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: blueColor),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text("Don't have an account?"),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  )),
            ],
          )
        ],
      ),
    )));
  }
}
