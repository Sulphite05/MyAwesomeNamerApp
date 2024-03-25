import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  devtools.log('message');
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

              if (user != null){
                user.reload();
                if(user.emailVerified){
                  return const NotesView();

                }

              else{
                return const VerifyEmailView();
              }
              }
              else{
                return const LoginView();
              }
              

            default:
              return const CircularProgressIndicator();
          }   
        },
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,)     
      );
   }
}


enum MenuAction {logout}
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton( 
            onSelected: (value){
              devtools.log(value.toString());
            }, 
            itemBuilder: (context){
              return [const PopupMenuItem<MenuAction>(
              value: MenuAction.logout,  // coder sees this
              child: Text("Log Out"), // user sees this
              )]; // since popmenuentry requires a list return type
          })
          ],
      ),

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