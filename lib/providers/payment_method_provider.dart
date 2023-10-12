import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';

class PaymentMethodNotifier extends StateNotifier<List<PaymentMethod>> {
  PaymentMethodNotifier() : super([]);

  void setData(List<PaymentMethod> data) {
    state = data;
  }

  List<PaymentMethod> getData() {
    return state;
  }

  void addPaymentMethod(PaymentMethod paymentMethod) {
    state = [...state, paymentMethod];
  }

  PaymentMethod getById(String id) {
    int methodIndex = state.indexWhere((p) => p.id == id);
    return state[methodIndex];
  }
}

final paymentMethodProvider = StateNotifierProvider<PaymentMethodNotifier, List<PaymentMethod>>(
  (ref) => PaymentMethodNotifier()
);