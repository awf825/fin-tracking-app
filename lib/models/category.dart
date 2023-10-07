import 'package:flutter/material.dart';
import 'package:payment_tracking/models/app_model.dart';

class Category extends AppModel {
  const Category({
    this.id,
    required this.name, 
    required this.description
  });

  final String ?id;
  final String name;
  final String description;

}