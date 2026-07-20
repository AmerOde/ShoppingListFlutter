import 'package:flutter/foundation.dart' hide Category;
import 'package:shopping_list_app_flutter/data/category.dart';
import 'package:shopping_list_app_flutter/model/categories.dart';
class GroceryItem {

  const GroceryItem({required this.id,
    required this.name,
    required this.quantity,
    required this.category
  });


  final String id ;
  final  String name;
  final double quantity;
  final   Category category;
}