import 'package:flutter/material.dart';
import 'package:payment_tracking/models/payment_method.dart';
import 'package:payment_tracking/services/data_service.dart';

class NewPaymentMethod extends StatefulWidget {
  const NewPaymentMethod({
    super.key
  });

  @override
  State<StatefulWidget> createState() {
    return _NewPaymentMethodState();
  }
}

class _NewPaymentMethodState extends State<NewPaymentMethod> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService();
  var _enteredName = '';
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final paymentMethod = PaymentMethod(
        name: _enteredName,
      );

      final newDocId = await _dataService.addPaymentMethod(paymentMethod);

      if (!mounted) { // i.e !context.mounted
        return;
      }

      Navigator.of(context).pop(
        PaymentMethod(
          id: newDocId, 
          name: _enteredName,
        )
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name')
                ),
                initialValue: _enteredName,
                validator: (value) {
                  if (
                    value == null || 
                    value.isEmpty || 
                    value.trim().length <= 1 || 
                    value.trim().length > 50
                  ) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                }
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // make sure row content is pushed all the way to the right
                children: [
                  // setting TextButton's onPressed to null will disable the button
                  TextButton(
                    onPressed: _isSending ? null : () {
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Reset')
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem, 
                    child: _isSending 
                      ? const SizedBox(
                        height: 16, 
                        width: 16, 
                        child: CircularProgressIndicator()
                      ) : const Text('Add Payment Method')
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}