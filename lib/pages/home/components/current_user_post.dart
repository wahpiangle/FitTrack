import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/pages/home/components/display_post_image_screen.dart';

class CurrentUserPost extends StatefulWidget {
  const CurrentUserPost({super.key});

  @override
  State<CurrentUserPost> createState() => _CurrentUserPostState();
}

class _CurrentUserPostState extends State<CurrentUserPost> {
  late List<Map<String, dynamic>> imageList = [];
  String caption = '';
  int _current = 0;
  int workoutSessionId = 0; // Declare workoutSessionId here

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  void fetchUserPosts() async {
    try {
      List<Post> posts = await FirebasePostsService.getCurrentUserPosts();
      List<Map<String, dynamic>> postMapList = posts.map((post) {
        return {
          'firstImageUrl': post.firstImageUrl,
          'secondImageUrl': post.secondImageUrl,
          'postId': post.id,
          'workoutSessionId': post.workoutSession.targetId,
        };
      }).toList();

      setState(() {
        imageList = postMapList;
        // Fetch the caption for the initial workoutSessionId
        workoutSessionId = imageList.isNotEmpty ? imageList[_current]['workoutSessionId'] : 0;
        fetchCaption(workoutSessionId);
      });
    } catch (e) {
      // Handle error accordingly
    }
  }

  void fetchCaption(int workoutSessionId) async {
    String fetchedCaption = await FirebasePostsService.getCaption(workoutSessionId);
    setState(() {
      caption = fetchedCaption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = imageList.isNotEmpty;

    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 5),
              if (hasImages) const SizedBox(height: 1),
              if (hasImages)
                CarouselSlider.builder(
                  itemCount: imageList.length,
                  options: CarouselOptions(
                    aspectRatio: 0.9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    enlargeFactor: 0.2,
                    viewportFraction: 0.45,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                        // Fetch the caption for the new workoutSessionId when page changes
                        workoutSessionId = imageList[index]['workoutSessionId'];
                        fetchCaption(workoutSessionId);
                      });
                    },
                  ),
                  // Inside the itemBuilder of CarouselSlider.builder
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              // First image URL
                              CachedNetworkImage(
                                imageUrl: imageList[index]['firstImageUrl'],
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                              // Second image URL stacked to the top left
                              Positioned(
                                top: 0,
                                left: 0,
                                child: SizedBox(
                                  width: 50, // Adjust the size as needed
                                  height: 50, // Adjust the size as needed
                                  child: CachedNetworkImage(
                                    imageUrl: imageList[index]['secondImageUrl'],
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              showCursor: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                              enableInteractiveSelection: false,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                hintText: 'Add a caption..',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 16),
                              ),
                              onChanged: (caption) {
                                // Use the workoutSessionId state variable here
                                FirebasePostsService.saveCaption(workoutSessionId, caption);
                              },
                              controller: TextEditingController(text: caption),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: const Icon(Icons.favorite, color: Colors.grey),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DisplayPostImageScreen(
                                          imagePath: imageList[index]['firstImageUrl'],
                                          imagePath2: imageList[index]['secondImageUrl'],
                                          workoutSessionId: imageList[index]['workoutSessionId'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.comment, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

//TODO to fix caption issue here (save and fetch)
//TODO when click inside photo/comment button will go to display image stack page
//TODO when click on the like will show who liked