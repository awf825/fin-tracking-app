import 'package:flutter/material.dart';
import 'package:payment_tracking/models/app_model.dart';

class IncomeStream extends AppModel {
  const IncomeStream({
    this.id,
    required this.name,
    required this.institution, 
    required this.monthlyTotal,
    required this.yearlyTotal
  });

  final String ?id;
  final String name;
  final String institution;
  final int monthlyTotal;
  final int yearlyTotal;
}