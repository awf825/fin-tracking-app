import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/income_stream.dart';
import 'package:payment_tracking/models/payment_method.dart';
import 'package:payment_tracking/screens/payment_methods.dart';
import 'package:payment_tracking/screens/payments.dart';
import 'package:payment_tracking/screens/streams.dart';
import 'package:payment_tracking/services/data_service.dart';
import 'package:payment_tracking/screens/categories.dart';

import 'package:payment_tracking/providers/full_data_provider.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

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

    if (fullData.entries.isEmpty) {
      Map<String, List<dynamic>> allData = await _dataService.loadAll();
      ref.read(fullDataProvider.notifier).setData(allData);
    }
  }
  
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void addPayment() async {
    final newPayment = await Navigator.of(context).push<Payment>(
      MaterialPageRoute(
        builder: (ctx) => const NewPayment(),
      )
    );

    if (newPayment == null) {
      return; 
    }

    final gotCategory = ref.read(fullDataProvider.notifier).getCategoryById(newPayment.categoryId);
    final gotPaymentMethod = ref.read(fullDataProvider.notifier).getPaymentMethodById(newPayment.paymentMethodId);
    newPayment.setCategory(gotCategory);
    newPayment.setPaymentMethod(gotPaymentMethod);

    print("<!-- newPayment after Update -->");
    print(newPayment);
    print("<!---->");

    ref.read(fullDataProvider.notifier).addPayment(newPayment);
  }

  @override 
  Widget build(BuildContext context) {
    final fullData = ref.watch(fullDataProvider);
    Widget activePage;
    String activePageTitle;
    void Function()? activeAddFunction;

    print("<!-- fullData payments AT TABS  -->");
    print(fullData["payments"]!.length);
    print("<!---->");

    switch(_selectedPageIndex) {
      case 0: {
        if (fullData["payments"] != null) {
          activePage = PaymentsScreen(
            data: fullData["payments"] as List<Payment>
          );
          activePageTitle = 'Payments';
          activeAddFunction = addPayment;
        } else {
          activePage = const Text("LOADING SCREEN");
          activePageTitle = 'Loading';
        }
      }
      break;
      case 1: {
        activePage = CategoriesScreen(
          data: fullData["categories"] as List<Category>?
        );
        activePageTitle = 'Categories';
      }
      break;
      case 2: {
        activePage = StreamsScreen(
          data: fullData["streams"] as List<IncomeStream>?
        );
        activePageTitle = 'Income Streams';
      }
      case 3: {
        activePage = PaymentMethodsScreen(
          data: fullData["paymentMethods"] as List<PaymentMethod>?
        );
        activePageTitle = 'Payment Methods';
      }
      break;
      default: {
        if (fullData["payments"] != null) {
          activePage = PaymentsScreen(
            data: fullData["payments"] as List<Payment>
          );
          activePageTitle = 'Payments';
          activeAddFunction = addPayment;
        } else {
          activePage = const Text("LOADING SCREEN");
          activePageTitle = 'Loading';
        }
      }
      break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: activeAddFunction,
        ),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: _setScreen,
      // ),

      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.paid), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Income"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payment Methods")          
        ],
      ),
    );
  }
}