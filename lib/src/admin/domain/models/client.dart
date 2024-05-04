// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientData {
  String? id;
  String? userId;
  String? name;
  String? profilePic;
  String? email;
  String? phoneNumber;
  bool? isOnline;
  String? role;
  ClientData({
    this.id,
    this.userId,
    this.name,
    this.profilePic,
    this.email,
    this.phoneNumber,
    this.isOnline = false,
    this.role = 'client',
  });

  ClientData copyWith({
    String? id,
    String? userId,
    String? name,
    String? profilePic,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    String? role,
  }) {
    return ClientData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        isOnline: isOnline ?? this.isOnline,
        role: role ?? this.role);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'profilePic': profilePic,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'role': role
    };
  }

  factory ClientData.fromMap(Map<String, dynamic> map) {
    return ClientData(
        id: map['id'] != null ? map['id'] as String : null,
        userId: map['userId'] != null ? map['userId'] as String : null,
        name: map['name'] != null ? map['name'] as String : null,
        profilePic:
            map['profilePic'] != null ? map['profilePic'] as String : null,
        email: map['email'] != null ? map['email'] as String : null,
        phoneNumber:
            map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
        isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
        role: map['role'] != null ? map['role'] as String : null);
  }

  String toJson() => json.encode(toMap());

  factory ClientData.fromJson(String source) =>
      ClientData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientData(id: $id, userId: $userId, name: $name, profilePic: $profilePic, email: $email, phoneNumber: $phoneNumber, isOnline: $isOnline, role: $role)';
  }

  @override
  bool operator ==(covariant ClientData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.isOnline == isOnline &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        isOnline.hashCode ^
        role.hashCode;
  }
}
