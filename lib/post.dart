class Post {
  String text;

  Post({
    required this.text
  });

  factory Post.fromJason(Map <String, dynamic> json) =>
      Post(
        text: json['text'],
      );


}