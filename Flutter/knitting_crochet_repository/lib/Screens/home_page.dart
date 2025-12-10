import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knitting_crochet_repository/Notifiers/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'search_delegate.dart';
import '../Notifiers/theme_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: 32,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text(
                'My Collections',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: 24,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/MyCollectionsPage'),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Theme.of(context).textTheme.titleLarge!.color),
              title: Text(
                'User Settings',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: 24,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/UserSettingsPage'),
            ),
            SwitchListTile(
              title: Text(
                'High Contrast',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: 24,
                ),
              ),
              value: Provider.of<ThemeNotifier>(context).isHighContrast,
              onChanged: (bool newValue) {
                themeNotifier.toggleTheme();
              },
            ),

            Divider(),

            // ⭐ LOGOUT BUTTON
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);

                final auth = Provider.of<AuthNotifier>(context, listen: false);
                await auth.signOut();

                Navigator.pushReplacementNamed(context, '/LoginPage');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("Featured"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          ),
        ],
      ),

      // ⭐ Floating Create Post Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/MakePostPage');
        },
        child: Icon(Icons.add),
      ),

      // ⭐⭐⭐ HOME SCREEN POSTS LIST
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts available"));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data();
              final postId = posts[index].id;

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⭐ Author + Difficulty Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post['author'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              post['difficulty'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // ⭐ Post Text
                      Text(
                        post['post_text'] ?? '',
                        style: TextStyle(fontSize: 16),
                      ),

                      SizedBox(height: 12),

                      // ⭐ Tags
                      Wrap(
                        spacing: 6,
                        children:
                        (post['tags'] as List<dynamic>).map((tag) {
                          return Chip(
                            label: Text(tag.toString()),
                            backgroundColor: Colors.purple.withOpacity(0.2),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 12),

                      // ⭐ Likes + Comments Counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.red),
                              SizedBox(width: 4),
                              Text(post['likes'].toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.comment, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(post['comment_count'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}