import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/blocs/task/task_bloc.dart';
import 'package:task_app/utils/color_utils.dart';
import 'package:task_app/views/task_details.dart/task_details.dart';
import 'package:task_app/views/tasks/add_tasks_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final CollectionReference _usersStream = FirebaseFirestore.instance
      .collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.BgYELLOW,
      appBar: AppBar(
        backgroundColor: ColorConstants.PRIMARYCOLOR,
        title: Text(
          "Tasks",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: ColorConstants.TXTCOLOR,
          ),
        ),

        toolbarHeight: 100,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Logout'),
                    ),
                  ),
                ],
            icon: Icon(Icons.more_vert),
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.PRIMARYCOLOR,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskAddPage()),
          );
        },
        child: Icon(Icons.edit_document, color: ColorConstants.TXTCOLOR),
      ),
      body: StreamBuilder(
        stream: _usersStream.snapshots(),
        builder: (context, snapshot) {
          var documents = snapshot.data?.docs;
          if (snapshot.hasError) {
            return Center(child: Text('Tasks couldn\'t be loaded'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return documents?.length == 0
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_copy_outlined,
                      size: 100,
                      color: ColorConstants.ICONCOLOR,
                    ),
                    const SizedBox(width: double.infinity, height: 30),
                    Text(
                      "No Existing tasks",
                      style: TextStyle(
                        fontSize: 17,
                        color: ColorConstants.ICONCOLOR,
                      ),
                    ),
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.separated(
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 10),
                    itemCount: documents?.length ?? 0,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TaskDetails(
                                          selectedDocument: documents![index],
                                        ),
                                  ),
                                ),
                            child: Material(
                              color: Colors.white,
                              elevation: 2,
                              borderRadius: BorderRadius.circular(15),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                // style: ListTileStyle.list,
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                // hoverColor: Colors.grey,
                                title: Text(
                                  documents?[index]["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstants.TXTCOLOR,
                                  ),
                                ),
                                subtitle: Text(
                                  documents?[index]["description"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorConstants.ICONCOLOR,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => TaskAddPage(
                                                  docId: documents![index].id,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: ColorConstants.ICONCOLOR,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onTap:
                                          () => context.read<TaskBloc>().add(
                                            DeleteTaskEvent(
                                              docId: documents![index].id,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
                );
          } else {
            return Text("No tasks found");
          }
        },
      ),
    );
  }
}
