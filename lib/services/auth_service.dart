// lib/services/auth_service.dart

import 'package:contact_book/models/user.dart';
import 'package:contact_book/database/database_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Реєстрація нового користувача
  Future<int> registerUser(User user) async {
    // Хешуємо пароль перед збереженням
    user.password = User.hashPassword(user.password);
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  // Авторизація користувача
  Future<User?> loginUser(String email, String password) async {
    final db = await _dbHelper.database;
    final hashedPassword = User.hashPassword(password);
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Перевірка, чи електронна пошта вже використовується
  Future<bool> isEmailTaken(String email) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  // Видалення користувача
  Future<int> deleteUser(int userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
