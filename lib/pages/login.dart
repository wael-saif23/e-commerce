// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:e_commerce_app/pages/forgot_passowrd.dart';
import 'package:e_commerce_app/pages/register.dart';
import 'package:e_commerce_app/pages/verify_email_page.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/contants.dart';
import 'package:e_commerce_app/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isVisibility = true;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  signIN() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR : ${e.code}");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose()async {
     
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("SIGN IN"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: appbarGreen,
        ),
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Email : ",
                        suffixIcon: Icon(Icons.email),
                      )),
                  const SizedBox(
                    height: 33,
                  ),
                  TextField(
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
                      )),
                  const SizedBox(
                    height: 33,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signIN();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(BTNgreen),
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : Text(
                            "Sign in",
                            style: TextStyle(fontSize: 19),
                          ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text("Forgot password?",
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
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
                                  builder: (context) => Register()),
                            );
                          },
                          child: Text('sign up',
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
