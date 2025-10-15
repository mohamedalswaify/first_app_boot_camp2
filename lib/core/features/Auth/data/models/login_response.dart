class LoginResponse {
  final String firstName;

  LoginResponse({required this.firstName});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      firstName: json['firstName']?.toString() ?? '',
    );
  }
}
