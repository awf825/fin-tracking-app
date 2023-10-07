import 'package:flutter/material.dart';
import 'package:payment_tracking/models/app_model.dart';

class PaymentMethod extends AppModel {
  const PaymentMethod({
    this.id, 
    required this.name,
  });

  final String ?id;
  final String name;
}