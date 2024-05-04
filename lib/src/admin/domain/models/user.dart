// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  String? id;
  String? firstName;
  String? lastName;
  String? birthdayYear;
  String? gender;
  String? city;
  String? email;
  String? phone;
  bool? isOnline;
  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.birthdayYear,
    this.gender,
    this.city,
    this.email,
    this.phone,
    this.isOnline,
  });

  UserData copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? birthdayYear,
    String? gender,
    String? city,
    String? email,
    String? phone,
    bool? isOnline,
  }) {
    return UserData(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdayYear: birthdayYear ?? this.birthdayYear,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthdayYear': birthdayYear,
      'gender': gender,
      'city': city,
      'email': email,
      'phone': phone,
      'isOnline': isOnline,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] != null ? map['id'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      birthdayYear: map['birthdayYear'] != null ? map['birthdayYear'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  bool isValid() {
    return [id, firstName, lastName, birthdayYear, gender, city, email, phone]
        .every((element) => element != null && element.isNotEmpty);
  }

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserData(id: $id, firstName: $firstName, lastName: $lastName, birthdayYear: $birthdayYear, gender: $gender, city: $city, email: $email, phone: $phone, isOnline: $isOnline)';
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.birthdayYear == birthdayYear &&
      other.gender == gender &&
      other.city == city &&
      other.email == email &&
      other.phone == phone &&
      other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      birthdayYear.hashCode ^
      gender.hashCode ^
      city.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      isOnline.hashCode;
  }
}
