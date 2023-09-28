import 'package:flutter/material.dart';

class Payment {
  const Payment({
    required this.id, 
    required this.date,
    required this.recipient,
    required this.amount,
    required this.category,
    required this.paymentMethod
  });

  final String id;
  final String amount;
  final String date;
  final String recipient;
  final String category;
  final String paymentMethod;
}