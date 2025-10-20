import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/category_model.dart';

class CategoryApiService {
  Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse(ApiConfig.categoriesEndpoint);
    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // متوقع Array من التصنيفات
      final list =
          (data as List).map((e) => CategoryModel.fromJson(e)).toList();
      return list;
    } else {
      final msg = res.body.isNotEmpty ? res.body : 'Failed to load categories';
      throw Exception('❌ $msg');
    }
  }
}
