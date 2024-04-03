import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';
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
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                user.reload();
                if (user.emailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ));
  }
}

enum MenuAction { logout, misc }

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
          PopupMenuButton(onSelected: (value) async {
            // value is a an enumeration value, whatever I select from the enums values
            devtools.log(value.toString());

            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                }
                break;
              case MenuAction.misc:
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout, // coder sees this
                child: Text("Log Out"), // user sees this
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.misc, // coder sees this
                child: Text("Misc"), // user sees this
              )
            ]; // since popmenuentry requires a list return type
          })
        ],
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sign Out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // to return a value to the show dialogue
                    },
                    child: const Text('Sign Out')),
              ],
            );
          })
      .then((value) =>
          value ??
          false); // show dialogue's value can be null, for instance, i press somewhere else on the screen instead of the pop up
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

