import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';

class PlaidItemProvider extends StateNotifier<Map<String, dynamic>> {
  PlaidItemProvider() : super({});

  void setData(Map<String, dynamic> data) {
    state = data;
  }
}

final plaidItemProvider = StateNotifierProvider<PlaidItemProvider, Map<String, dynamic>>(
  (ref) => PlaidItemProvider()
);