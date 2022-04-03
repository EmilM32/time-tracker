import 'package:flutter/material.dart';
import 'package:time_tracker/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/models/project.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  List<Project> allProjects = [];
  bool isLoading = true;

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await projects.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var data in allData) {
      Map<String, dynamic>? proj = data as Map<String, dynamic>?;
      allProjects.add(
        Project(
          name: proj!['name'],
          description: proj['description'],
          createdAt: proj['createdAt'],
          ownerId: proj['ownerId'],
          updatedAt: proj['updatedAt'],
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPagePadding,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.myProjects,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            child: (isLoading)
                ? const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: allProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(allProjects[index].name),
                          subtitle: Text(allProjects[index].description),
                          onTap: () {
                            print('project clicked');
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
