import 'dart:convert';

import 'package:first_app_boot_camp2/core/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthApiService {
  // غيّرها لو عندك Base URL ثابت
  static const String _base = ApiConfig.loginEndpoint;
  //  'https://pk122j13-7109.euw.devtunnels.ms';

  Future<LoginResponse> login(LoginRequest req) async {
    final uri = Uri.parse('$_base').replace(
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
}
