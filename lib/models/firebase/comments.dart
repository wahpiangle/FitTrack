class Comment {
  String id;
  String postId;
  String postedBy;
  String comment;
  DateTime date;

  Comment({
    required this.id,
    required this.postId,
    required this.postedBy,
    required this.comment,
    required this.date,
  });

  static fromDocument(doc) {
    return Comment(
      id: doc.id,
      postId: doc.data()?['postId'] ?? '',
      postedBy: doc.data()?['postedBy'] ?? '',
      comment: doc.data()?['comment'] ?? '',
      date: doc.data()?['date'].toDate() ?? DateTime.now(),
    );
  }
}
