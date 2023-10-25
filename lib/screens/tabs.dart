import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/providers/payment_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_account_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_item_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
import 'package:payment_tracking/services/auth_service.dart';
import 'package:payment_tracking/services/plaid_service.dart';
import 'package:payment_tracking/widgets/integrations.dart';
import 'package:animations/animations.dart';

// ignore: must_be_immutable
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _authService = AuthService();
  final _dataService = PlaidService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    Future.delayed(Duration.zero, () {
      _loadPlaidTransactions(_currentUser);
      _loadPlaidAccounts(_currentUser);
      _loadPlaidItems(_currentUser);
    });
  }

  Future<void> _loadPlaidTransactions(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllTransactionsFromPlaid(_currentUser);
    ref.read(plaidTransactionsProvider.notifier).setData(all);
  }

  Future<void> _loadPlaidAccounts(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllAccountsFromPlaid(_currentUser);
    ref.read(plaidAccountProvider.notifier).setData(all);
  }

  Future<void> _loadPlaidItems(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllItemsFromPlaid(_currentUser);
    
    ref.read(plaidItemProvider.notifier).setData(all);
  }

  ExpansionTile _buildExpansionTile(Map<String, dynamic> p) {
    final GlobalKey expansionTileKey = GlobalKey();
    print('<!-- p @ expansionTile -->');
    print(p["account_id"]);

    return ExpansionTile(
      key: expansionTileKey,
      title: ListTile(
        leading: Image.network(p["personal_finance_category_icon_url"]),
        title: Text(p["name"]),
        trailing: Text(p["amount"].toString())
      ),
      
      children: <Widget>[
        ListTile(
          leading: Text(p["date"]),
          // title: Text(p["category"][0]),
          title: Text(p["personal_finance_category"]["primary"]),
          trailing: Text(p["payment_channel"]),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> ?transactions;
    Map<String, dynamic> plaidJSON = ref.watch(plaidTransactionsProvider);
    transactions = plaidJSON["transactions"];

        // print('<!--- institutions @ integrations ---!>');
    // print(institutions[1]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
          // leading: IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: _authService.logOut,
          // ),
          leading: IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          )
      ),
      body: transactions != null ? 
        ListView.builder(
          controller: _scrollController,
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) => _buildExpansionTile(transactions![index]),
        ) :
        const Text('LOADING'),      
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Integrations(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
           fillColor: const Color(0xFFFF9000),
           animation: animation,
           secondaryAnimation: secondaryAnimation,
           transitionType: SharedAxisTransitionType.scaled,
           child: child,
      );
    },
  );
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payment_tracking/providers/plaid/plaid_account_provider.dart';
// import 'package:payment_tracking/providers/plaid/plaid_item_provider.dart';
// import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
// import 'package:payment_tracking/screens/payments.dart';
// import 'package:payment_tracking/services/auth_service.dart';
// import 'package:payment_tracking/services/plaid_service.dart';
// import 'package:payment_tracking/widgets/insights.dart';
// import 'package:payment_tracking/widgets/integrations.dart';

// class TabsScreen extends ConsumerStatefulWidget {
//   const TabsScreen({super.key});

//   @override
//   ConsumerState<TabsScreen> createState() {
//     return _TabsScreenState();
//   }
// }

// class _TabsScreenState extends ConsumerState<TabsScreen> {
//   int _selectedPageIndex = 0;
//   final _dataService = PlaidService();
//   final _authService = AuthService();
//   User? _currentUser;
//   // final fullData = ref.watch(fullDataProvider);

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = _authService.currentUser;
//     Future.delayed(Duration.zero, () {
//       _loadPlaidTransactions(_currentUser);
//       _loadPlaidAccounts(_currentUser);
//       _loadPlaidItems(_currentUser);
//     });
//   }

//   Future<void> _loadPlaidTransactions(User? _currentUser) async {
//     Map<String, dynamic> all = await _dataService.loadAllTransactionsFromPlaid(_currentUser);
//     ref.read(plaidTransactionsProvider.notifier).setData(all);
//   }

//   Future<void> _loadPlaidAccounts(User? _currentUser) async {
//     Map<String, dynamic> all = await _dataService.loadAllAccountsFromPlaid(_currentUser);
//     ref.read(plaidAccountProvider.notifier).setData(all);
//   }

//   Future<void> _loadPlaidItems(User? _currentUser) async {
//     Map<String, dynamic> all = await _dataService.loadAllItemsFromPlaid(_currentUser);
    
//     ref.read(plaidItemProvider.notifier).setData(all);
//   }
  
  
//   void _selectPage(int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   void _goInsights() async {
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => const Insights(),
//       )
//     );
//   }

//   void _goIntegrations() async {
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => const Integrations(),
//       )
//     );
//   }

//   @override 
//   Widget build(BuildContext context) {
//     Widget activePage;

//     switch(_selectedPageIndex) {
//       case 0: {
//         activePage = const PaymentsScreen();
//       }
//       break;
//       case 1: {
//         activePage = const Integrations();
//       }
//       break;
//       default: {
//         activePage = const PaymentsScreen();
//       }
//       break;
//     }

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("ITS THE MAIN HEADER"),
//       //   // leading: IconButton(
//       //   //   icon: const Icon(Icons.add),
//       //   //   onPressed: activeAddFunction,
//       //   // ),
//       // ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               curve: Curves.fastOutSlowIn,
//               child: Text(
//                 'Drawer Header',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             const ListTile(
//               leading: Icon(Icons.attach_money),
//               title: Text('Goals')
//             ),
//             ListTile(
//               leading: const Icon(Icons.insights),
//               title: const Text('Insights'),
//               onTap: _goInsights,
//             ),
//             ListTile(
//               leading: const Icon(Icons.sync),
//               title: const Text('Integrations'),
//               onTap: _goIntegrations,
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: _authService.logOut,
//             ),
//           ],
//         ),
//       ),

//       body: activePage,
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: _selectPage,
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedPageIndex,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.paid), label: "Transactions"),
//           BottomNavigationBarItem(icon: Icon(Icons.category), label: "Integrations"),     
//         ],
//       ),
//     );
//   }
// }