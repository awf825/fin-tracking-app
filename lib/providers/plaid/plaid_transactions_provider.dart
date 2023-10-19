import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';

class PlaidTransactionsNotifier extends StateNotifier<Map<String, dynamic>> {
  PlaidTransactionsNotifier() : super({});

  void setData(Map<String, dynamic> data) {
    state = data;
  }
}

final plaidTransactionsProvider = StateNotifierProvider<PlaidTransactionsNotifier, Map<String, dynamic>>(
  (ref) => PlaidTransactionsNotifier()
);