import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> _postRequest(String endpoint, Map<String, String> headers, dynamic body) async {
    while (true) {
      try {
        // Make the HTTP POST request
        final response = await http
            .post(Uri.parse('$baseUrl$endpoint'), headers: headers, body: body, encoding: Encoding.getByName("utf-8"))
            .timeout(Duration(seconds: 10), onTimeout: () {
          throw TimeoutException("The connection has timed out, Please try again!");
        });

        // Check for successful response
        if (response.statusCode == 200) {
          return response;
        } else {
          throw Exception('Failed to load data');
        }
      } on TimeoutException catch (_) {
        print('Connection timed out. Please check your internet connection.');
        alert("Please check your internet connection.");
      } on Exception catch (e) {
        print('Failed to load data: $e');
        throw Exception('Failed to load data: $e');
      }
    }
  }

  Future<http.Response> postFormData(String endpoint, Map<String, String> headers, Map<String, String> body) async {
    return _postRequest(endpoint, headers, body);
  }

  Future<http.Response> postJsonData(String endpoint, Map<String, String> headers, Map<String, dynamic> body) async {
    return _postRequest(endpoint, headers, json.encode(body));
  }

  Future<http.Response> postData(String endpoint, Map<String, String> headers, Map body) async {
    return _postRequest(endpoint, headers, body);
  }

  Future<http.Response> _getOutRequest(String endpoint, Map<String, String> headers,) async {
    while (true) {
      try {
        // Make the HTTP POST request
        final response = await http
            .get(Uri.parse('$baseUrl$endpoint'), headers: headers,)
            .timeout(Duration(seconds: 10), onTimeout: () {
          throw TimeoutException("The connection has timed out, Please try again!");
        });

        // Check for successful response
        if (response.statusCode == 200) {
          return response;
        } else {
          throw Exception('Failed to load data');
        }
      } on TimeoutException catch (_) {
        print('Connection timed out. Please check your internet connection.');
        alert("Please check your internet connection.");
      } on Exception catch (e) {
        print('Failed to load data: $e');
        throw Exception('Failed to load data: $e');
      }
    }
  }

  Future<http.Response> getOutJsonData(String url, Map<String, String> headers,) async {
    return _getOutRequest(url, headers,);
  }

  Future<http.StreamedResponse> postMultipartData(
      String endpoint, Map<String, String> headers, Map<String, String> fields, List<http.MultipartFile> files) async {
    while (true) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'))
          ..fields.addAll(fields)
          ..headers.addAll(headers)
          ..files.addAll(files);

        var response = await request.send().timeout(Duration(seconds: 10), onTimeout: () {
          throw TimeoutException("The connection has timed out, Please try again!");
        });

        if (response.statusCode == 200) {
          return response;
        } else {
          throw Exception('Failed to upload data');
        }
      } on TimeoutException catch (_) {
        print('Connection timed out. Please check your internet connection.');
        alert("Please check your internet connection.");
      } on Exception catch (e) {
        print('Failed to upload data: $e');
        throw Exception('Failed to upload data: $e');
      }
    }
  }

  alert(error) {
    return Get.snackbar(
      'Sorry!!',
      error,
      colorText: Colors.white,
      backgroundColor: Colors.black54,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
    );
  }
}
