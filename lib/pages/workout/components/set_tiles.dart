import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise_set.dart';

class SetTiles extends StatefulWidget {
  final int exercisesSetsInfoId;
  final String exerciseName;
  final List<ExerciseSet> exerciseSet;
  final void Function(int exerciseSetId) removeSet;

  const SetTiles({
    super.key,
    required this.exercisesSetsInfoId,
    required this.exerciseName,
    required this.exerciseSet,
    required this.removeSet,
  });

  @override
  State<SetTiles> createState() => _SetTilesState();
}

class _SetTilesState extends State<SetTiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollConfiguration(
          behavior: NoGlowBehaviour(),
          child: ListView.builder(
            itemCount: widget.exerciseSet.asMap().entries.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int setIndex = index;
              ExerciseSet set =
                  widget.exerciseSet.asMap().entries.elementAt(setIndex).value;
              if (index == 0) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                "Set",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "Weight",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "Reps",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(width: 40)
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.green[600],
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => {widget.removeSet(set.id)},
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "${setIndex + 1}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController(
                                      text: "${set.weight}",
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController(
                                      text: "${set.reps}",
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 40,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.check,
                                        color: Color(0xFFE1F0CF),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) => {
                  widget.removeSet(set.id),
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            textAlign: TextAlign.center,
                            "${setIndex + 1}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                text: "${set.weight}",
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                text: "${set.reps}",
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 40,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xFFE1F0CF),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF333333)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            onPressed: () {
              // TODO: Add set
            },
            child: const Center(
              child: Text(
                "Add Set",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
