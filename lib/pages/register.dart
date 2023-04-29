// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:e_commerce_app/pages/login.dart';
import 'package:e_commerce_app/shared/check%20password.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/contants.dart';
import 'package:e_commerce_app/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    const SizedBox(
                      height: 64,
                    ),
                    TextField(
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your username : ",
                            suffixIcon: Icon(Icons.person))),
                    const SizedBox(
                      height: 33,
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
                      height: 33,
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
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                         await registerCount();
                          if (!mounted) return;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        } else {
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
}
