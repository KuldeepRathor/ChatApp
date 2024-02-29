import 'package:chatapp/home/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    signinwithGoogle();
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/google.svg',
                  ),
                ),
                // SizedBox(
                //   width: Get.width * 0.1,
                // ),
                // InkWell(
                //   onTap: () async {
                //     try {
                //       // final UserCredential userCredential =
                //       signinwithFacebook();
                //       // if (context.mounted) {
                //       //   Get.to(() => Btnavbar());
                //       // }
                //     } catch (e) {
                //       debugPrint(e.toString());
                //     }
                //   },
                //   child: SvgPicture.asset('assets/svgs/facebook.svg'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> signinwithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  debugPrint(
    userCredential.user?.displayName.toString(),
  );

  if (userCredential.user != null) {
    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'name': userCredential.user?.displayName,
      'email': userCredential.user?.email,
      'profilePic': userCredential.user?.photoURL,
      'uid': userCredential.user?.uid,
      'status': "Online",
    });

    Get.to(() => HomeScreen());
  } else {
    Get.snackbar("Error", "Something went wrong");
  }
  return userCredential;
}

// Future<UserCredential> signinwithFacebook() async {
//   final LoginResult loginResult = await FacebookAuth.instance.login();
//   final OAuthCredential facebookAuthCredential =
//       FacebookAuthProvider.credential(loginResult.accessToken!.token);
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }
