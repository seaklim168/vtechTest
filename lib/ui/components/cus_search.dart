import 'package:flutter/material.dart';
import 'package:vtech_test/model/item_model.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<ItemModel> list;

  CustomSearchDelegate({required this.list});

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<ItemModel> matchQuery = [];
    for (var item in list) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return matchQuery.isNotEmpty
        ? ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return ListTile(
                title: DynamicTextHighlighting(
                  text: result.title ?? '',
                  highlights: [query],
                  color: Colors.yellow,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      decoration: (result.isCompleted ?? false)
                          ? TextDecoration.lineThrough
                          : null),
                  caseSensitive: false,
                ),
              );
            },
          )
        : Center(child: Text("No result, Create new one instead"));
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// show all records
  @override
  Widget buildResults(BuildContext context) {
    List<ItemModel> matchQuery = [];
    for (var item in list) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];

        return ListTile(
          title: Text(result.title ?? ''),
        );
      },
    );
  }
}
