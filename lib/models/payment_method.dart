import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payment_tracking/models/app_model.dart';

class PaymentMethod extends AppModel {
  const PaymentMethod({
    this.id, 
    required this.name,
  });

  final String ?id;
  final String name;

  factory PaymentMethod.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PaymentMethod(
      name: data?['name']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
    };
  }
}