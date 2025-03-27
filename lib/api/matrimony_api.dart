import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../constants/string_constants.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class MatrimonyApi {
  static String baseUrl = 'https://67c5db45351c081993fbb296.mockapi.io/users';
  ProgressDialog? pd;

  void showProgressDialog(context) {
    if (pd == null) {
      pd = ProgressDialog(context);
      pd!.style(
        message: 'Please Wait',
        borderRadius: 8.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 5.0,
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500
        ),
      );
    }
    pd!.show();
  }

  void dismissProgress() {
    if (pd != null && pd!.isShowing()) {
      pd!.hide();
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    List<dynamic> jsonResponse = json.decode(response.body);
    List<Map<String, dynamic>> users = jsonResponse.map((user) => user as Map<String, dynamic>,).toList();
    return users;
  }

  Future<void> addUser({context, map}) async {
    showProgressDialog(context);
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(map),
    );
    dismissProgress();
  }

  Future<void> updateUser({context, id, map}) async {
    showProgressDialog(context);
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(map),
    );
    dismissProgress();
  }

  Future<void> updateFavourite(String id, int favourite) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({FAVOURITE: favourite}),
    );
  }

  Future<void> deleteUser({context, id}) async {
    showProgressDialog(context);
    await http.delete(Uri.parse('$baseUrl/$id'));
    dismissProgress();
  }
}