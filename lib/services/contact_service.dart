import 'package:contact_book/models/contact.dart';
import 'package:contact_book/database/database_helper.dart';

class ContactService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Додавання нового контакту
  Future<int> addContact(Contact contact) async {
    final db = await _dbHelper.database;
    return await db.insert('contacts', contact.toMap());
  }

  // Отримання всіх контактів користувача
  Future<List<Contact>> getContacts(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  // Оновлення контакту
  Future<int> updateContact(Contact contact) async {
    final db = await _dbHelper.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Видалення контакту
  Future<int> deleteContact(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Пошук контактів за різними полями
  Future<List<Contact>> searchContacts(int userId, String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: '''
        userId = ? AND (
          firstName LIKE ? OR
          lastName LIKE ? OR
          phoneNumber LIKE ? OR
          email LIKE ?
        )
      ''',
      whereArgs: [
        userId,
        '%$query%',
        '%$query%',
        '%$query%',
        '%$query%',
      ],
    );

    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }
}
