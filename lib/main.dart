
import 'package:e_commerce_app/pages/login.dart';

import 'package:e_commerce_app/pages/verify_email_page.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/providers/google_signin.dart';
import 'package:e_commerce_app/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(
        create: (context) {
          return CartProvider();
        }),
        ChangeNotifierProvider(
        create: (context) {
          return GoogleSignInProvider();
        }),
        ],
        child:  MaterialApp(
          title: "myApp",
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
     if (snapshot.connectionState == ConnectionState.waiting) {return const Center(child: CircularProgressIndicator(color: Colors.white,));} 
        else if (snapshot.hasError) {return showSnackBar(context, "Something went wrong");}
        else if (snapshot.hasData) {return const VerifyEmailPage();}
        else { return const Login();}
          }),
        ),
      
    );
  }
}
