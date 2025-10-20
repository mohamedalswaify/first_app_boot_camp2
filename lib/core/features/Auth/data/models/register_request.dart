class RegisterRequest {
  final String firstName;
  final String lastName;
  final String gender; // "male" or "female"
  final DateTime birthDate;
  final String email;
  final String password;
  final String confirmPassword;
  final String country;
  final String phone;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.country,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'birthDate': birthDate.toIso8601String(),
        'email': email,
        'password': password,
        // 'confirmPassword': confirmPassword,
        'country': country,
        'phone': phone,
      };
}
