import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';

class PlaidAccountProvider extends StateNotifier<Map<String, dynamic>> {
  PlaidAccountProvider() : super({});

  void setData(Map<String, dynamic> data) {
    state = data;
  }
}

final plaidAccountProvider = StateNotifierProvider<PlaidAccountProvider, Map<String, dynamic>>(
  (ref) => PlaidAccountProvider()
);