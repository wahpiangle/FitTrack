import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/exercise_charts.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';
import 'package:group_project/pages/exercise/exercise_history.dart';

class ExerciseRecords extends StatefulWidget {
  final Exercise exercise;

  const ExerciseRecords(this.exercise, {super.key});

  @override
  State<ExerciseRecords> createState() => _ExerciseRecordsState();
}

class _ExerciseRecordsState extends State<ExerciseRecords> {
  int selectedPageIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add edit functionality here
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: IconButton(
            icon: const Icon(Icons.close_sharp, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Center(
          child: Text(
            widget.exercise.name,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedPageIndex = 0;
                              });
                              // Navigator.of(context).pushReplacement(
                              //   PageRouteBuilder(
                              //     opaque:
                              //         false, // Set to false to overlay the existing page
                              //     pageBuilder: (BuildContext context, _, __) {
                              //       return Stack(
                              //         children: [
                              //           // Existing page content
                              //           FractionallySizedBox(
                              //             widthFactor: 1.0,
                              //             heightFactor: 1.0,
                              //             child: Container(
                              //               color: Colors.black.withOpacity(
                              //                   0.8), // Adjust the opacity as needed
                              //             ),
                              //           ),
                              //           // New page content at the center
                              //           Positioned.fill(
                              //             child: Center(
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10.0),
                              //                 child: FractionallySizedBox(
                              //                   widthFactor: 0.9,
                              //                   heightFactor: 0.8,
                              //                   child: ExerciseDetailScreen(
                              //                       widget.exercise),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // );
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return ExerciseDetailScreen(
                                      widget.exercise,
                                      key: PageStorageKey('exerciseDetailScreen'),
                                    );
                                  },
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedPageIndex == 0
                                  ? const Color(0xFF555555)
                                  : const Color(0xFF333333),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('About'),
                          ),
                          // Repeat the same pattern for other buttons
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedPageIndex = 1;
                              });
                              // Navigator.of(context).pushReplacement(
                              //   PageRouteBuilder(
                              //     opaque:
                              //         false, // Set to false to overlay the existing page
                              //     pageBuilder: (BuildContext context, _, __) {
                              //       return Stack(
                              //         children: [
                              //           // Existing page content
                              //           FractionallySizedBox(
                              //             widthFactor: 1.0,
                              //             heightFactor: 1.0,
                              //             child: Container(
                              //               color: Colors.black.withOpacity(
                              //                   0.8), // Adjust the opacity as needed
                              //             ),
                              //           ),
                              //           // New page content at the center
                              //           Positioned.fill(
                              //             child: Center(
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10.0),
                              //                 child: FractionallySizedBox(
                              //                   widthFactor: 0.9,
                              //                   heightFactor: 0.8,
                              //                   child: ExerciseHistory(
                              //                       widget.exercise),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return ExerciseHistory(
                                      widget.exercise,
                                      key: PageStorageKey('exerciseHistory'),
                                    );
                                  },
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedPageIndex == 1
                                  ? const Color(0xFF555555)
                                  : const Color(0xFF333333),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('History'),
                          ),
                          // Repeat the same pattern for other buttons
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedPageIndex = 2;
                              });
                              // Navigator.of(context).pushReplacement(
                              //   PageRouteBuilder(
                              //     opaque:
                              //         false, // Set to false to overlay the existing page
                              //     pageBuilder: (BuildContext context, _, __) {
                              //       return Stack(
                              //         children: [
                              //           // Existing page content
                              //           FractionallySizedBox(
                              //             widthFactor: 1.0,
                              //             heightFactor: 1.0,
                              //             child: Container(
                              //               color: Colors.black.withOpacity(
                              //                   0.8), // Adjust the opacity as needed
                              //             ),
                              //           ),
                              //           // New page content at the center
                              //           Positioned.fill(
                              //             child: Center(
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10.0),
                              //                 child: FractionallySizedBox(
                              //                   widthFactor: 0.9,
                              //                   heightFactor: 0.8,
                              //                   child: ExerciseCharts(
                              //                       widget.exercise),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // );
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return ExerciseCharts(
                                      widget.exercise,
                                      key: PageStorageKey('exerciseCharts'),
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedPageIndex == 2
                                  ? const Color(0xFF555555)
                                  : const Color(0xFF333333),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Charts'),
                          ),
                          // Repeat the same pattern for other buttons
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedPageIndex = 3;
                              });
                              // Navigator.of(context).pushReplacement(
                              //   PageRouteBuilder(
                              //     opaque:
                              //         false, // Set to false to overlay the existing page
                              //     pageBuilder: (BuildContext context, _, __) {
                              //       return Stack(
                              //         children: [
                              //           // Existing page content
                              //           FractionallySizedBox(
                              //             widthFactor: 1.0,
                              //             heightFactor: 1.0,
                              //             child: Container(
                              //               color: Colors.black.withOpacity(
                              //                   0.8), // Adjust the opacity as needed
                              //             ),
                              //           ),
                              //           // New page content at the center
                              //           Positioned.fill(
                              //             child: Center(
                              //               child: ClipRRect(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10.0),
                              //                 child: FractionallySizedBox(
                              //                   widthFactor: 0.9,
                              //                   heightFactor: 0.8,
                              //                   child: ExerciseRecords(
                              //                       widget.exercise),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // );
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return ExerciseRecords(
                                      widget.exercise,
                                      key: PageStorageKey('exerciseRecords'),
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedPageIndex == 3
                                  ? const Color(0xFF555555)
                                  : const Color(0xFF333333),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Records'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Records',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
