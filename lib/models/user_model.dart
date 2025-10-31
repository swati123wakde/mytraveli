class UserModel {
  final String id;
  final String? displayName;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.id,
    this.displayName,
    required this.email,
    this.photoUrl,
  });

  factory UserModel.fromGoogleSignIn(dynamic account) {
    return UserModel(
      id: account.id,
      displayName: account.displayName,
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }
}
