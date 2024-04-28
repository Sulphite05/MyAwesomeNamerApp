import "package:firebase_auth/firebase_auth.dart" show User;
import "package:flutter/material.dart";

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  const AuthUser({this.email, required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      ); // factory method and fromFirebase need a user as arg to return emailVerified
}

// @immutable
// class AuthUser {
//   final bool isEmailVerified;
//   const AuthUser(this.isEmailVerified);
//   factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);  // factory method and fromFirebase need a user as arg to return emailVerified

// void testing() {
//   AuthUser(true); // this instance does not make any sense... What's true, what does it mean?
// }

// to fix this dart gives us required names parameters like this:
// void testing() {
//   AuthUser(isEmailVerified: true); // but syntax error may arise for commented class, 
//since named parameter require to be enclosed in curly braces with a required type
// }

// }

