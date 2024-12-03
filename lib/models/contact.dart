class Contact {
  final int? id;
  final int userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String socialAccounts;

  Contact({
    this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.socialAccounts,
  });

  // Перетворення об'єкта Contact у Map для зберігання в базі даних
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'socialAccounts': socialAccounts,
    };
  }

  // Створення об'єкта Contact з Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      userId: map['userId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      socialAccounts: map['socialAccounts'],
    );
  }
}
