import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  
  // Dummy data to search through
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Pear",
    "Watermelon",
    "Oranges",
    "Blueberries",
    "Strawberries",
    "Raspberries",
  ];

  // 1. Build the "Clear" (X) button on the right
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search bar text
        },
      ),
    ];
  }

  // 2. Build the "Back" arrow on the left
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search, return nothing
      },
    );
  }

  // 3. Show Results (What appears when user hits "Enter")
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // 4. Show Suggestions (What appears while typing)
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result; // Fill the search bar with this suggestion
            showResults(context); // Force show results
          },
        );
      },
    );
  }
}