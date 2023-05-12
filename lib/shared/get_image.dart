import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetimageFromFirestore extends StatefulWidget {
  

  const GetimageFromFirestore({Key? key,})
      : super(key: key);

  @override
  State<GetimageFromFirestore> createState() => _GetimageFromFirestoreState();
}

class _GetimageFromFirestoreState extends State<GetimageFromFirestore> {
  final dialogUsernameController = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return  CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 64,
            foregroundImage: NetworkImage(data["imglink"]),
          );
        }

        return const Text("loading");
      },
    );
  }
}
