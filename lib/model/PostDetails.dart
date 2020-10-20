class PostDetails {
  List comments;
  int ratingsCount;
  dynamic ratingsAvg;
  int postId;
  List hashTags;
  int imageId;
  String postText;

  PostDetails({this.comments, this.ratingsCount, this.ratingsAvg,this.postId,this.hashTags,this.imageId,this.postText});

  factory PostDetails.fromJson(Map<String, dynamic> json) {
    return PostDetails (
      comments: json['comments'],
      ratingsCount: json['ratings-count'],
      ratingsAvg: json['ratings-average'],
      postId: json['id'],
      hashTags: json['hashtags'],
      imageId: json['image'],
      postText: json['text']
    );
  }

  Map<String, dynamic> toJson() => {
    'image': imageId,
    'comments' : comments,
    'text': postText,
    'hashtags': hashTags,
    'ratings-count': ratingsCount,
    'ratings-average': ratingsAvg,
    'id':postId,
  };
}