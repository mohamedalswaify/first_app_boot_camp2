import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthApiService {
  Future<LoginResponse> login(LoginRequest req) async {
    final uri = Uri.parse(ApiConfig.loginEndpoint);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      'email': req.email,
      'password': req.password,
    });

    final res = await http.post(uri, headers: headers, body: body);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return LoginResponse.fromJson(data);
    } else {
      // إرجاع الخطأ القادم من السيرفر
      final msg = res.body.isNotEmpty ? res.body : 'Login failed';
      throw Exception('❌ $msg');
    }
  }
}
