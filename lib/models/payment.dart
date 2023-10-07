import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment_tracking/models/app_model.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment_method.dart';

class Payment extends AppModel {
  Payment({
    this.id, 
    this.paymentMethod,
    this.category,
    required this.date,
    required this.recipient,
    required this.amount,
    required this.paymentMethodId,
    required this.categoryId
  });

  final String ?id;
  PaymentMethod ?paymentMethod;
  Category ?category;
  final dynamic amount;
  final Timestamp date;
  final String recipient;
  final String categoryId;
  final String paymentMethodId;

  void setPaymentMethod(paymentMethodToSet) {
    paymentMethod = paymentMethodToSet;
  }

  void setCategory(categoryToSet) {
    category = categoryToSet;
  }

  String readDate() {
    return DateFormat.yMMMd().add_jm().format(date.toDate());
  }
}