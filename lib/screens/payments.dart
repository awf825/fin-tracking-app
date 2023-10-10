import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/full_data_provider.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  PaymentsScreen({
    super.key,
    this.data
  });

  List<Payment> ?data;

  @override
  ConsumerState<PaymentsScreen> createState() {
    return PaymentsScreenState();
  }
}

class PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  // ignore: prefer_final_fields
  List<dynamic>? _payments;

  @override
  void initState() {
    super.initState();
    if (widget.data!.isNotEmpty) {
      _payments = widget.data;
    }
  }
  
  List<DataColumn> getDataColumns(columnNames) {
    List<DataColumn> columns = [];
    for (var name in columnNames) {
      columns.add(
        DataColumn(
          label: Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
        ),
      );
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    //List<dynamic>? _payments = widget.data;

    void addItem() async {
      final newPayment = await Navigator.of(context).push<Payment>(
        MaterialPageRoute(
          builder: (ctx) => const NewPayment(),
        )
      );

      print("<!-- newPament @ addItem -->");
      print(newPayment);

      if (newPayment == null) {
        return; 
      }

      ref.read(fullDataProvider.notifier).addPayment(newPayment);

      //_payments!.add(newPayment);

      setState(() {
        _payments = [...?_payments, newPayment];
      });
    }

    return Scaffold(
      body: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addItem,
          ),
          DataTable(
            columns: getDataColumns([
              "Amount",
              "Date",
              "Recipient",
              "Category",
              "Method"
            ]),
            //rows: getDataTable(fullData["payments"]),
            rows: <DataRow> [
              if (_payments != null) 
                for (final payment in _payments!)
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            payment.amount.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                        DataCell(
                          Text(
                            payment.readDate(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                        DataCell(
                          Text(
                            payment.recipient,
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                        DataCell(
                          Text(
                            payment.category!.name,
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                        DataCell(
                          Text(
                            payment.paymentMethod!.name,
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                      ],
                    )
              ],
          )
        ]
      )
    );
  }
}