import 'package:flutter/material.dart';
import 'package:shopping_list_app_flutter/model/grocery_item.dart';
import 'package:shopping_list_app_flutter/widgets/new_item.dart';

import '../data/dummy_items.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryItems = [];

  void _addItem() async {
    final item = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItemState()));

    if(item ==null) {
       return;
    }else{
      setState(() {
        groceryItems.add(item);

      });
    }
  }
  
  void _removeItem(GroceryItem item){
    setState(() {
      groceryItems.remove(item);


    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("The List is Empty!"),);
    if(groceryItems.isNotEmpty){
      content =ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(groceryItems[index].id),
            onDismissed:(direction){_removeItem(groceryItems[index]);} ,
            child: ListTile(
                title: Text(groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: groceryItems[index].category.color,
                ),
                trailing: Text(groceryItems[index].quantity.toString())),
          ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body:content

    );
  }
}
