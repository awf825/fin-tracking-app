import 'package:flutter/material.dart';

class AppModel {
  const AppModel();

  void operator []= (String key, dynamic value) => {
    this[key] = value
  };
}