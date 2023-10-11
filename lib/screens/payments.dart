import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/providers/full_data_provider.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  PaymentsScreen({
    super.key,
    required this.data
  });

  List<Payment> data;

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  static const _pageSize = 20;

  final PagingController<int, Payment> _pagingController = PagingController(firstPageKey: 0);
  
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    print("<!-- initDState  -->");

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    print("<!-- _fetchPage  -->");
    try {
      Map<String, List<dynamic>> fullData = await ref.read(fullDataProvider);
      print("<!-- fullData  -->");
      print(fullData);
      print("<!---->");
      final payments = fullData["payments"] as List<Payment>;
      final newItems = payments.length < _pageSize ? 
        payments.sublist(pageKey, payments.length) : 
        payments.sublist(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

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

  @override
  Widget build(BuildContext context) {
      // Don't worry about displaying progress or error indicators on screen; the 
      // package takes care of that. If you want to customize them, use the 
      // [PagedChildBuilderDelegate] properties.
    return PagedListView<int, Payment>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Payment>(
        itemBuilder: (context, item, index) => ListTile(
          leading: Text(item.paymentMethod!.name),
          title: Text(item.recipient),
          subtitle: Text(item.category!.name),
          trailing: Text(item.amount.toString())
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

}