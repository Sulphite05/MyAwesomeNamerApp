import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(   
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
   
   @override
   Widget build(BuildContext context) {
    return FutureBuilder(
        
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
          
          switch (snapshot.connectionState){

            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              user?.reload();
              if(user?.emailVerified ?? false){
                return const Text('Done');
              }
              else{
                return const VerifyEmailView();
              }

            default:
              return const CircularProgressIndicator();
          }   
        },
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,)     
      );
   }
}


// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
   
//    @override
//    Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue,
//       ),
//       body: FutureBuilder(
        
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
          
//           switch (snapshot.connectionState){

//             case ConnectionState.done:
//               final user = FirebaseAuth.instance.currentUser;
//               user?.reload();
//               if(user?.emailVerified ?? false){
//                 print('You are a Verified User.');
//               }
//               else{
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => const VerifyEmailView())
//                 ); 

//               }
//               return Text('Done');

//             default:
//               return const Text("Loading...");
//           }   
//         },
//         future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,)     
//       ),
//     );
//   }
// }

// class VerifyEmailView extends StatefulWidget {
//   const VerifyEmailView({super.key});

//   @override
//   State<VerifyEmailView> createState() => _VerifyEmailViewState();
// }

// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Verify Email"), 
//       foregroundColor: Colors.white,
//       backgroundColor: Colors.blue,),
//       body: Column(children: [
//         const Text("Please verify your email address"),
//         TextButton(onPressed: () async {
//           final user = FirebaseAuth.instance.currentUser;
//           await user?.sendEmailVerification();
//         },
//         child:  const Text("Send Email Verification"),)
//       ]),
    
//     );
//   }
// }