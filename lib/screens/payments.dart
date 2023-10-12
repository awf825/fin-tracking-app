import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/providers/payment_provider.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

// ignore: must_be_immutable
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  List<Payment> _localPayments = [];
  
  @override
  void initState() {
    super.initState();
  }

  void addPayment() async {
    final newPayment = await Navigator.of(context).push<Payment>(
      MaterialPageRoute(
        builder: (ctx) => const NewPayment(),
      )
    );

    if (newPayment == null) {
      return; 
    }

    final gotCategory = ref.read(categoryProvider.notifier).getById(newPayment.categoryId);
    final gotPaymentMethod = ref.read(paymentMethodProvider.notifier).getById(newPayment.paymentMethodId);
    newPayment.setCategory(gotCategory);
    newPayment.setPaymentMethod(gotPaymentMethod);
    ref.read(paymentProvider.notifier).addPayment(newPayment);
  }

  @override
  Widget build(BuildContext context) {
    _localPayments = ref.watch(paymentProvider);
      // Don't worry about displaying progress or error indicators on screen; the 
      // package takes care of that. If you want to customize them, use the 
      // [PagedChildBuilderDelegate] properties.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addPayment,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // const SliverAppBar(
          //   pinned: true,
          //   expandedHeight: 250.0,
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text('Demo'),
          //   ),
          // ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  leading: Text(_localPayments[index].paymentMethod!.name),
                  title: Text(_localPayments[index].recipient),
                  subtitle: Text(_localPayments[index].category!.name),
                  trailing: Text(_localPayments[index].amount.toString())
                );
              },
              childCount: _localPayments.length
            ),
          ),
        ],
      )
    );
  }
}