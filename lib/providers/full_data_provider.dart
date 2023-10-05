import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:meals/providers/meals_provider.dart';

// enum Filter {
//   glutenFree,
//   lactoseFree,
//   vegetarian,
//   vegan
// }

class FullDataNotifier extends StateNotifier<Map<String, dynamic>> {
  FullDataNotifier() : super({});

  void setData(Map<String, dynamic> data) {
    state = data;
  }
}

final fullDataProvider = StateNotifierProvider<FullDataNotifier, Map<String, dynamic>>(
  (ref) => FullDataNotifier()
);

// final fullDataProvider = Provider(
//   (ref) {
//     var map = {};
//     map["payment"] = "All payments";
//     map["categories"] = "Array of categories";
//     map["streams"] = "Array of streams";
//     map["paymentMethods"] = "Array of paymentMethods";

//     return map;
//   //final fullData = ref.watch(filtersProvider);

//   // return meals.where((meal) {
//   //   if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
//   //     return false;
//   //   }
//   //   if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
//   //     return false;
//   //   }
//   //   if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
//   //     return false;
//   //   }
//   //   if (activeFilters[Filter.vegan]! && !meal.isVegan) {
//   //     return false;
//   //   }
//   //   return true;
//   // }).toList();
// });