import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  void setData(List<Category> data) {
    state = data;
  }

  List<Category> getData() {
    return state;
  }

  void addCategory(Category category) {
    state = [...state, category];
  }

  Category getById(String id) {
    int categoryIndex = state.indexWhere((c) => c.id == id);
    return state[categoryIndex];
  }  
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>(
  (ref) => CategoryNotifier()
);