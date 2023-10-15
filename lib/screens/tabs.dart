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
import 'package:payment_tracking/widgets/insights.dart';
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

  void _goInsights() async {
    final updatedPayment = await Navigator.of(context).push<Payment>(
      MaterialPageRoute(
        builder: (ctx) => Insights(),
      )
    );

    if (updatedPayment == null) {
      return; 
    }
  }

  @override 
  Widget build(BuildContext context) {
    Widget activePage;

    switch(_selectedPageIndex) {
      case 0: {
        activePage = const PaymentsScreen();
      }
      break;
      case 1: {
        activePage = const CategoriesScreen();
      }
      break;
      // case 2: {
      //   activePage = const StreamsScreen();
      // }
      case 2: {
        activePage = const PaymentMethodsScreen();
      }
      break;
      default: {
        activePage = const PaymentsScreen();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              curve: Curves.fastOutSlowIn,
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Goals')
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Insights'),
              onTap: _goInsights,
            ),
          ],
        ),
      ),

      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.paid), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          // BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Income"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Accounts")          
        ],
      ),
    );
  }
}