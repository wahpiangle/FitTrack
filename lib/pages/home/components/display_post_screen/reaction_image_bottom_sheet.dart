import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/firebase/reaction.dart';
import 'package:group_project/pages/user_profile/user_profile_page.dart';
import 'package:intl/intl.dart';

class ReactionImageBottomSheet extends StatefulWidget {
  final Reaction reaction;
  final List<Reaction> fullReactionList;
  const ReactionImageBottomSheet({
    super.key,
    required this.reaction,
    required this.fullReactionList,
  });

  @override
  State<ReactionImageBottomSheet> createState() =>
      _ReactionImageBottomSheetState();
}

class _ReactionImageBottomSheetState extends State<ReactionImageBottomSheet> {
  late Reaction _reaction;
  int _index = 0;
  int _current = 0;

  @override
  void initState() {
    _reaction = widget.reaction;
    _index = widget.fullReactionList.indexOf(_reaction);
    _current = _index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Reaction',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _reaction.imageUrl,
                  fit: BoxFit.fill,
                  width: 250,
                  height: 250,
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final user = _reaction.postedByUser;
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(user: user),
                      ),
                    );
                  }
                },
                child: Text(
                  _reaction.postedByUser?.username ?? 'Unknown User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                DateFormat.jm().format(_reaction.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppColours.primaryBright,
                thickness: 1,
              ),
              CarouselSlider.builder(
                itemCount: widget.fullReactionList.length,
                options: CarouselOptions(
                  aspectRatio: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  height: 90,
                  viewportFraction: 0.25,
                  initialPage: _index,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _reaction = widget.fullReactionList[index];
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return Column(
                    children: [
                      ClipOval(
                        child: ColorFiltered(
                          colorFilter: index != _current
                              ? ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken,
                                )
                              : const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.srcOver,
                                ),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    widget.fullReactionList[index].imageUrl,
                                fit: BoxFit.fill,
                                width: 80,
                                height: 80,
                                placeholder: (context, url) => const SizedBox(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _current
                              ? AppColours.secondary
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
