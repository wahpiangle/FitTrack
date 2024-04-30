import 'package:group_project/models/post.dart';
import 'package:group_project/objectbox.g.dart';

class PostService {
  Box<Post> postBox;

  PostService({
    required this.postBox,
  });

  void addPost(Post post) {
    postBox.put(post);
  }

  Post? getPostByWorkoutSessionId(int workoutSessionId) {
    return postBox
        .query(
          Post_.workoutSessionId.equals(workoutSessionId),
        )
        .build()
        .findFirst();
  }

  void addFirebasePostId(int postId, String firebasePostId) {
    final post = postBox.get(postId);
    post!.postId = firebasePostId;
    postBox.put(post);
  }

  Post? getPost(int id) {
    return postBox.get(id);
  }

  void clearAllPosts() {
    postBox.removeAll();
  }
}
