import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment {
  const Payment({
    required this.id, 
    required this.date,
    required this.recipient,
    required this.amount,
    // required this.category,
    // required this.paymentMethod,
    required this.paymentMethodId,
    required this.categoryId
  });

  final String id;
  final dynamic amount;
  final dynamic date;
  final String recipient;
  // final String category;
  // final String paymentMethod;

  final String categoryId;
  final String paymentMethodId;
}