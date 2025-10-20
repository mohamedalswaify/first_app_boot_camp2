class RegisterResponse {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String token; // لو بيرجع توكن بعد التسجيل

  RegisterResponse({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
