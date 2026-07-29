import 'package:flutter/material.dart';
import 'package:shopping_list_app_flutter/data/category.dart';
import 'package:shopping_list_app_flutter/model/categories.dart';
import 'package:shopping_list_app_flutter/widgets/grocery_list.dart';
import 'package:http/http.dart' as http;

import '../model/grocery_item.dart';
import 'dart:convert';

class NewItemState extends StatefulWidget {
  const NewItemState({super.key});

  @override
  State<NewItemState> createState() => _NewItemState();
}

class _NewItemState extends State<NewItemState> {

  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredQuantity = 1;

  var _selectedCategory = categories[Categories.vegetables]!;


  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https("flutter-prep-cafcb-default-rtdb.firebaseio.com",
          "shopping-list.json");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': double.parse(_enteredQuantity.toString()),
          'category': _selectedCategory.title, // أو أي قيمة تريد إرسالها
        }),
      );


        print(response.body);
        print(response.statusCode);
        if(!context.mounted){
          return;
      }

        Navigator.pop(context);
      // Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: double.parse(_enteredQuantity.toString()),
      //     category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                onSaved: (value) {
                  _enteredName = value.toString();
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value
                          .trim()
                          .isEmpty ||
                      value
                          .trim()
                          .length > 50) {
                    return 'Please enter a valid name.';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',

                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '1',

                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                      validator: (value) {
                        if (value == null ||
                            value
                                .trim()
                                .isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0

                        ) {
                          return 'Must be a valid , positive number .';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem<Category>(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 8),
                                Text(category.value.title.toString()),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {
                    _formKey.currentState!.reset();
                  }, child: Text("Reset")),
                  ElevatedButton(onPressed: _saveItem,
                      child: Text("Add Item"))
                ],)
            ],
          ),
        ),
      ),
    );
  }
}