// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/services/data_service.dart';

class EditPayment extends ConsumerStatefulWidget {
  const EditPayment({
    super.key,
    required this.payment
  });

  final Payment payment;

  @override
  ConsumerState<EditPayment> createState() {
    return _EditPaymentState();
  }
}

class _EditPaymentState extends ConsumerState<EditPayment> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService();
  var _enteredRecipient;
  var _enteredAmount;  
  var _selectedCategory;
  var _selectedPaymentMethod;
  late DateTime _selectedDateTime;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      print(_selectedDateTime);

      final payment = Payment(
        id: widget.payment.id,
        date: widget.payment.date,
        recipient: _enteredRecipient,
        amount: _enteredAmount,
        paymentMethodId: _selectedPaymentMethod,
        categoryId: _selectedCategory
      );

      await _dataService.updatePayment(payment);

      if (!mounted) { // i.e !context.moun
        return;
      }

      Navigator.of(context).pop(payment);
    } 
  }

  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categories = ref.read(categoryProvider);
    final paymentMethods = ref.read(paymentMethodProvider);
    _enteredRecipient = widget.payment.recipient;
    _enteredAmount = widget.payment.amount.toString();  
    _selectedCategory = widget.payment.categoryId;
    _selectedPaymentMethod = widget.payment.paymentMethodId;
    _selectedDateTime = widget.payment.date.toDate();

    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(), 
        firstDate: DateTime(2023), 
        lastDate: DateTime(2100)
      );

      if (_picked != null) {
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
          // _selectedDateTime = _picked;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit payment'),
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
                      initialValue: _enteredAmount,
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
                        _selectedCategory = value!;
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
                        label: Text('Payment Method'),
                      ),
                      value: _selectedPaymentMethod,
                      items: [
                        for (final method in paymentMethods) 
                          DropdownMenuItem(
                            value: method.id,
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(method.name)
                              ]
                            ),
                          )
                      ],
                      onChanged: (value) {
                        _selectedPaymentMethod = value!;
                      }
                    )
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: "Payment Date",
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                        )
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate();
                      },
                    )
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // make sure row content is pushed all the way to the right
                children: [
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem, 
                    child: _isSending 
                      ? const SizedBox(
                        height: 16, 
                        width: 16, 
                        child: CircularProgressIndicator()
                      ) : const Text('Edit Payment')
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