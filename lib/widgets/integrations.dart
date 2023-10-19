import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:payment_tracking/providers/plaid/plaid_account_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_item_provider.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class Integrations extends ConsumerStatefulWidget {
  const Integrations({
    super.key
  });

  @override
  ConsumerState<Integrations> createState() {
    return _IntegrationsState();
  }
}

class _IntegrationsState extends ConsumerState<Integrations> {
  final ScrollController _scrollController = ScrollController();
  LinkConfiguration? _configuration;
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkObject? _successObject;
  String _linkToken = "";

  @override
  void initState() {
    super.initState();

    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);

    Future.delayed(Duration.zero, () {
      _getLinkToken();
    });
  }

  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }

  Future<void> _getLinkToken() async {
    final resp = await http.post(
      Uri.parse('http://localhost:8000/api/create_link_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({}),
    );
    final decoded = jsonDecode(resp.body);
    _linkToken = decoded['link_token'];
    setState(() {
      _configuration = LinkTokenConfiguration(
        token: _linkToken,
      );
    });
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    print("onEvent: $name, metadata: $metadata");
  }

  // called when integration is successful, and a public token is sent to client
  // (to be exchanged for the creation of a user specific access token) 
  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    print("onSuccess: $token, metadata: $metadata");
    setState(() => _successObject = event);
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    print("onExit metadata: $metadata, error: $error");
  }

  ExpansionTile _buildExpansionTile(String title) {
    return ExpansionTile(title: Text(title));
    // final GlobalKey expansionTileKey = GlobalKey();
    // print('<!-- p @ expansionTile -->');
    // print(p["account_id"]);
    // // final Payment payment = _localPayments[index];
    // return ExpansionTile(
    //   key: expansionTileKey,
    //   title: ListTile(
    //     leading: Image.network(p["personal_finance_category_icon_url"]),
    //     title: Text(p["name"]),
    //     trailing: Text(p["amount"].toString())
    //   ),
      
    //   // Text('My expansion tile $index'),
    //   children: <Widget>[
    //     ListTile(
    //       // leading: IconButton(
    //       //   icon: const Icon(Icons.edit),
    //       //   onPressed: () => editPayment(p),
    //       // ),
    //       leading: Text(p["date"]),
    //       // title: Text(p["category"][0]),
    //       title: Text(p["personal_finance_category"]["primary"]),
    //       trailing: Text(p["payment_channel"]),
    //     )
    //   ]
    // );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> ?accounts;
    Map<String, dynamic> ?item;
    Map<String, dynamic> ?institution;
    Map<String, dynamic> plaidAccountJSON = ref.watch(plaidAccountProvider);
    Map<String, dynamic> plaidItemJSON = ref.watch(plaidItemProvider);
    accounts = plaidAccountJSON["accounts"];
    item = plaidAccountJSON["item"];
    institution = plaidItemJSON["institution"];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
        leading: ElevatedButton(
          onPressed: _configuration != null
              ? () => PlaidLink.open(configuration: _configuration!)
              : null,
          child: Text("Create Integration"),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.add),
        //   onPressed: addPayment,
        // ),
      ),
      body: accounts != null ? 
        ListView.builder(
          controller: _scrollController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) => _buildExpansionTile(institution!["name"]),
        ) :
        const Text('LOADING'),      
    );
  }
}