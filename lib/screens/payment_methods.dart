import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment_method.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/widgets/new_payment_method.dart';

// ignore: must_be_immutable
class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  List<PaymentMethod> _localPaymentMethods = [];
  
  @override
  void initState() {
    super.initState();
  }

  void addPaymentMethod() async {
    final newPaymentMethod = await Navigator.of(context).push<PaymentMethod>(
      MaterialPageRoute(
        builder: (ctx) => const NewPaymentMethod(),
      )
    );

    if (newPaymentMethod == null) {
      return; 
    }

    ref.read(paymentMethodProvider.notifier).addPaymentMethod(newPaymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    _localPaymentMethods = ref.watch(paymentMethodProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addPaymentMethod,
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
                  title: Text(_localPaymentMethods[index].name),
                );
              },
              childCount: _localPaymentMethods.length
            ),
          ),
        ],
      )
    );
  }
}