import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Model/MyUser.dart';
import 'package:squareboat/Services/database.dart';

class ApplicationForTheJob extends StatelessWidget {
  final Job cjob;
  ApplicationForTheJob({@required this.cjob});
 
  @override
  Widget build(BuildContext context) {  
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Recruiter'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text('Applicants for: ' + cjob.jobname),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<List<MyUser>>(
                stream: database.usersAppliedRecruiter(cjob),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data;
                    final children = users
                        .map((user) => Card(
                              elevation: 20,
                              shadowColor: Colors.black26,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: ListTile(
                                  title: Text('Name: ' + user.name),
                                  trailing: Text('Email' + user.email),
                                ),
                              ),
                            ))
                        .toList();
                    if (users.length>=1){
                    return ListView(children: children);
                    }
                    return Center(child: Text('No applications'),);
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Some error occurred' + snapshot.error.toString()));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ));
  }
}
