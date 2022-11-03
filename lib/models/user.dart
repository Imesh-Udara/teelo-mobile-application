class User {
  final String email;
  final String uid;
  final String imageUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.imageUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": imageUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
