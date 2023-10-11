import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/full_data_provider.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, List<dynamic>> fullData = ref.watch(fullDataProvider);

    print("<!-- payments on widget rebuild -->");
    print(fullData["payments"]);
    print("<!---->");

    void addItem() async {
      final newPayment = await Navigator.of(context).push<Payment>(
        MaterialPageRoute(
          builder: (ctx) => const NewPayment(),
        )
      );

      if (newPayment == null) {
        return; 
      }

      final gotCategory = ref.read(fullDataProvider.notifier).getCategoryById(newPayment.categoryId);
      final gotPaymentMethod = ref.read(fullDataProvider.notifier).getPaymentMethodById(newPayment.paymentMethodId);
      newPayment.setCategory(gotCategory);
      newPayment.setPaymentMethod(gotPaymentMethod);

      print("<!-- newPayment after Update -->");
      print(newPayment);
      print("<!---->");

      ref.read(fullDataProvider.notifier).addPayment(newPayment);
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
            rows: <DataRow> [
              if (fullData.entries.isNotEmpty) 
                for (final payment in fullData["payments"]!)
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
                            payment.category.name,
                            style: const TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic
                            ),
                          )
                        ),
                        DataCell(
                          Text(
                            payment.paymentMethod.name,
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