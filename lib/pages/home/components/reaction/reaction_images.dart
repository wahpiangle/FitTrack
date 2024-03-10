import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/reaction.dart';

class ReactionImages extends StatelessWidget {
  final List<Reaction> postReactions;
  final bool isCurrentUserPost;
  const ReactionImages({
    required this.postReactions,
    this.isCurrentUserPost = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 300,
      child: Stack(
        children: [
          for (var i = 0; i < postReactions.length; i++)
            i < 3
                ? Positioned(
                    left: i.toDouble() * 30,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      width: 40,
                      height: 40,
                      child: CachedNetworkImage(
                        imageUrl: postReactions[i].imageUrl,
                        imageBuilder: (context, imageProvider) => ClipOval(
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  )
                : i == 3
                    ? Positioned(
                        left: i.toDouble() * 30,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            color: AppColours.primaryBright,
                          ),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              '+${postReactions.length - 3}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
        ],
      ),
    );
  }
}
