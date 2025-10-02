import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});
  @override State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _controller = TextEditingController();
  @override Widget build(BuildContext context) {
    final fs = Provider.of<FirestoreService>(context);
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(children: [
        Expanded(child: StreamBuilder(stream: fs.streamComments(widget.postId), builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final comments = snapshot.data as List;
          return ListView.builder(itemCount: comments.length, itemBuilder: (context, i) {
            final c = comments[i];
            return ListTile(title: Text(c['text'] ?? ''), subtitle: Text(c['authorId'] ?? ''));
          });
        })),
        Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [
          Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Write a comment'))),
          IconButton(icon: const Icon(Icons.send), onPressed: () async {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            await fs.addComment(widget.postId, auth.user?.uid ?? 'anon', text);
            _controller.clear();
          })
        ]))
      ]),
    );
  }
}
