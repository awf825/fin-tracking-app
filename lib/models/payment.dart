import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  dynamic amount;
  final Timestamp date;
  String recipient;
  String categoryId;
  String paymentMethodId;

  void setPaymentMethod(paymentMethodToSet) {
    paymentMethod = paymentMethodToSet;
  }

  void setCategory(categoryToSet) {
    category = categoryToSet;
  }

  String readDate() {
    return DateFormat.yMMMd().add_jm().format(date.toDate());
  }

  String readAmount() {
    return '\$$amount';
  }

  factory Payment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Payment(
      recipient: data?['recipient'],
      amount: data?['amount'],
      paymentMethodId: data?['paymentMethodId'],
      categoryId: data?['categoryId'],
      date: data?['date'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "recipient": recipient,
      if (amount > 0) "amount": amount,
      "paymentMethodId": paymentMethodId,
      "categoryId": categoryId,
      "date": date
    };
  }

}