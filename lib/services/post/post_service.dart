import 'package:group_project/models/post.dart';
import 'package:objectbox/objectbox.dart';

class PostService {
  Box<Post> postBox;

  PostService({
    required this.postBox,
  });

  void addPost(Post post) {
    postBox.put(post);
  }

  List<Post> getPosts() {
    return postBox.getAll();
  }

  void test() {
    print(postBox.getAll().length);
    print(postBox.removeAll());
  }
}
