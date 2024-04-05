// login exceptions

class UserNotFoundAuthException implements Exception {}

class InvalidCredentialsAuthException implements Exception {}


// Register exceptions

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}


// login exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
