import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/screens/payments.dart';
import 'package:payment_tracking/screens/categories.dart';

import '../models/payment.dart';
import '../models/category.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // void _setScreen(String identifier) async {
  //   Navigator.of(context).pop();
  //   if (identifier == 'filters') {
  //     final result = await Navigator.of(context).push<Map<Filter, bool>>(
  //       MaterialPageRoute(
  //         builder: (ctx) => const FiltersScreen(),
  //       )
  //     );
  //     // print(result); // great debug
  //   }
  // }

  @override 
  Widget build(BuildContext context) {
    // final availableMeals = ref.watch(filteredMealsProvider);

    final data = [
      const Payment(
        id:"1",
        amount:"1.00",
        date:"08/17/2023",
        recipient:"Aiden",
        category: "Rent",
        paymentMethod: "Citizens Bank Checking"
      ),
      const Payment(
        id:"2",
        amount:"1.00",
        date:"08/17/2023",
        recipient:"Aiden",
        category: "Car",
        paymentMethod: "Cash"
      ),
      const Payment(
        id:"3",
        amount:"1.00",
        date:"08/17/2023",
        recipient:"Aiden",
        category: "Incidental",
        paymentMethod: "Citi Bank Card"
      ),
    ];

    final categoryData = [
      const Category(name: "n", description: "d"),
      const Category(name: "n2", description: "d2")
    ];

    Widget activePage = PaymentsScreen(
      data: data
    );

    var activePageTitle = 'Payments';

    if (_selectedPageIndex == 1) {
      // final favoriteMeals = ref.watch(favoriteMealsProvider);

      activePage = CategoriesScreen(
        data: categoryData
      );

        // categories: categoriesData,
      // );
      activePageTitle = 'Categories';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: _setScreen,
      // ),

      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: "Categories",),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),        
        ],
      ),
    );
  }
}