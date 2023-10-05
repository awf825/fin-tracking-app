import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/screens/payments.dart';
import 'package:payment_tracking/services/data_service.dart';
import 'package:payment_tracking/screens/categories.dart';

import 'package:payment_tracking/providers/full_data_provider.dart';

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
  final _dataService = DataService();
  // final fullData = ref.watch(fullDataProvider);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadItems();
    });
  }

  Future<void> _loadItems() async {
    final fullData = ref.watch(fullDataProvider);

    print("<!!! -- Full Data before fetch $fullData -- !!!>");

    if (fullData.entries.isEmpty) {
      final allData = await _dataService.loadAll();
      print("<!!! -- All Data after fetch $allData -- !!!>");
      ref.read(fullDataProvider.notifier).setData(allData);
    }
  }
  
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
    final fullData = ref.watch(fullDataProvider);

    print(fullData['payments']);
    print("<!!! ---- !!!>");
    print(fullData['paymentMethods']);
    print("<!!! ---- !!!>");
    print(fullData['streams']);
    print("<!!! ---- !!!>");
    print(fullData['categories']);

    /*
      type 'List<dynamic>' is not a subtype of type 'List<Payment>' in type cast

      In gathering the data, the response needs to be defined as:

      <Map<String, List<Payment> or List<Category> etc...>>
    */

    List<Payment> paymentData = ( fullData['payments'] ?? [] ) as List<Payment>;

    final categoryData = [
      const Category(name: "n", description: "d"),
      const Category(name: "n2", description: "d2")
    ];

    Widget activePage = PaymentsScreen(
      data: paymentData.map((p) => {
        Payment(
          id: p.id ?? "",
          amount:p.amount ?? "",
          date:p.date ?? "",
          recipient:p.recipient ?? "",
          categoryId:p.categoryId ?? "",
          paymentMethodId:p.paymentMethodId ?? ""
        ),
      }).toList() as List<Payment>
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