// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/services/data_service.dart';

class NewPayment extends ConsumerStatefulWidget {
  const NewPayment({super.key});

  @override
  ConsumerState<NewPayment> createState() {
    return _NewPaymentState();
  }
}

class _NewPaymentState extends ConsumerState<NewPayment> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService();
  var _enteredRecipient = '';
  var _enteredAmount = 0;  
  var _selectedCategory;
  var _selectedPaymentMethod;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Timestamp now = Timestamp.fromDate(DateTime.now());
      setState(() {
        _isSending = true;
      });

      final payment = Payment(
        recipient: _enteredRecipient,
        amount: _enteredAmount,
        paymentMethodId: _selectedPaymentMethod,
        categoryId: _selectedCategory,
        date: now,
      );

      final newDocId = await _dataService.addPayment(payment);

      if (!mounted) { // i.e !context.mounted
        return;
      }

      Navigator.of(context).pop(
        Payment(
          id: newDocId, 
          recipient: _enteredRecipient,
          amount: _enteredAmount,
          categoryId: _selectedCategory,
          paymentMethodId: _selectedPaymentMethod,
          date: now, 
        )
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.read(categoryProvider);
    final paymentMethods = ref.read(paymentMethodProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        // child: Text("HELLO TEXT NEW PAYMENT FORM"),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Recipient')
                ),
                initialValue: _enteredRecipient,
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
                  _enteredRecipient = value!;
                }
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Amount')
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredAmount.toString(),
                      validator: (value) {
                        if (
                          value == null || 
                          value.isEmpty || 
                          int.tryParse(value) == null || 
                          int.tryParse(value)! <= 0
                        ) {
                          return 'Must be a valid positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredAmount = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text('Category')
                      ),
                      value: _selectedCategory,
                      items: [
                        // can't loop through a map (categories), need to specify categories.entries
                        for (final category in categories) 
                          DropdownMenuItem(
                            value: category.id,
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(category.name)
                              ]
                            )
                          )
                      ],
                      onChanged: (value) {
                        // need to use setState here because to display the _selectedCategory in the UI, we need 
                        // to keep track of a local state. This is also why we don't need onSaved on this dropdown
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text('Payment Method')
                      ),
                      value: _selectedPaymentMethod,
                      items: [
                        // can't loop through a map (categories), need to specify categories.entries
                        for (final method in paymentMethods) 
                          DropdownMenuItem(
                            value: method.id,
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(method.name)
                              ]
                            )
                          )
                      ],
                      onChanged: (value) {
                        // need to use setState here because to display the _selectedCategory in the UI, we need 
                        // to keep track of a local state. This is also why we don't need onSaved on this dropdown
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  )
                ],
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
                      ) : const Text('Add Item')
                  )
                ],
              )
            ],
          )
        )
      )
    );
  }
}