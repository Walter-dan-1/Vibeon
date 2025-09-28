import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/post_model.dart';
import '../core/models/comment_model.dart';
import '../core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create user doc
  Future<void> createUserIfNotExist(UserModel user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set(user.toMap());
    }
  }

  // create post metadata
  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').doc(post.id).set(post.toMap());
  }

  // stream posts for feed (ordered by trending: likes desc, then views desc, then date)
  Stream<List<PostModel>> streamTrendingPosts() {
    return _db.collection('posts')
      .orderBy('likes', descending: true)
      .orderBy('views', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => PostModel.fromMap(d.data()..['id']=d.id)).toList());
  }

  // stream posts by user
  Stream<List<PostModel>> streamPostsByUser(String uid) {
    return _db.collection('posts').where('ownerId', isEqualTo: uid).orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => PostModel.fromMap(d.data()..['id']=d.id)).toList());
  }

  // like/unlike
  Future<void> toggleLike(String postId, String userId) async {
    final likeRef = _db.collection('posts').doc(postId).collection('likes').doc(userId);
    final postRef = _db.collection('posts').doc(postId);
    final exists = (await likeRef.get()).exists;
    if (exists) {
      await likeRef.delete();
      await postRef.update({'likes': FieldValue.increment(-1)});
    } else {
      await likeRef.set({'userId': userId, 'createdAt': DateTime.now().toUtc().toIso8601String()});
      await postRef.update({'likes': FieldValue.increment(1)});
    }
  }

  // check if user liked a post
  Future<bool> isLiked(String postId, String userId) async {
    final likeRef = _db.collection('posts').doc(postId).collection('likes').doc(userId);
    return (await likeRef.get()).exists;
  }

  // add comment
  Future<void> addComment(CommentModel comment) async {
    final ref = _db.collection('posts').doc(comment.postId).collection('comments').doc();
    await ref.set(comment.toMap());
    // increment comment count on post (optional separate field)
  }

  // stream comments for a post
  Stream<List<CommentModel>> streamComments(String postId) {
    return _db.collection('posts').doc(postId).collection('comments').orderBy('createdAt', descending: false)
      .snapshots()
      .map((snap) => snap.docs.map((d) => CommentModel.fromMap(d.data()..['id']=d.id)).toList());
  }

  // follow/unfollow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    final followRef = _db.collection('users').doc(currentUid).collection('following').doc(targetUid);
    final followerRef = _db.collection('users').doc(targetUid).collection('followers').doc(currentUid);
    final exists = (await followRef.get()).exists;
    if (exists) {
      await followRef.delete();
      await followerRef.delete();
      await _db.collection('users').doc(currentUid).update({'following': FieldValue.increment(-1)});
      await _db.collection('users').doc(targetUid).update({'followers': FieldValue.increment(-1)});
    } else {
      await followRef.set({'uid': targetUid});
      await followerRef.set({'uid': currentUid});
      await _db.collection('users').doc(currentUid).update({'following': FieldValue.increment(1)});
      await _db.collection('users').doc(targetUid).update({'followers': FieldValue.increment(1)});
    }
  }

  // increment view counter
  Future<void> incrementView(String postId) async {
    await _db.collection('posts').doc(postId).update({'views': FieldValue.increment(1)});
  }
}
