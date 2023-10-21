import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:payment_tracking/providers/plaid/plaid_account_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_item_provider.dart';
import 'package:payment_tracking/services/auth_service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  User? _currentUser;
  final _authService = AuthService();
  String _linkToken = "";

  @override
  void initState() {
    super.initState();

    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
    _currentUser = _authService.currentUser;

    Future.delayed(Duration.zero, () {
      _getLinkToken(_currentUser);
    });
  }

  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }

  Future<void> _getLinkToken(User? user) async {
    final resp = await http.post(
      Uri.parse('http://localhost:8000/api/create_link_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({ 
        "uid": user?.uid 
      }),
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
    print("<!--- ON EVENT ---!>");
    final name = event.name;
    final metadata = event.metadata.description();
    print("onEvent: $name, metadata: $metadata");
  }

  // called when integration is successful, and a public token is sent to client
  // (to be exchanged for the creation of a user specific access token) 
  void _onSuccess(LinkSuccess event) async {
    print("<!--- ON SUCCESS ---!>");
    final token = event.publicToken;
    final metadata = event.metadata.description();
    print("onSuccess: $token, metadata: $metadata");

    final resp = await http.post(
      Uri.parse('http://localhost:8000/api/set_access_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({ 
        "public_token": token, 
        "uid": _currentUser?.uid
      }),
    );
    final decoded = jsonDecode(resp.body);
    if (decoded["error"]) {
      return;
      // TODO, notify user if plaid doesn't
    } else {
      // add data to riverpod?
    }
    // setState(() => _successObject = event);
  }

  void _onExit(LinkExit event) {
    print("<!--- ON EXIT ---!>");
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
    List<dynamic> ?items;
    List<dynamic> ?institutions;
    Map<String, dynamic> plaidAccountJSON = ref.watch(plaidAccountProvider);
    Map<String, dynamic> plaidItemJSON = ref.watch(plaidItemProvider);
    accounts = plaidAccountJSON["accounts"];
    items = plaidItemJSON["items"];
    institutions = plaidItemJSON["institutions"];
    
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
          itemCount: institutions!.length,
          itemBuilder: (BuildContext context, int index) => _buildExpansionTile(institutions![index]["name"]),
        ) :
        const Text('LOADING'),      
    );
  }
}