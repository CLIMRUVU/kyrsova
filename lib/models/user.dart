import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final int? id;
  String name;
  String email;
  String password; // Збережений як хеш

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Генерація хешу пароля
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Перетворення об'єкта User у Map для зберігання в базі даних
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password, // Зберігаємо хеш
    };
  }

  // Створення об'єкта User з Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'], // Хеш
    );
  }
}
