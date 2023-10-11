import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';

class FullDataNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  FullDataNotifier() : super({});

  void setData(Map<String, List<dynamic>> data) {
    state = data;
  }

  Map<String, List<dynamic>> getData() {
    return state;
  }

  void addPayment(Payment payment) {
    List<Payment> newPayments = [...?state["payments"], payment];
    state = {
      ...state,
      "payments": newPayments 
    };
  }

  Category getCategoryById(String id) {
    int categoryIndex = state["categories"]!.indexWhere((c) => c.id == id);
    return state["categories"]![categoryIndex];
  }

  PaymentMethod getPaymentMethodById(String id) {
    int methodIndex = state["paymentMethods"]!.indexWhere((p) => p.id == id);
    return state["paymentMethods"]![methodIndex];
  }
  
}

final fullDataProvider = StateNotifierProvider<FullDataNotifier, Map<String, List<dynamic>>>(
  (ref) => FullDataNotifier()
);