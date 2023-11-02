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
import "package:collection/collection.dart";


// extension UtilListExtension on List{
//   groupBy(String key) {
//     try {
//       List<Map<String, dynamic>> result = [];
//       List<String> keys = [];

//       this.forEach((f) => keys.add(f[key]));

//       [...keys.toSet()].forEach((k) {
//         List data = [...this.where((e) => e[key] == k)];
//         result.add({k: data});
//       });

//       return result;
//     } catch (e, s) {
//       // printCatchNReport(e, s);
//       return this;
//     }
//   }
// }


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
  String? _selectedAccount;
  late List<dynamic> _allTransactions;
  late List<dynamic> _currentTransactions;
  late Map<String, dynamic> _transactionsGroupedByDate;
  late Map<String, dynamic> _transactionsResponse;
  late Map<String, dynamic> _transactionsByAccountDict;
  late List<dynamic> _accounts;

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _selectedAccount = "all";
    Future.delayed(Duration.zero, () async {
      _transactionsResponse = await _loadPlaidTransactions(_currentUser);
      _currentTransactions = _transactionsResponse["sortedTransactions"];
      _allTransactions = _currentTransactions;
      _transactionsByAccountDict = _transactionsResponse["transactionsByAccountDict"];
      _transactionsGroupedByDate = _transactionsByAccountDict;

      _accounts = await _loadPlaidAccounts(_currentUser) as List<dynamic>;
      _loadPlaidItems(_currentUser);
    });
  }

  Future<Map<String, dynamic>> _loadPlaidTransactions(User? _currentUser) async {
    Map<String, dynamic> all = await _dataService.loadAllTransactionsFromPlaid(_currentUser);
    ref.read(plaidTransactionsProvider.notifier).setData(all);
    // todo: do NOT set data if it can be retrieved
    return all;
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

  @override
  Widget build(BuildContext context) {
    // print('<!--- _transactions ---!>');
    // print(_currentTransactions);
    // print('<!--- _transactions.length ---!>');
    // print(_currentTransactions.length);

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
                      switchInCurve: Curves.linear,
                      switchOutCurve: Curves.linear,
                      duration: Duration.zero,
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
                                  _currentTransactions = _allTransactions
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
                          duration: Duration.zero,
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
                                    _selectedAccount = account!["account_id"]),
                                    if (_transactionsByAccountDict.containsKey(account!["account_id"])) {
                                      _currentTransactions = _transactionsByAccountDict[account["account_id"]],
                                      _transactionsGroupedByDate = groupBy(_currentTransactions, (obj) => obj['date'])
                                    } else {
                                      _currentTransactions = []
                                    }
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
            _currentTransactions.isNotEmpty ? 
            ListView.builder(
              controller: _scrollController,
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _currentTransactions.length,
              itemBuilder: (BuildContext context, int index) => _buildExpansionTile(_currentTransactions[index]),
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

ExpansionTile _buildExpansionTile(Map<String, dynamic> p) {
  final GlobalKey expansionTileKey = GlobalKey();

  // var groupedArray = groupBy(data, (obj) => DateTime.fromMillisecondsSinceEpoch(obj['createdAd']*1000));

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