import 'package:cross_file/cross_file.dart';

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.fullname,
    this.email,
    this.telephone,
    this.picture,
    this.pictureFile,
    this.emailVerifiedAt,
    this.language,
    this.artistId,
    this.source,
    this.token,
    this.password,
    this.passwordConf,
    this.code,
    this.followingCount,
    this.followersCount,
    this.followedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      picture: json['picture'] as String?,
      source: json['source'] as String?,
      artistId: json['artist_id'] as int?,
      language: json['language'] as String?,
      telephone: json['telephone'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      token: json['token'] as String?,
      followingCount: json['following_count'] as int?,
      followersCount: json['followers_count'] as int?,
      followedAt: json['followed_at'] as String?,
    );
  }

  int? id;
  String? firstname;
  String? lastname;
  String? fullname;
  String? email;
  String? telephone;
  String? picture;
  XFile? pictureFile;
  String? emailVerifiedAt;
  String? token;
  String? source;
  String? password;
  String? passwordConf;
  String? code;
  int? artistId;
  String? language;
  int? followingCount;
  int? followersCount;
  String? followedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'picture': picture,
        'source': source,
        'telephone': telephone,
        'email_verified_at': emailVerifiedAt,
        'language': language,
        'artist_id': artistId,
        'token': token,
        'following_count': followingCount,
        'followers_count': followersCount,
        'followed_at': followedAt,
      };
}
