// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:etech_store_admin/module/auth/views/home_sign_in.dart';
// import 'package:etech_store_admin/module/auth/views/sign_in_screen.dart';
// import 'package:etech_store_admin/services/auth_services.dart';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     AuthServices auth = Get.put(AuthServices());
//     User? user = FirebaseAuth.instance.currentUser;
//
//     return MaterialApp(
//       home: Scaffold(
//         body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return const HomeSignIn();
//             } else {
//               return Scaffold(
//                 appBar: AppBar(
//                   title: const Text("Home"),
//                 ),
//                 body: Center(
//                     child: Column(
//                   children: [
//                     const Text("Hello"),
//                     ElevatedButton(
//                         onPressed: () {
//                           auth.signOut();
//                         },
//                         child: const Text("data"))
//                   ],
//                 )),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
