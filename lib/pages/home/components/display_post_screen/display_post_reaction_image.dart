import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/pages/home/components/display_post_screen/reaction_image_bottom_sheet.dart';

class DisplayPostReactionImage extends StatelessWidget {
  final Reaction reaction;
  final List<Reaction> fullReactionList;
  const DisplayPostReactionImage({
    super.key,
    required this.reaction,
    required this.fullReactionList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            backgroundColor: AppColours.primary,
            builder: (context) {
              return ReactionImageBottomSheet(
                reaction: reaction,
                fullReactionList: fullReactionList,
              );
            }),
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: reaction.imageUrl,
                fit: BoxFit.fill,
                width: 80,
                height: 80,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              reaction.postedByUser!.username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
