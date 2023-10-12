import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';

class PaymentNotifier extends StateNotifier<List<Payment>> {
  PaymentNotifier() : super([]);

  void setData(List<Payment> data) {
    state = data;
  }

  List<Payment> getData() {
    return state;
  }

  void addPayment(Payment payment) {
    state = [...state, payment];
  }

  // PaymentMethod getPaymentMethodById(String id) {
  //   int methodIndex = state["paymentMethods"]!.indexWhere((p) => p.id == id);
  //   return state["paymentMethods"]![methodIndex];
  // }
  
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, List<Payment>>(
  (ref) => PaymentNotifier()
);