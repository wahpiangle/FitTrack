import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/firebase/firebase_user_post.dart';
import 'package:group_project/pages/home/components/friends_post/friend_post.dart';
import 'package:group_project/services/firebase/firebase_friends_post.dart';

class FriendsPostList extends StatefulWidget {
   const FriendsPostList({
    super.key,
  });


  @override
  State<FriendsPostList> createState() => _FriendsPostCarouselState();
}

class _FriendsPostCarouselState extends State<FriendsPostList> {
  Stream<Map<FirebaseUser, List<FirebaseUserPost>>>? friendsPostStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFriendsPosts();
    });
  }

  void fetchFriendsPosts() async {
    final stream = await FirebaseFriendsPost().initFriendsPostStream();
    setState(() {
      friendsPostStream = stream;
    });
  }

  void toggleState() {
    fetchFriendsPosts();
  }

  @override
  Widget build(BuildContext context) {
    return friendsPostStream != null
        ? StreamBuilder<Map<FirebaseUser, List<FirebaseUserPost>>>(
            stream: friendsPostStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Map<FirebaseUser, List<FirebaseUserPost>> friendsPosts =
                    snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: friendsPosts.length,
                  itemBuilder: (context, index) {
                    final friend = friendsPosts.keys.elementAt(index);
                    final friendPostData = friendsPosts[friend]!.first;
                    final friendPostDataList = friendsPosts[friend]!;
                    return FriendPost(
                      friend: friend,
                      friendPostData: friendPostData,
                      friendPostDataList: friendPostDataList,
                      toggleState: toggleState,
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
