import 'package:flutter/material.dart';
import 'package:time_tracker/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProjectModal extends StatefulWidget {
  const AddProjectModal({Key? key}) : super(key: key);

  @override
  State<AddProjectModal> createState() => _AddProjectModalState();
}

class _AddProjectModalState extends State<AddProjectModal> {
  final GlobalKey<FormState> _formKeyAddProject = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String projectName = '';
  String projectDescription = '';
  bool isLoading = false;

  Future<void> addProject() async {
    try {
      setState(() {
        isLoading = true;
      });
      await firestore.collection('projects').add({
        'name': projectName,
        'description': projectDescription,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'ownerId': auth.currentUser!.uid,
      });
      Navigator.pop(context);
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: kPagePadding,
          child: Form(
            key: _formKeyAddProject,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.projectName,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.required;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    projectName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                  ),
                  onChanged: (value) {
                    projectDescription = value;
                  },
                ),
                TextButton(
                  style: kSubTextStyle,
                  onPressed: () {
                    if (_formKeyAddProject.currentState!.validate()) {
                      addProject();
                    }
                  },
                  child: (isLoading)
                      ? const CircularProgressIndicator(
                          color: Colors.blueAccent,
                        )
                      : Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
