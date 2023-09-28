import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:shopping_app/data/categories.dart';
// import 'package:shopping_app/models/category.dart';
// import 'package:shopping_app/models/grocery_item.dart';
// import 'package:http/http.dart' as http;

class NewCategory extends StatefulWidget {
  const NewCategory({
    super.key
  });

  @override
  State<StatefulWidget> createState() {
    return _NewCategoryState();
  }
}

class _NewCategoryState extends State<NewCategory> {
  // final _formKey = GlobalKey<FormState>();
  // var _enteredName = '';
  // var _enteredQuantity = 1;
  // var _selectedCategory = categories[Categories.vegetables]!;
  // var _isSending = false;

  // void _saveItem() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     setState(() {
  //       _isSending = true;
  //     });
  //     final url = Uri.https(
  //       'flutter-prep-3abdd-default-rtdb.firebaseio.com', 
  //       'shopping-list.json'
  //     );
  //     final response = await http.post(
  //       url, 
  //       headers: {
  //         'Content-Type': 'application/json',
  //       }, 
  //       body: json.encode(
  //         {
  //           'name': _enteredName, 
  //           'quantity': _enteredQuantity, 
  //           'category': _selectedCategory.title
  //         },
  //       )
  //     );

  //     final Map<String, dynamic> resData = json.decode(response.body);

  //     if (!mounted) { // i.e !context.mounted
  //       return;
  //     }

  //     Navigator.of(context).pop(
  //       GroceryItem(
  //         id: resData['name'], 
  //         name: _enteredName, 
  //         quantity: _enteredQuantity, 
  //         category: _selectedCategory
  //       )
  //     );
  //   } 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new category'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: Text("HELLO TEXT NEW CATEGORY FORM"),
        // child: Form(
        //   key: _formKey,
        //   child: Column(
        //     children: [
        //       TextFormField(
        //         maxLength: 50,
        //         decoration: const InputDecoration(
        //           label: Text('Name')
        //         ),
        //         initialValue: _enteredName,
        //         validator: (value) {
        //           if (
        //             value == null || 
        //             value.isEmpty || 
        //             value.trim().length <= 1 || 
        //             value.trim().length > 50
        //           ) {
        //             return 'Must be between 1 and 50 characters.';
        //           }
        //           return null;
        //         },
        //         onSaved: (value) {
        //           _enteredName = value!;
        //         }
        //       ), // instead of textfield!
        //       Row(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Expanded(
        //             child: TextFormField(
        //               decoration: const InputDecoration(
        //                 label: Text('Quantity')
        //               ),
        //               keyboardType: TextInputType.number,
        //               initialValue: _enteredQuantity.toString(),
        //               validator: (value) {
        //                 if (
        //                   value == null || 
        //                   value.isEmpty || 
        //                   int.tryParse(value) == null || 
        //                   int.tryParse(value)! <= 0
        //                 ) {
        //                   return 'Must be a valid positive number.';
        //                 }
        //                 return null;
        //               },
        //               onSaved: (value) {
        //                 _enteredQuantity = int.parse(value!);
        //               },
        //             ),
        //           ),
        //           const SizedBox(width: 8),
        //           Expanded(
        //             child: DropdownButtonFormField(
        //               value: _selectedCategory,
        //               items: [
        //                 // can't loop through a map (categories), need to specify categories.entries
        //                 for (final category in categories.entries) 
        //                   DropdownMenuItem(
        //                     value: category.value,
        //                     child: Row(
        //                       children: [
        //                         Container(
        //                           width: 16,
        //                           height: 16,
        //                           color: category.value.color
        //                         ),
        //                         const SizedBox(width: 6),
        //                         Text(category.value.title)
        //                       ]
        //                     )
        //                   )
        //               ],
        //               onChanged: (value) {
        //                 // need to use setState here because to display the _selectedCategory in the UI, we need 
        //                 // to keep track of a local state. This is also why we don't need onSaved on this dropdown
        //                 setState(() {
        //                   _selectedCategory = value!;
        //                 });
        //               },
        //             ),
        //           )
        //         ],
        //       ),
        //       const SizedBox(height: 12),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end, // make sure row content is pushed all the way to the right
        //         children: [
        //           // setting TextButton's onPressed to null will disable the button
        //           TextButton(
        //             onPressed: _isSending ? null : () {
        //               _formKey.currentState!.reset();
        //             }, 
        //             child: const Text('Reset')
        //           ),
        //           ElevatedButton(
        //             onPressed: _isSending ? null : _saveItem, 
        //             child: _isSending 
        //               ? const SizedBox(
        //                 height: 16, 
        //                 width: 16, 
        //                 child: CircularProgressIndicator()
        //               ) : const Text('Add Item')
        //           )
        //         ],
        //       )
        //     ],
        //   ),
        // ),
      )
    );
  }
}