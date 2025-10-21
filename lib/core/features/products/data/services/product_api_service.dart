import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/product_model.dart';

class ProductApiService {
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse(ApiConfig.productsEndpoint);
    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      // لو الAPI بترجع {data:[...]}
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }
      throw Exception('Unexpected response shape');
    } else {
      final msg = res.body.isNotEmpty ? res.body : 'Failed to load products';
      throw Exception('❌ $msg');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    final uri = Uri.parse('${ApiConfig.productByIdEndpoint}/$id');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return ProductModel.fromJson(data);
    } else {
      final msg = res.body.isNotEmpty ? res.body : 'Failed to load product';
      throw Exception('❌ $msg');
    }
  }
}
