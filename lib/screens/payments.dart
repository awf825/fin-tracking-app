import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/services/auth_service.dart';
import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
import 'package:payment_tracking/services/auth_service.dart';

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

  @override
  void initState() {
    super.initState();
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
          leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addPayment,
        ),
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