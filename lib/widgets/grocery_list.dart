import 'package:flutter/material.dart';
import 'package:shopping_list_app_flutter/data/category.dart';
import 'package:shopping_list_app_flutter/model/grocery_item.dart';
import 'package:shopping_list_app_flutter/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../data/dummy_items.dart';
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryItems = [];
  List<GroceryItem> _loadedItems = [];
  bool _isLoading = true;

  String ?_error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");

    _loadItem();
  }

  void _loadItem() async {
    _loadedItems.clear();

    final url = Uri.https(
      "flutter-prep-cafcb-default-rtdb.firebaseio.com",
      "shopping-list.json",
    );

    final response = await http.get(url);

    if(response.statusCode>400){
      setState(() {
        _error = " Failed to fetch data . Please try again later .";
      });
    }
    final data = json.decode(response.body);
    await Future.delayed(const Duration(seconds: 1)); // للتجربة فقط

    if (data == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = data;

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;
      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      groceryItems = _loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItemState()));

    if(newItem ==null)
      return;
    setState(() {
  groceryItems.add(newItem);
    });
    // if (item == null) {
    //   return;
    // } else {
    //   setState(() {
    //     groceryItems.add(item);
    //   });
    // }
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (groceryItems.isEmpty) {
      content = const Center(
        child: Text("The List is Empty!"),
      );
    } else {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(groceryItems[index]);
          },
          child: ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
      if(_error!=null){
        content = Center(child: Text(_error!),);
      }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
