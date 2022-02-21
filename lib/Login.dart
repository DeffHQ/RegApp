import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'fire_store_page.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  String validValue = 'Ok';

  String? userUid;

  late final userEmail;

  @override

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
        onPressed: () {},
    icon: const Icon(
    Icons.arrow_back,
    color: Colors.black,
    size: 30,
    ),
      )),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              controller: emailController,
              validator: (value) {
                if (value!.contains('@') && value.contains('.com')) {
                  return null;
                }
                return 'invalid email';
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'password'),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'invalid password';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  final message = await signIn();
                  if (!formKey.currentState!.validate()) {
                    if (validValue == 'Ok') {}
                  }
                  else {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => FirestorePage(serEmail),
                    // ));
                  }
                },
                child: Text('Login'))
          ],
        ),
      ),
    );
  }
Future<String> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print(userCredential.user!.uid);
      userUid = userCredential.user!.uid;
      userEmail = userCredential.user!.email;
      return 'Ok';
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorMessage = 'Wrong password provided for that user.';
      }
      return errorMessage;
    }
  }
  Future<String> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      return 'Ok';
    } on FirebaseAuthException catch (e) {
      print(e);
      var errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'email-already-in-use') {
        print('email is already exist.');
        errorMessage = 'email is already exist.';
      }
      return errorMessage;
    }
  }
}


