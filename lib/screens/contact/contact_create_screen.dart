import 'package:flutter/material.dart';
import 'package:contact_book/models/user.dart';
import 'package:contact_book/models/contact.dart';
import 'package:contact_book/services/contact_service.dart';

class ContactCreateScreen extends StatefulWidget {
  final User user;

  const ContactCreateScreen({super.key, required this.user});

  @override
  _ContactCreateScreenState createState() => _ContactCreateScreenState();
}

class _ContactCreateScreenState extends State<ContactCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _socialAccountsController = TextEditingController();
  final ContactService _contactService = ContactService();

  void _createContact() async {
    if (_formKey.currentState!.validate()) {
      Contact newContact = Contact(
        userId: widget.user.id!,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        socialAccounts: _socialAccountsController.text,
      );

      await _contactService.addContact(newContact);
      Navigator.pop(context, true);
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _socialAccountsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Contact'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNotEmpty,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNotEmpty,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNotEmpty,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _socialAccountsController,
                    decoration: const InputDecoration(
                      labelText: 'Social Accounts / Messengers',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _createContact,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
