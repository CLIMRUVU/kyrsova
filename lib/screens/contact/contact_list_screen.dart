import 'package:flutter/material.dart';
import 'package:contact_book/models/user.dart';
import 'package:contact_book/models/contact.dart';
import 'package:contact_book/services/contact_service.dart';
import 'contact_detail_screen.dart';
import 'contact_create_screen.dart';
import '../profile/profile_screen.dart';

class ContactListScreen extends StatefulWidget {
  final User user;

  const ContactListScreen({super.key, required this.user});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    List<Contact> contacts = await _contactService.getContacts(widget.user.id!);
    setState(() {
      _contacts = contacts;
    });
  }

  void _searchContacts(String query) async {
    List<Contact> contacts = await _contactService.searchContacts(widget.user.id!, query);
    setState(() {
      _contacts = contacts;
      _searchQuery = query;
    });
  }

  void _navigateToCreateContact() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactCreateScreen(user: widget.user),
      ),
    );

    if (result == true) {
      _loadContacts();
    }
  }

  void _navigateToContactDetail(Contact contact) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(user: widget.user, contact: contact),
      ),
    );

    if (result == true) {
      _loadContacts();
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts of ${widget.user.name}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: _navigateToProfile,
              tooltip: 'Profile',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _searchContacts,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return ListTile(
                    title: Text('${contact.firstName} ${contact.lastName}'),
                    subtitle: Text(contact.phoneNumber),
                    onTap: () => _navigateToContactDetail(contact),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreateContact,
          child: const Icon(Icons.add),
        ));
  }
}
