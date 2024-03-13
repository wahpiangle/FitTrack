class Comment {
  String id;
  String postId;
  String postedBy;
  String comment;
  String postedByImageUrl;
  DateTime date;

  Comment({
    required this.id,
    required this.postId,
    required this.postedBy,
    required this.comment,
    required this.postedByImageUrl,
    required this.date,
  });

  static fromDocument(doc) {
    return Comment(
      id: doc.id,
      postId: doc.data()?['postId'] ?? '',
      postedBy: doc.data()?['postedBy'] ?? '',
      comment: doc.data()?['comment'] ?? '',
      postedByImageUrl: doc.data()?['postedByImageUrl'] ?? '',
      date: doc.data()?['date'].toDate() ?? DateTime.now(),
    );
  }
}
