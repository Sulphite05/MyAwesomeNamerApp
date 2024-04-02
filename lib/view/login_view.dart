import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/main.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TO DO: implement initState
    _email = TextEditingController(); // must initialise final vars
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TO DO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: " Enter your email here..."),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: " Enter your password here..."),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute,
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e.code);
                            if (e.code == 'user-not-found') {
                              // ignore: use_build_context_synchronously
                              await showErrorDialog(context, 'User not found');
                            } else if (e.code == 'wrong-password') {
                              // ignore: use_build_context_synchronously
                              await showErrorDialog(
                                  context, 'Email or Password is incorrect!');
                            } else {
                              // ignore: use_build_context_synchronously
                              await showErrorDialog(
                                  context, 'Error: ${e.code}');
                            }
                          }
                        },
                        child: const Text('Login')),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute, // push this route
                            (route) =>
                                false // means keep removing without caring about the route since not required anymore prev path
                            );
                      },
                      child: const Text('Not registered yet? Register here!'),
                    ),
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          )),
    );
  }
}
