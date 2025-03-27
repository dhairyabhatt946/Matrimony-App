import 'package:matrimonial_app/constants/string_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MatrimonyDatabase {
  int DB_VERSION = 1;
  static late Database db;

  Future<Database> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'Matrimony.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $USERS ($USER_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          '$NAME TEXT NOT NULL, '
          '$PASSWORD TEXT NOT NULL, '
          '$ADDRESS TEXT NOT NULL, '
          '$EMAIL TEXT NOT NULL, '
          '$PHONE TEXT NOT NULL, '
          '$DOB TEXT NOT NULL, '
          '$AGE INTEGER NOT NULL, '
          '$CITY TEXT NOT NULL, '
          '$GENDER TEXT NOT NULL, '
          '$FAVOURITE INTEGER NOT NULL, '
          '$HOBBIES TEXT NOT NULL);',
        );
      },
      version: DB_VERSION,
    );
    print('DB initialized');
    return db;
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> users = await db.query(USERS);
    return users;
  }

  Future<List<Map<String, dynamic>>> fetchFavouriteUsers() async {
    List<Map<String, dynamic>> favouriteUsers = await db.rawQuery("SELECT * FROM $USERS WHERE $FAVOURITE = ?", [1]);
    return favouriteUsers;
  }

  Future<void> addUser(userMap) async {
    await db.insert(USERS, userMap);
  }

  Future<int?> getId(String email) async {
    final result = await db.rawQuery(
        "SELECT $USER_ID FROM $USERS WHERE $EMAIL = ?", [email]);

    return result.isNotEmpty ? result.first[USER_ID] as int : null;
  }


  Future<void> updateUser(id, userMap) async {
    await db.update(USERS,
      userMap,
      where: '$USER_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> setFavourite(id, fav) async {
    if(fav) {
      await db.rawUpdate('UPDATE $USERS SET $FAVOURITE = ? WHERE $USER_ID = ?', [1, id]);
    }
    else {
      await db.rawUpdate('UPDATE $USERS SET $FAVOURITE = ? WHERE $USER_ID = ?', [0, id]);
    }
  }

  Future<void> deleteUser(id) async {
    await db.delete(USERS,
      where: '$USER_ID = ?',
      whereArgs: [id],
    );
  }
}