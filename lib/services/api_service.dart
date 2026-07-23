import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/user.dart';
import '../utils/exceptions.dart';

class ApiService {
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load posts');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    }
  }

  Future<User> fetchUser(int id) async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Failed to load user');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    }
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load users');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    }
  }
}
