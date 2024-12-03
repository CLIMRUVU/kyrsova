import 'package:flutter/material.dart';
import 'package:contact_book/models/user.dart';
import 'package:contact_book/models/contact.dart';
import 'package:contact_book/services/contact_service.dart';
import 'contact_edit_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final User user;
  final Contact contact;

  const ContactDetailScreen({super.key, required this.user, required this.contact});

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final ContactService _contactService = ContactService();

  void _deleteContact() async {
    await _contactService.deleteContact(widget.contact.id!);
    Navigator.pop(context, true);
  }

  void _navigateToEditContact() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactEditScreen(user: widget.user, contact: widget.contact),
      ),
    );

    if (result == true) {
      setState(() {
        // Оновлення деталей контакту після редагування
      });
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.contact.firstName} ${widget.contact.lastName}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToEditContact,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('Delete Contact'),
                      content: const Text('Are you sure you want to delete this contact?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _deleteContact();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name: ${widget.contact.firstName}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8.0),
              Text('Last Name: ${widget.contact.lastName}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8.0),
              Text('Phone Number: ${widget.contact.phoneNumber}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8.0),
              Text('Email: ${widget.contact.email}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8.0),
              Text('Social Accounts/Messengers: ${widget.contact.socialAccounts}', style: const TextStyle(fontSize: 18)),
            ],
          ),
        ));
  }
}
