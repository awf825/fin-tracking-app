import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Integrations'),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                // TODO: insert integrations here instead of configuration string!!!
                child: Center(
                  child: Text(
                    _configuration?.toJson().toString() ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _configuration != null
                    ? () => PlaidLink.open(configuration: _configuration!)
                    : null,
                child: Text("Create Integration"),
              ),
            ],
          ),
      ),
    );
  }
}