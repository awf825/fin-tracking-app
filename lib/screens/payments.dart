import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/providers/payment_method_provider.dart';
import 'package:payment_tracking/providers/payment_provider.dart';
<<<<<<< HEAD
=======
import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
import 'package:payment_tracking/providers/plaid/plaid_transactions_provider.dart';
import 'package:payment_tracking/services/auth_service.dart';
>>>>>>> 13a5610 (adding google sign in with pretty button. adding logout function)
import 'package:payment_tracking/widgets/edit_payment.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

// ignore: must_be_immutable
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _authService = AuthService();

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

  void editPayment(Payment payment) async {
    final updatedPayment = await Navigator.of(context).push<Payment>(
      MaterialPageRoute(
        builder: (ctx) => EditPayment(
          payment: payment
        ),
      )
    );

    if (updatedPayment == null) {
      return; 
    }

    final gotCategory = ref.read(categoryProvider.notifier).getById(updatedPayment.categoryId);
    final gotPaymentMethod = ref.read(paymentMethodProvider.notifier).getById(updatedPayment.paymentMethodId);
    updatedPayment.setCategory(gotCategory);
    updatedPayment.setPaymentMethod(gotPaymentMethod);
    ref.read(paymentProvider.notifier).updatePayment(updatedPayment);
  }

  ExpansionTile _buildExpansionTile(Payment p) {
    final GlobalKey expansionTileKey = GlobalKey();
    // final Payment payment = _localPayments[index];
    return ExpansionTile(
      key: expansionTileKey,
      title: ListTile(
        leading: Text(p.paymentMethod!.name),
        title: Text(p.recipient)
      ),
      
      // Text('My expansion tile $index'),
      children: <Widget>[
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => editPayment(p),
          ),
          title: Text(p.category!.name),
          subtitle: Text(p.readDate()),
          trailing: Text(p.readAmount()),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Payment> _localPayments = ref.watch(paymentProvider);
    _localPayments.sort((a,b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
          leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _authService.logOut,
        ),
      ),
      body: _localPayments.isNotEmpty ? 
        ListView.builder(
          controller: _scrollController,
          itemCount: _localPayments.length,
          itemBuilder: (BuildContext context, int index) => _buildExpansionTile(_localPayments[index]),
        ) :
        const Text('LOADING'),      
    );
  }
}