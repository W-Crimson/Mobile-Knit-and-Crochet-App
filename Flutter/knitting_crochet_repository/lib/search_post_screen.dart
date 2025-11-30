import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPostsScreen extends StatefulWidget {
  const SearchPostsScreen({super.key});

  @override
  State<SearchPostsScreen> createState() => _SearchPostsScreenState();
}

class _SearchPostsScreenState extends State<SearchPostsScreen> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                searchQuery = "";
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by post title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
          ),

          // Search results from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchQuery.isEmpty)
                  // Show recent posts if no search query
                  ? FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .limit(10)
                      .snapshots()
                  // Filter posts by title
                  : FirebaseFirestore.instance
                      .collection('posts')
                      .where('title', isGreaterThanOrEqualTo: searchQuery)
                      .where('title', isLessThanOrEqualTo: "$searchQuery\uf8ff")
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts found.'));
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          post['title'] ?? 'Untitled',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          post['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          post['author'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          // Optional: Navigate to full post view
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
