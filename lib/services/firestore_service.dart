import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/post_model.dart';
import '../core/models/comment_model.dart';
import '../core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserIfNotExist(UserModel user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) await ref.set(user.toMap());
  }

  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').doc(post.id).set(post.toMap());
  }

  Stream<List<PostModel>> streamTrendingPosts() {
    return _db.collection('posts').orderBy('likes', descending: true).orderBy('views', descending: true).snapshots().map((snap) => snap.docs.map((d){ final data = Map<String,dynamic>.from(d.data() as Map); data['id']=d.id; return PostModel.fromMap(data); }).toList());
  }

  Future<void> toggleLike(String postId, String userId) async {
    final likeRef = _db.collection('posts').doc(postId).collection('likes').doc(userId);
    final postRef = _db.collection('posts').doc(postId);
    final exists = (await likeRef.get()).exists;
    if (exists) { await likeRef.delete(); await postRef.update({'likes': FieldValue.increment(-1)}); } else { await likeRef.set({'userId': userId, 'createdAt': DateTime.now().toUtc().toIso8601String()}); await postRef.update({'likes': FieldValue.increment(1)}); }
  }

  Future<bool> isLiked(String postId, String userId) async {
    final likeRef = _db.collection('posts').doc(postId).collection('likes').doc(userId);
    return (await likeRef.get()).exists;
  }

  Future<void> addComment(String postId, String authorId, String text) async {
    final ref = _db.collection('posts').doc(postId).collection('comments').doc();
    await ref.set({'id': ref.id, 'postId': postId, 'authorId': authorId, 'text': text, 'createdAt': DateTime.now().toUtc().toIso8601String()});
  }

  Stream<List<dynamic>> streamComments(String postId) {
    return _db.collection('posts').doc(postId).collection('comments').orderBy('createdAt', descending: false).snapshots().map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
