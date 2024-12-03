import 'package:flutter/material.dart';
import 'package:contact_book/models/user.dart';
import 'package:contact_book/services/auth_service.dart';
import '../auth/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  bool _isDeleting = false;

  @override
  void dispose() {
    super.dispose();
  }

  // Метод для видалення акаунту
  void _deleteAccount() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Видалення акаунту'),
          content: const Text('Ви впевнені, що хочете видалити свій акаунт? Ця дія не може бути скасована.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Видалити',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm) {
      setState(() {
        _isDeleting = true;
      });

      try {
        await _authService.deleteUser(widget.user.id!);
        setState(() {
          _isDeleting = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      } catch (e) {
        setState(() {
          _isDeleting = false;
        });
        _showErrorDialog('Не вдалося видалити акаунт: $e');
      }
    }
  }

  // Метод для виходу з акаунту
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }

  // Метод для показу діалогу помилки
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Помилка'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Профіль'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Вийти',
            ),
          ],
        ),
        body: _isDeleting
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Ім'я користувача
              ListTile(
                title: const Text('Ім\'я'),
                subtitle: Text(widget.user.name),
              ),
              const Divider(),
              // Електронна пошта користувача
              ListTile(
                title: const Text('Електронна пошта'),
                subtitle: Text(widget.user.email),
              ),
              const Divider(),
              const SizedBox(height: 20),
              // Кнопка видалення акаунту
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Замість 'primary' у нових версіях Flutter
                  minimumSize: const Size.fromHeight(50), // Робить кнопку ширшою
                ),
                child: const Text(
                  'Видалити акаунт',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
