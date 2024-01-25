import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<List<Exercise>> streamExercises;

  @override
  void initState() {
    super.initState();
    streamExercises = objectBox.exerciseService.watchAllExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
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
                    leading: Container(
                        height: 500,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: Image.asset(snapshot.data![index].imagePath)
                              .image,
                          fit: BoxFit.fill, //or whatever BoxFit you want
                        ))),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].bodyPart.target!.name),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ));
  }
}
