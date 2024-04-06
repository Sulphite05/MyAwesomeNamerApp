import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
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
                          await AuthService.firebase()
                              .createUser(email: email, password: password);
                          await AuthService.firebase().sendEmailVerification();

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on InvalidEmailAuthException {
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(context, 'Invalid Email');
                        } on WeakPasswordAuthException {
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(
                              context, 'Enter a strong password');
                        } on EmailAlreadyInUseAuthException {
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(
                              context, 'Email already in use');
                        } on UserNotLoggedInAuthException catch (e) {
                          devtools.log('Error $e occured!');
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(context,
                              'An error ocurred while registering the user.\nPlease try again later.');
                        } on GenericAuthException catch (e) {
                          devtools.log('Error $e occured!');
                          // ignore: use_build_context_synchronously
                          await showErrorDialog(context, 'Failed to register');
                        }
                      },
                      child: const Text('Register')),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    },
                    child: const Text('Already registered? Login here!'),
                  )
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
