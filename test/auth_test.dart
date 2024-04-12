import 'dart:math';

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', (){
    final provider = MockAuthProvider();
    test('Should not be initialised at the time of instantiation', (){
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialised', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitialisedException>()));
    });

    test('Should be able to be initialised', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialistaion', () {
      expect(provider.currentUser, null);
    });

    // test('Should be able to initialise in less than two seconds', () {
      
    // })
  });
}

class NotInitialisedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user = null;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitialisedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
        email: email, password: password); // if registered, send to login
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitialisedException();
    if (email == 'aqiba@gmail.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw InvalidCredentialsAuthException();
    const user = AuthUser(isEmailVerified: true);
    _user = user;
    return Future.value(user); //return user's value after delay
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitialisedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitialisedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
