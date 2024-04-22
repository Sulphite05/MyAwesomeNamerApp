import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationCacheDirectory;
import 'package:path/path.dart' show join;

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.from_row(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn]
            as String; // when we read our database, we read hash tables for each row of the user

  @override
  String toString() => 'Person, id = $id, email = $email';
}

const idColumn = 'id';
const emailColumn = 'email';
