import 'package:flutter/material.dart';
import 'package:group_project/services/database_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO this is just an example of loading sqlite data into a listview
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: DatabaseService()
            .getWorkouts(), //! this function will not work as the table is not created yet
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            final users = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['name']),
                );
              },
            );
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}
