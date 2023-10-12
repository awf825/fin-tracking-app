import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/income_stream.dart';
import 'package:payment_tracking/models/payment_method.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/providers/payment_provider.dart';
import 'package:payment_tracking/screens/payment_methods.dart';
import 'package:payment_tracking/screens/payments.dart';
import 'package:payment_tracking/screens/streams.dart';
import 'package:payment_tracking/services/data_service.dart';
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
    final payments = ref.read(paymentProvider);

    if (payments.isEmpty) {
      Map<String, List<dynamic>> allData = await _dataService.loadAll();
      List<Payment> payments = allData["payments"] as List<Payment>;
      List<Category> categories = allData["categories"] as List<Category>;
      List<PaymentMethod> paymentMethods = allData["paymentMethods"] as List<PaymentMethod>;
      // List<Stream> streams = allData["streams"] as List<Stream>;

      ref.read(paymentProvider.notifier).setData(payments);
      ref.read(categoryProvider.notifier).setData(categories);
      ref.read(paymentMethodProvider.notifier).setData(paymentMethods);
      //ref.read(incomeStreamProvider.notifier).setData(streams);
    }
  }
  
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override 
  Widget build(BuildContext context) {
    Widget activePage;

    switch(_selectedPageIndex) {
      case 0: {
        activePage = PaymentsScreen();
      }
      break;
      case 1: {
        activePage = CategoriesScreen();
      }
      break;
      case 2: {
        activePage = StreamsScreen();
      }
      case 3: {
        activePage = PaymentMethodsScreen();
      }
      break;
      default: {
        activePage = PaymentsScreen();
      }
      break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ITS THE MAIN HEADER"),
        // leading: IconButton(
        //   icon: const Icon(Icons.add),
        //   onPressed: activeAddFunction,
        // ),
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