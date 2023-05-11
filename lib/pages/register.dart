// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/pages/login.dart';
import 'package:e_commerce_app/shared/check%20password.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/contants.dart';
import 'package:e_commerce_app/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isVisibility = true;
  bool isPassword8Char = false;
  bool isHasDigits = false;
  bool isHasUppercase = false;
  bool isHasLowercase = false;
  bool isHasSpecialCharacters = false;
  File? imgPath;
  ImageSource? galleryOrCamera;
  String? imgName;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final titleController = TextEditingController();
  checkPasswordVal(String password) {
    isPassword8Char = false;
    isHasDigits = false;
    isHasUppercase = false;
    isHasLowercase = false;
    isHasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        isHasDigits = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        isHasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        isHasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        isHasSpecialCharacters = true;
      }
    });
  }

  registerCount() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      final storageRef = FirebaseStorage.instance.ref("UserImges/$imgName");
      await storageRef.putFile(imgPath!);
      String url = await storageRef.getDownloadURL();

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users
          .doc(credential.user!.uid)
          .set({
            "imglink": url,
            "username": usernameController.text,
            "age": ageController.text,
            "title": titleController.text,
            "email": emailController.text,
            "Password": passwordController.text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  uploadImageToScreen(galleryOrCamera) async {
    final pickedImg = await ImagePicker().pickImage(source: galleryOrCamera);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
    if (mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SIGN UP"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: appbarGreen,
        ),
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Stack(
                        children: [
                          imgPath == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 64,
                                  foregroundImage:
                                      AssetImage("assets/img/User_Avatar.png"),
                                )
                              : ClipOval(
                                  child: Image.file(
                                    imgPath!,
                                    width: 145,
                                    height: 145,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                              onPressed: () {
                                showModal(context);
                              },
                              icon: Icon(Icons.add_a_photo, color: appbarGreen),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your username : ",
                            suffixIcon: Icon(Icons.person))),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your age : ",
                        suffixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your title : ",
                            suffixIcon: Icon(Icons.person_outline))),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                        validator: (email) {
                          return email != null &&
                                  email.contains(
                                    RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                                  )
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Email : ",
                            suffixIcon: Icon(Icons.email))),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        checkPasswordVal(value);
                      },
                      validator: (value) {
                        return value != null && value.length < 8
                            ? "Enter at least 8 characters"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: isVisibility ? true : false,
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Password : ",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisibility = !isVisibility;
                            });
                          },
                          icon: isVisibility
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CheckPasswordValidate(
                        theCondition: isPassword8Char,
                        theConditionText: "At least 8 characters"),
                    const SizedBox(
                      height: 15,
                    ),
                    CheckPasswordValidate(
                        theCondition: isHasDigits,
                        theConditionText: "At least 1 number"),
                    const SizedBox(
                      height: 15,
                    ),
                    CheckPasswordValidate(
                        theCondition: isHasUppercase,
                        theConditionText: "Has Uppercase"),
                    const SizedBox(
                      height: 15,
                    ),
                    CheckPasswordValidate(
                        theCondition: isHasLowercase,
                        theConditionText: "Has  Lowercase "),
                    const SizedBox(
                      height: 15,
                    ),
                    CheckPasswordValidate(
                        theCondition: isHasSpecialCharacters,
                        theConditionText: "Has  Special Characters "),
                    const SizedBox(
                      height: 33,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            imgName != null &&
                            imgPath != null) {
                          await registerCount();
                          if (!mounted) return;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        } 
                        else if(imgName == null || imgPath == null ){
                          showSnackBar(context, "Error: plz pick an image.");
                        }
                        else {
                          showSnackBar(context, "Error");
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.blue,
                            )
                          : Text(
                              "Register",
                              style: TextStyle(fontSize: 19),
                            ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(BTNgreen),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do not have an account?",
                            style: TextStyle(fontSize: 18)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: Text('sign in',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showModal(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(.8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        isDismissible: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              await uploadImageToScreen(ImageSource.gallery);
                            },
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 50,
                              color: appbarGreen,
                            ),
                          ),
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(fontSize: 24, color: appbarGreen),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              await uploadImageToScreen(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera,
                                size: 50, color: appbarGreen),
                          ),
                        ),
                        const Text(
                          "camera",
                          style: TextStyle(fontSize: 30, color: appbarGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
