import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  void setData(List<Category> data) {
    state = data;
  }

  List<Category> getData() {
    return state;
  }

  void addCategory(Category category) {
    state = [...state, category];
  }

  Category getById(String id) {
    int categoryIndex = state.indexWhere((c) => c.id == id);
    return state[categoryIndex];
  }

  // PaymentMethod getPaymentMethodById(String id) {
  //   int methodIndex = state["paymentMethods"]!.indexWhere((p) => p.id == id);
  //   return state["paymentMethods"]![methodIndex];
  // }
  
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>(
  (ref) => CategoryNotifier()
);