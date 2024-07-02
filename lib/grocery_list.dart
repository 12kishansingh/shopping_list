import 'package:flutter/material.dart';
import 'package:shopping_list/categories.dart';
//import 'package:shopping_list/dummy_items.dart';
//import 'package:shopping_list/dummy_items.dart';// can delete the entire file if you want
import 'package:shopping_list/new_item.dart';
import 'package:shopping_list/grocery_item.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

// class GroceryList extends StatefulWidget {
//   const GroceryList({super.key});

//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }

// class _GroceryListState extends State<GroceryList> {
//   List<GroceryItem> _groceryItems = [];

//   //var _isLoading = true;
//   String? _error;
//   late Future<List<GroceryItem>> _loadedItems;
//   @override
//   void initState() {
//     super.initState();
//     _loadedItems = _loadItems();
//   }

//   Future<List<GroceryItem>> _loadItems() async {
//     final url = Uri.https(
//         'flutter-app-97b04-default-rtdb.firebaseio.com', 'shopping-list.json');

// //try{

//     final response = await http.get(url);
//     if (response.statusCode >= 400) {
//       // setState(() {
//       //   _error = 'Failed to fetch data.Please try again later.';
//       // });
//       throw Exception('');
//     }

//     if (response.body == 'null') {
//       // firebase return null string
//       // setState(() {
//       //   _isLoading=false;
//       // });
//       return [];
//     }
//     final Map<String, dynamic> listdata = json.decode(response.body);
//     final List<GroceryItem> loadedItems = [];
//     for (final item in listdata.entries) {
//       final category = categories.entries
//           .firstWhere(
//               (catItem) => catItem.value.title == item.value['category'])
//           .value;
//       loadedItems.add(
//         GroceryItem(
//           id: item.key,
//           name: item.value['name'],
//           quantity: item.value['quantity'],
//           category: category,
//         ),
//       );
//     }
//     // setState(() {
//     //   _groceryItems = loadedItems;
//     //   _isLoading = false;
//     // });
//     return loadedItems;

// // catch (error){
// //    setState(() {
// //         _error = 'Something went wrong!Please try again later.';
// //       });

// // }
//   }
// // to check if something went wrong
// //print(response.statusCode);
// //throw Exception('An error occured!');

//   void _addItem() async {
//     final newItem = await Navigator.of(context).push<GroceryItem>(
//       MaterialPageRoute(
//         builder: (ctx) => const NewItem(),
//       ),
//     );

//     if (newItem == null) {
//       return;
//     }
//     setState(() {
//       _groceryItems.add(newItem);
//     });
//     // _loadItems();
//   }

//   void _removeItem(GroceryItem item) async {
//     final index = _groceryItems.indexOf(item);
//     setState(() {
//       _groceryItems.remove(item);
//     });
//     final url = Uri.https('flutter-app-97b04-default-rtdb.firebaseio.com',
//         'shopping-list/${item.id}.json'); // pointed at specific item to be deleted
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       setState(() {
//         _groceryItems.insert(index, item); //add at specific index
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Widget content = const Center(
//     //   child: Text('no items added yet.'),
//     // );
//     // if (_isLoading) {
//     //   content = const Center(child: CircularProgressIndicator());
//     // }

//     // if (_groceryItems.isNotEmpty) {
//     //   content =
//     // }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('your groceries'),
//         actions: [
//           IconButton(
//             onPressed: _addItem,
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _loadedItems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 snapshot.error.toString(),
//               ),
//             );
//           }
          
//           if (snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('no items added yet.'),
//             );
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (ctx, index) => Dismissible(
//               onDismissed: (didChange) {
//                 _removeItem(snapshot.data![index]);
//               },
//               key: ValueKey(snapshot.data![index].id),
//               child: ListTile(
//                 title: Text(snapshot.data![index].name),
//                 leading: Container(
//                   width: 24,
//                   height: 24,
//                   color: snapshot.data![index].category.color,
//                 ),
//                 trailing: Text(
//                   snapshot.data![index].quantity.toString(),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-default-rtdb.firebaseio.com', 'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
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