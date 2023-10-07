import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/income_stream.dart';
import 'package:payment_tracking/widgets/new_category.dart';

class StreamsScreen extends StatelessWidget {
  const StreamsScreen({
    super.key, 
    this.data,
  });

  final List<IncomeStream> ?data;

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
                    d.institution, 
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic
                    ),
                  )
              ),
              DataCell(
                Text(
                  d.name,
                  style: const TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic
                  ),
                )
              ),
              DataCell(
                Text(
                  d.monthlyTotal.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic
                  ),
                )
              ),
              DataCell(
                Text(
                  d.yearlyTotal.toString(),
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
      final newItem = await Navigator.of(context).push<Category>(
        MaterialPageRoute(
          builder: (ctx) => const NewCategory(),
        )
      );

      if (newItem == null) {
        return; 
      }

      // may actually need this when this becomes staeful

      // setState(() {
      //   _payments.add(newItem);
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
            columns: getDataColumns(['Institution', 'Name', 'Monthly Total', 'Yearly Total']),
            rows: getDataTable(),
          )
        ]
      )
    );
  }
}