import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import '../../feed/presentation/video_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final fs = Provider.of<FirestoreService>(context, listen: false);
    final uid = auth.user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 48, child: Text(auth.user?.displayName != null ? auth.user!.displayName![0] : '?')),
            const SizedBox(height: 8),
            Text(auth.user?.displayName ?? 'Anonymous', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => auth.signOut(), child: const Text('Logout')),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: fs.streamPostsByUser(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) return const Center(child: Text('No uploads yet'));
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
            )
          ],
        ),
      ),
    );
  }
}
