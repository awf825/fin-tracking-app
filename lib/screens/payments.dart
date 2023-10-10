import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({
    super.key, 
    this.data = const []
  });

  final List<Payment> ?data;

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

  List<DataRow> getDataTable() {
    List<DataRow> rows = [];
    if (data != null) {
      for (var d in data!) {
        rows.add(
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    d.amount.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
                ),
                DataCell(
                  Text(
                    d.readDate(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
                ),
                DataCell(
                  Text(
                    d.recipient,
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
                ),
                DataCell(
                  Text(
                    d.category!.name,
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
                ),
                DataCell(
                  Text(
                    d.paymentMethod!.name,
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
                ),
              ],
            )
          );
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    void addItem() async {
      final newItem = await Navigator.of(context).push<Payment>(
        MaterialPageRoute(
          builder: (ctx) => const NewPayment(),
        )
      );

      if (newItem == null) {
        return; 
      }

      // may actually need this when this becomes staeful

      // setState(() {
      //   data?.add(newItem);
      // });
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
            rows: getDataTable(),
          )
        ]
      )
    );
  }
}