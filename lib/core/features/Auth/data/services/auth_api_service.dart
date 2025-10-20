import 'dart:convert';

import 'package:first_app_boot_camp2/core/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';

class AuthApiService {
  // غيّرها لو عندك Base URL ثابت
  static const String _login = ApiConfig.loginEndpoint;
  //  'https://pk122j13-7109.euw.devtunnels.ms';
//login
  Future<LoginResponse> login(LoginRequest req) async {
    final uri = Uri.parse('$_login').replace(
      queryParameters: {
        'email': req.email,
        'password': req.password,
      },
    );

    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(map);
    } else {
      // رجّع رسالة السيرفر لو فيه
      final body = res.body.isNotEmpty ? res.body : 'Login failed';
      throw Exception(body);
    }
  }

  //register
  // ⬇️ جديد: التسجيل
  Future<RegisterResponse> register(RegisterRequest req) async {
    final uri = Uri.parse(ApiConfig.registerEndpoint);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return RegisterResponse.fromJson(data);
    } else {
      final msg = res.body.isNotEmpty ? res.body : 'Register failed';
      throw Exception('❌ $msg');
    }
  }
}
