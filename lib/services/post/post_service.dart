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

  void clearAllPosts() {
    postBox.removeAll();
  }
}
