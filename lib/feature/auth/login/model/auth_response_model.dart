import 'dart:convert';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  final bool success;
  final int statusCode;
  final String message;
  final UserData? data;

  AuthResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    success: json["success"] ?? false,
    statusCode: json["statusCode"] ?? 0,
    message: json["message"] ?? '',
    data: json["data"] != null ? UserData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class UserData {
  final User user;
  final String accessToken;
  final String? message;

  UserData({required this.user, required this.accessToken, this.message});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: User.fromJson(json["user"] ?? {}),
    accessToken: json["accessToken"] ?? '',
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "accessToken": accessToken,
    "message": message,
  };
}

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isDeleted;
  final String? phone;
  final bool isAccountVerified;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isDeleted,
    this.phone,
    required this.isAccountVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? '',
    email: json["email"] ?? '',
    firstName: json["firstName"] ?? '',
    lastName: json["lastName"] ?? '',
    role: json["role"] ?? '',
    isDeleted: json["isDeleted"] ?? false,
    phone: json["phone"],
    isAccountVerified: json["isAccountVerified"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "role": role,
    "isDeleted": isDeleted,
    "phone": phone,
    "isAccountVerified": isAccountVerified,
  };
}
