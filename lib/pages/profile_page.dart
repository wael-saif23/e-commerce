import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/shared/colors.dart';
import 'package:e_commerce_app/shared/data_from_firestore.dart';
import 'package:e_commerce_app/shared/get_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;

import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final credential = FirebaseAuth.instance.currentUser;
  File? imgPath;
  String? imgName;
  ImageSource? galleryOrCamera;
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Stack(
                    children: [
                      imgPath == null
                          ? const GetimageFromFirestore()
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        bottom: -13,
                        right: -13,
                        child: IconButton(
                          onPressed: () {
                            showModal(context);
                            // uploadImageToScreen();
                          },
                          icon: const Icon(Icons.edit, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Info from firebase Auth",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Email: ${credential!.email}    ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Created date:  ${DateFormat("MMMM d, y").format(credential!.metadata.creationTime!)}    ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Last Signed In: ${DateFormat("MMMM d, y").format(credential!.metadata.lastSignInTime!)} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Center(
                  child: TextButton(
                      onPressed: () {
                        credential!.delete();
                        users.doc(credential!.uid).delete();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false);
                      },
                      child: const Text("Delet User"))),
              const SizedBox(
                height: 16,
              ),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 177, 255),
                          borderRadius: BorderRadius.circular(11)),
                      child: const Text(
                        "Info from firebase firestore",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
              GetDataFromFirestore(documentId: credential!.uid),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showModal(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(.8),
        shape: const RoundedRectangleBorder(
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
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              await uploadImageToScreen(ImageSource.gallery);
                              if(imgName !=null){
                                final storageRef =
                                  FirebaseStorage.instance.ref(imgName);
                              await storageRef.putFile(imgPath!);
                              String url = await storageRef.getDownloadURL();
                              users.doc(credential!.uid).update({"imglink": url,});
                              }
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
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              await uploadImageToScreen(ImageSource.camera);
                              if(imgName !=null){
                                final storageRef =
                                  FirebaseStorage.instance.ref(imgName);
                              await storageRef.putFile(imgPath!);
                              String url = await storageRef.getDownloadURL();
                              users.doc(credential!.uid).update({"imglink": url,});
                              }
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
