import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA_CDm69Rcr26SPhw9fSB-t8Jh-9m_8_SY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _authenticate(email, password, 'signUp');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {

        try {
    await _authenticate(email, password, 'signInWithPassword');
    } catch (e) {
      rethrow;
    }
  }
}
