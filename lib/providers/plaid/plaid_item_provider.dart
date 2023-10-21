import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';

class PlaidItemProvider extends StateNotifier<Map<String, dynamic>> {
  PlaidItemProvider() : super({});

  void setData(Map<String, dynamic> data) {
    state = data;
  }

  // void addItem(List<dynamic> item) {
  //   List<dynamic> newAccounts = state["item"];
  //   newAccounts.add(account);
  //   state["accounts"] = newAccounts;
  // }
}

final plaidItemProvider = StateNotifierProvider<PlaidItemProvider, Map<String, dynamic>>(
  (ref) => PlaidItemProvider()
);