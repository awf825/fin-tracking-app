import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/providers/category_provider.dart';
import 'package:payment_tracking/widgets/new_category.dart';
import 'package:payment_tracking/widgets/new_payment.dart';

// ignore: must_be_immutable
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  List<Category> _localCategories = [];
  
  @override
  void initState() {
    super.initState();
  }

  void addCategory() async {
    final newCategory = await Navigator.of(context).push<Category>(
      MaterialPageRoute(
        builder: (ctx) => const NewCategory(),
      )
    );

    if (newCategory == null) {
      return; 
    }

    ref.read(categoryProvider.notifier).addCategory(newCategory);
  }

  @override
  Widget build(BuildContext context) {
    _localCategories = ref.watch(categoryProvider);
      // Don't worry about displaying progress or error indicators on screen; the 
      // package takes care of that. If you want to customize them, use the 
      // [PagedChildBuilderDelegate] properties.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addCategory,
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
                  title: Text(_localCategories[index].name),
                  subtitle: Text(_localCategories[index].description),
                );
              },
              childCount: _localCategories.length
            ),
          ),
        ],
      )
    );
  }
}