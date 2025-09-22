class Author {
  final String? userId;
  final String? username;

  Author({
    this.userId,
    this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      userId: json['user_id']?.toString(), // int를 String으로 변환
      username: json['username'] as String?,
    );
  }
}
