import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late Stream<List<Exercise>> streamExercises;

  @override
  void initState() {
    super.initState();
    streamExercises = objectBox.watchAllExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Screen'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: StreamBuilder(
          stream: streamExercises,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Row(
                        children: <Widget>[
                          Text(snapshot.data![index].bodyPart.target!.name),
                          const Text(' - '),
                          Text(snapshot.data![index].category.target!.name),
                        ],
                      ));
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // objectBox.addExercises();
          },
          child: const Icon(Icons.add),
        ));
  }
}
