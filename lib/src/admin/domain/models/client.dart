import 'dart:convert';

import 'user.dart';

class Client extends User {
  String? name;
  String? profilePic;
  String? userId;

  Client({
    String? id,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? role = "client",
    this.name,
    this.profilePic,
    this.userId,
  }) : super(
          id: id,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: isOnline,
          role: role,
        );

  Client copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? role,
    String? name,
    String? profilePic,
    String? userId,
  }) {
    return Client(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      role: role ?? this.role,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
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
      'name': name,
      'profilePic': profilePic,
      'userId': userId,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      role: map['role'] != null ? map['role'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

 factory Client.fromJson(String source) =>
      Client.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Client(id: $id, email: $email, phoneNumber: $phoneNumber, isOnline: $isOnline, role: $role, name: $name, profilePic: $profilePic, userId: $userId)';
  }

  @override
  bool operator ==(covariant Client other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.isOnline == isOnline &&
        other.role == role &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        isOnline.hashCode ^
        role.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        userId.hashCode;
  }
}