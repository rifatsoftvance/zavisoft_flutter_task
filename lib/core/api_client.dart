import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zavisoft_flutter_task/feature/home/data/model/product_model.dart';

class ApiClient {
  static const baseUrl = "https://fakestoreapi.com";

  Future<List<ProductModel>> fetchProducts() async {
    final res = await http.get(Uri.parse("$baseUrl/products"));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<Map<String, dynamic>> login(
      String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> fetchUser(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/users/$id"));
    return json.decode(res.body);
  }
}