import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Services/database.dart';

class AppliedJobs extends StatefulWidget {
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
  AppliedJobs({@required this.uid});
  final String uid;
}

class _AppliedJobsState extends State<AppliedJobs> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Column(
      children: [
        Container(margin: EdgeInsets.all(6), child: Text("Applied Jobs",style: TextStyle(fontSize: 20),)),
        Expanded(
          flex: 2,
          child: StreamBuilder<List<Job>>(
            stream: database.userJobApplied(widget.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final jobs = snapshot.data;
                final children = jobs
                    .map((job) => Card(
                          elevation: 20,
                          shadowColor: Colors.black26,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                            padding: EdgeInsets.all(4),
                            child: Text('Job: ' + job.jobname),
                          ),
                        ))
                    .toList();
                return jobs.length >= 1
                    ? ListView(children: children)
                    : Center(child: Text('No Jobs Applied'));
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Some error occurred' + snapshot.error.toString()));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
