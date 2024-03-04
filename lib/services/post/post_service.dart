import 'package:group_project/models/post.dart';
import 'package:group_project/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class PostService {
  Box<Post> postBox;

  PostService({
    required this.postBox,
  });

  void addPost(Post post) {
    postBox.put(post);
  }

  Post? getPost(int id) {
    return postBox.get(id);
  }

  List<Post> getPosts() {
    return postBox.getAll();
  }

  List<Post> getActivePosts() {
    return postBox
        .query(
      // get posts from the last 24 hours
      Post_.date.greaterThan(
        DateTime.now()
            .subtract(
          const Duration(
            hours: 24,
          ),
        )
            .millisecondsSinceEpoch,
      ),
    )
        .build()
        .find();
  }

  // Method to clear all posts
  void clearAllPosts() {
    postBox.removeAll();
  }

  void test() {
    print(postBox.getAll().length);
    print(postBox.removeAll());
  }
}
