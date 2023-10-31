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
  late List<dynamic> _allTransactions;
  late List<dynamic> _transactions;
  late List<dynamic> _accounts;
  String? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _selectedAccount = "all";
    Future.delayed(Duration.zero, () async {
      _transactions = await _loadPlaidTransactions(_currentUser);
      _allTransactions = _transactions;
      _accounts = await _loadPlaidAccounts(_currentUser) as List<dynamic>;
      _loadPlaidItems(_currentUser);
    });
  }

  Future<List<dynamic>> _loadPlaidTransactions(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllTransactionsFromPlaid(_currentUser);
    ref.read(plaidTransactionsProvider.notifier).setData(all);
    // todo: do NOT set data if it can be retrieved
    return all["transactions"];
  }

  Future<List<dynamic>> _loadPlaidAccounts(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllAccountsFromPlaid(_currentUser);
    ref.read(plaidAccountProvider.notifier).setData(all);
    return all["accounts"];
  }

  Future<void> _loadPlaidItems(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllItemsFromPlaid(_currentUser);
    
    ref.read(plaidItemProvider.notifier).setData(all);
  }

  ExpansionTile _buildExpansionTile(Map<String, dynamic> p) {
    final GlobalKey expansionTileKey = GlobalKey();

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
    // List<dynamic> ?transactions;
    // List<dynamic> ?accounts;
    Map<String, dynamic> plaidJSON = ref.watch(plaidTransactionsProvider);
    Map<String, dynamic> plaidAccountJSON = ref.watch(plaidAccountProvider);
    // transactions = _selectedAccount=="all" ?
    //   plaidJSON["transactions"] :
    //   plaidJSON["transactions"].where((t) => t["account_id"] == _selectedAccount).toList();
    // accounts = plaidAccountJSON["accounts"];

    print('<!--- _transactions ---!>');
    print(_transactions);
    print('<!--- _transactions.length ---!>');
    print(_transactions!.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _authService.logOut,
          ),
          // leading: IconButton(
          //   icon: const Icon(Icons.push_pin),
          //   onPressed: () {
          //     Navigator.of(context).push(_createRoute());
          //   },
          // )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Colors.red,
                        Colors.blue
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top:0.0,
                  left: 0.0,
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text('metric'),
                        Text('another metric'),
                        Text('metric'),
                        Text('one more metric'),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top:0.0,
                  right: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white,),
                      onPressed: () {}),
                  ),
                )
              ]
            ),
            SizedBox(
              height: 40.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 3),
                      child: _selectedAccount == "all"
                          ? ElevatedButton(
                              key: ValueKey("elevated-all"),
                              onPressed: () => { setState(() => _selectedAccount = "all") },
                              child: Text(
                                "ALL Accounts".toUpperCase(),
                                style: const TextStyle(fontSize: 14)
                              )
                            )
                          : OutlinedButton(
                              key: ValueKey("outlined-all"),
                              onPressed: () => { setState(() => {
                                  _selectedAccount = "all",
                                  _transactions = _allTransactions
                                })
                              },
                              child: Text(
                                "ALL Accounts".toUpperCase(),
                                style: const TextStyle(fontSize: 14)
                              ),
                            ),
                    ),
                    for (var account in _accounts)
                      //const SizedBox(width: 5),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 3),
                          child: _selectedAccount == account?["account_id"]
                              ? ElevatedButton(
                                  key: ValueKey('elevated'),
                                  onPressed: () => { setState(() => _selectedAccount = account?["account_id"]) },
                                  child: Text(
                                    account?["name"].toUpperCase(),
                                    style: const TextStyle(fontSize: 14)
                                  )
                                )
                              : OutlinedButton(
                                  key: ValueKey("outlined"),
                                  onPressed: () => { setState(() => 
                                    _selectedAccount = account?["account_id"]),
                                    _transactions = _allTransactions.where((t) => t["account_id"] == account?["account_id"]).toList()
                                  },
                                  child: Text(
                                    account?["name"].toUpperCase(),
                                    style: const TextStyle(fontSize: 14)
                                  ),
                                ),
                        )
                  ],
                ),
              ),
            ),
            _transactions.isNotEmpty ? 
            ListView.builder(
              controller: _scrollController,
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _transactions.length,
              itemBuilder: (BuildContext context, int index) => _buildExpansionTile(_transactions[index]),
            ) :
            const Text('LOADING'),  
          ],
        ),
      )     
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