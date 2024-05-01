// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientData {
  String? id;
  String? userId;
  String? name;
  String? profilePic;
  String? email;
  String? password;
  String? phoneNumber;
  bool? isOnline;
  ClientData({
    this.id,
    this.userId,
    this.name,
    this.profilePic,
    this.email,
    this.password,
    this.phoneNumber,
    this.isOnline = false,
  });

  ClientData copyWith({
    String? id,
    String? userId,
    String? name,
    String? profilePic,
    String? email,
    String? password,
    String? phoneNumber,
    bool? isOnline,
  }) {
    return ClientData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'profilePic': profilePic,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
    };
  }

  factory ClientData.fromMap(Map<String, dynamic> map) {
    return ClientData(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientData.fromJson(String source) =>
      ClientData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientData(id: $id, userId: $userId, name: $name, profilePic: $profilePic, email: $email, password: $password, phoneNumber: $phoneNumber, isOnline: $isOnline)';
  }

  @override
  bool operator ==(covariant ClientData other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.name == name &&
      other.profilePic == profilePic &&
      other.email == email &&
      other.password == password &&
      other.phoneNumber == phoneNumber &&
      other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      profilePic.hashCode ^
      email.hashCode ^
      password.hashCode ^
      phoneNumber.hashCode ^
      isOnline.hashCode;
  }
}
