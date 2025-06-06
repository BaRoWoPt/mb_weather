import 'package:flutter/material.dart';

import '../../../features/search/view/customsearch.dart';

// Appbar which Contains the search icon as the leading and list icon as the trailing/actions
AppBar appBar(BuildContext context) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.search_rounded),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCity()),
          );
        },
      ),
    ),
    backgroundColor: Colors.transparent,
  );
}
