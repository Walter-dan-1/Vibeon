import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/firestore_service.dart';
import '../../feed/presentation/video_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = Provider.of<FirestoreService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('For You'),
        actions: [
          IconButton(onPressed: () {
            final theme = Provider.of<ThemeNotifier>(context, listen: false);
            theme.toggle();
          }, icon: const Icon(Icons.brightness_6))
        ],
      ),
      body: StreamBuilder(
        stream: fs.streamTrendingPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text('No posts yet'));
          }
          final posts = snapshot.data as List;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final p = posts[i];
              return VideoCard(post: p);
            },
          );
        },
      ),
    );
  }
}
