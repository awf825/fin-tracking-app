// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/services/data_service.dart';

class Insights extends ConsumerStatefulWidget {
  const Insights({
    super.key
  });

  @override
  ConsumerState<Insights> createState() {
    return _InsightsState();
  }
}

class _InsightsState extends ConsumerState<Insights> {
  final _dataService = DataService();
  var _selectedPaymentMethod;
  var _selectedCategory;
  DateTime _selectedStartDate = getInitialStart();
  DateTime _selectedEndDate = DateTime.now(); // will need to solve currentYear at some point at the end of the year
  var _isQuerying = false;
  var _queriedPayments = [];
  var _totalSpend = 0;

  static DateTime getInitialStart() {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int currentDay = DateTime.now().day;

    // if current day is after the 15th, back track start date to 15th of the current month
    // if current day is before the 15th, back track start date to last of day of prior month
    if (currentDay >= 15) {
      DateTime projectedDay = DateTime.utc(currentYear, currentMonth, 15);
      if (projectedDay.weekday == DateTime.sunday) {
        return DateTime.utc(currentYear, currentMonth, 13);
      } else if (projectedDay.weekday == DateTime.saturday) {
        return DateTime.utc(currentYear, currentMonth, 14);
      } else {
        return projectedDay;
      }
    } else {
      DateTime projectedDay = DateTime.utc(currentYear, currentMonth-1, 0);
      if (projectedDay.weekday == DateTime.sunday) {
        return DateTime.utc(currentYear, currentMonth-1, -2);
      } else if (projectedDay.weekday == DateTime.saturday) {
        return DateTime.utc(currentYear, currentMonth-1, -1);
      } else {
        return projectedDay;
      }
    }

  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2010, 1),
      lastDate: DateTime.now()
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2010, 1),
      lastDate: DateTime.now()
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  void _query() async {
    setState(() {
      _isQuerying = true;
    });

    List<Payment> queriedPayments = await _dataService.query(
      _selectedPaymentMethod,
      _selectedCategory,
      _selectedStartDate,
      _selectedEndDate
    );

    int totalSpend = queriedPayments.isNotEmpty ? 
      queriedPayments.map((qp) => qp.amount).reduce((value, element) => value + element) :
      0;

    setState(() {
      _queriedPayments = queriedPayments;
      _totalSpend = totalSpend;
      _isQuerying = false;
    });
  }

  void _purge() async {
    setState(() {
      _isQuerying = true;
    });

    await _dataService.purge();

    setState(() {
      _isQuerying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.read(categoryProvider);
    final paymentMethods = ref.read(paymentMethodProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField(
                        decoration:  const InputDecoration(
                          label: Text('Payment Method')
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
                              )
                            )
                        ],
                        onChanged: (value) {
                          _selectedPaymentMethod = value!;
                        },
                      ),
                    ),
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
                  children: [
                    Expanded(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("${_selectedStartDate.toLocal()}".split(' ')[0]),
                              IconButton(
                                onPressed: () => _selectStartDate(context),
                                icon: const Icon(Icons.calendar_month_rounded)
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              Text("${_selectedEndDate.toLocal()}".split(' ')[0]),
                              IconButton(
                                onPressed: () => _selectEndDate(context),
                                icon: const Icon(Icons.calendar_month_rounded)
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // make sure row content is pushed all the way to the right
                  children: [
                    Text('Spend: \$$_totalSpend'),
                    ElevatedButton(
                      onPressed: _isQuerying ? null : _query, 
                      child: _isQuerying 
                        ? const SizedBox(
                          height: 16, 
                          width: 16, 
                          child: CircularProgressIndicator()
                        ) : const Text('Search')
                    ),
                    ElevatedButton(
                      onPressed: _isQuerying ? null : _purge, 
                      child: _isQuerying 
                        ? const SizedBox(
                          height: 16, 
                          width: 16, 
                          child: CircularProgressIndicator()
                        ) : const Text('PURGE')
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 500.0,
                        child: _queriedPayments.isNotEmpty ?
                          ListView.builder(
                            itemCount: _queriedPayments.length,
                            itemBuilder: (BuildContext context, int index) => 
                              // Text(_queriedPayments[index].name)
                              ListTile(
                                title: Text(_queriedPayments[index].recipient),
                                subtitle: Text(_queriedPayments[index].readAmount()),
                              )
                            
                          ) : 
                          const Text("Nothing to display"),
                      )
                    )
                    // _queriedPayments.isNotEmpty ?
                    // ListView.builder(
                    //   itemCount: _queriedPayments.length,
                    //   itemBuilder: (BuildContext context, int index) => 
                    //     // Text(_queriedPayments[index].name)
                    //     ListTile(
                    //       title: Text(_queriedPayments[index].name),
                    //       subtitle: Text(_queriedPayments[index].description),
                    //     )
                      
                    // ) : 
                    // const Text("Nothing to display"),

                  ]
                )
            ]
          ),
        )
      )
    );
  }
}