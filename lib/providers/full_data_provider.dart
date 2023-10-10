import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';

class FullDataNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  FullDataNotifier() : super({});

  void setData(Map<String, List<dynamic>> data) {
    state = data;
  }

  Map<String, List<dynamic>> getData() {
    return state;
  }

  void addPayment(Payment payment) {
    state["payments"]?.add(payment);
  }
}

final fullDataProvider = StateNotifierProvider<FullDataNotifier, Map<String, List<dynamic>>>(
  (ref) => FullDataNotifier()
);