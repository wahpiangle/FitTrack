import 'package:flutter/material.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/home/components/reaction/capture_reaction_dialog.dart';
import 'package:peek_and_pop_dialog/peek_and_pop_dialog.dart';

class ReactionButton extends StatefulWidget {
  final void Function() showHoldInstruction;
  final Post post;
  final void Function() toggleState;

  const ReactionButton({
    required this.showHoldInstruction,
    required this.post,
    required this.toggleState,
    super.key,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  final ValueNotifier<Offset> _pointerPosition =
      ValueNotifier<Offset>(const Offset(0, 0));

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) => {
        setState(() {
          _pointerPosition.value = event.position;
        }),
      },
      child: PeekAndPopDialog(
        dialog: CaptureReactionDialog(
          pointerPosition: _pointerPosition,
          post: widget.post,
          toggleState: widget.toggleState,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.emoji_emotions_sharp,
            color: Colors.white,
            size: 30,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 10,
              ),
            ],
          ),
          onPressed: () {
            widget.showHoldInstruction();
          },
        ),
      ),
    );
  }
}
