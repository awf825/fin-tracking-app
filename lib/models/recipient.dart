import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:payment_tracking/models/app_model.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/payment_method.dart';

class Recipient extends AppModel {
  Recipient({
    this.id, 
    required this.name
  });

  final String ?id;
  String name;
}