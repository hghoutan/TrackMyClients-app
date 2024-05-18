import 'dart:convert';

abstract class User {
  String? id;
  String? email;
  String? phoneNumber;
  bool? isOnline;
  String? role;

  User({
    this.id,
    this.email,
    this.phoneNumber,
    this.isOnline,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'role': role,
    };
  }


  String toJson() => json.encode(toMap());


  @override
  String toString() {
    return 'User(id: $id, email: $email, phoneNumber: $phoneNumber, isOnline: $isOnline, role: $role)';
  }
}