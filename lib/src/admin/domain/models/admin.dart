import 'dart:convert';

import 'user.dart';

class Admin extends User {
  String? firstName;
  String? lastName;
  String? birthdayYear;
  String? gender;
  String? city;

  Admin({
    String? id,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? role,
    this.firstName,
    this.lastName,
    this.birthdayYear,
    this.gender,
    this.city,
  }) : super(
          id: id,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: isOnline,
          role: role,
        );

  Admin copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? role,
    String? firstName,
    String? lastName,
    String? birthdayYear,
    String? gender,
    String? city,
  }) {
    return Admin(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdayYear: birthdayYear ?? this.birthdayYear,
      gender: gender ?? this.gender,
      city: city ?? this.city,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'birthdayYear': birthdayYear,
      'gender': gender,
      'city': city,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber: map['phone'] != null ? map['phone'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      role: map['role'] != null ? map['role'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      birthdayYear:
          map['birthdayYear'] != null ? map['birthdayYear'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
    );
}
  bool isValid() { return [id, firstName, lastName, birthdayYear, gender, city, email, phoneNumber] .every((element) => element != null && element.isNotEmpty); }

  @override
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin(id: $id, email: $email, phoneNumber: $phoneNumber, isOnline: $isOnline, role: $role, firstName: $firstName, lastName: $lastName, birthdayYear: $birthdayYear, gender: $gender, city: $city)';
  }

  
}