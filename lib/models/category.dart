import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Category.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Category(
      name: data?['name'],
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "description": description
    };
  }

}