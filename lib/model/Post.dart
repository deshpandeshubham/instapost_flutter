class Post {
  String email;
  String password;
  String text;
  List hashtags;

  Post({this.email, this.password, this.text, this.hashtags});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      email : json['email'],
      password : json['password'],
      text : json['text'],
      hashtags:json['hashtag'],
    );
  }

  String toString() {
    return "Post($email)";
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'password' : password,
    'text': text,
    'hashtags': hashtags,
  };
}