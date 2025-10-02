import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/models/post_model.dart';
import 'package:provider/provider.dart';
import '../../../services/firestore_service.dart';
import 'comments_screen.dart';

class VideoCard extends StatefulWidget {
  final PostModel post;
  const VideoCard({super.key, required this.post});
  @override State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;
  bool _liked = false;
  @override void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.mediaUrl)..initialize().then((_) { setState((){}); _controller?.setLooping(true); _controller?.play(); });
  }
  @override void dispose() { _controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final fs = Provider.of<FirestoreService>(context, listen: false);
    return Card(margin: const EdgeInsets.all(12), child: Column(children: [
      if (_controller!=null && _controller!.value.isInitialized) AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!)) else const SizedBox(height:200, child: Center(child: Icon(Icons.play_circle_outline,size:64))),
      ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(widget.post.caption), subtitle: Text('Likes: \${widget.post.likes} • Views: \${widget.post.views}'), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: Icon(_liked? Icons.favorite: Icons.favorite_border, color: _liked? Colors.red:null), onPressed: () async { try { await fs.toggleLike(widget.post.id, ''); setState(()=>_liked=!_liked);} catch(_){} }),
        IconButton(icon: const Icon(Icons.comment), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommentsScreen(postId: widget.post.id)))),
      ]))
    ]));
  }
}
