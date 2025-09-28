class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int followers;
  final int following;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.followers = 0,
    this.following = 0,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'followers': followers,
    'following': following,
  };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    uid: m['uid'],
    email: m['email'],
    displayName: m['displayName'],
    photoUrl: m['photoUrl'],
    followers: m['followers'] ?? 0,
    following: m['following'] ?? 0,
  );
}
