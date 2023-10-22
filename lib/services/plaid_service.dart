import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PlaidService {
  Future<Map<String, dynamic>> loadAllTransactionsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/transactions').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

  Future<Map<String, dynamic>> loadAllAccountsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/accounts').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

  Future<Map<String, dynamic>> loadAllItemsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/item').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

}