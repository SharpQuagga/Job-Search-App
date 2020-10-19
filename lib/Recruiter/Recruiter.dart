import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Recruiter/Applications_for_Job.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Services/auth.dart';
import 'package:squareboat/Services/database.dart';
import 'package:squareboat/Recruiter/add_job_recruiter.dart';
import 'package:squareboat/common_widgets/custom_job_tile.dart';

class Recruiter extends StatefulWidget {
  @override
  _RecruiterState createState() => _RecruiterState();
  Recruiter({@required this.uid});
  final String uid;
}

final firestoreInstance = FirebaseFirestore.instance;
bool gettingdata = false;
String rname = '';
class _RecruiterState extends State<Recruiter> {
  // To sign out of the App
  Future<void> gooleSignout() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    auth.signOut();
    Navigator.pop(context);
  }

  void cc(Database database) async {
    rname = await database.getRecruiterName(widget.uid);
  }


  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    cc(database);
    return StreamBuilder<List<Job>>(
      stream: database.recruiterJobs(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map((job) => JobTile(
                    jobname: job.jobname,
                    recruiterwhoposted: null,
                    applyApplicatiosn: 'Applications',
                    showButton: true,
                    callback: () {
                    job.recruiterwhoposted=rname;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationForTheJob(
                              cjob: job,
                            ),
                          ));
                    },
                  ))
              .toList();
              return jobs.length >= 1
              ? ListView(children: children)
              : Center(child: Text('No Jobs Posted'));
          // return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'+snapshot.error.toString()));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(8),
              child: MaterialButton(
                onPressed: () {
                  gooleSignout();
                },
                child: Text('Sign Out'),
              ),
            )
          ],
          title: Text('Recruiter'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => AddJob(uid: widget.uid,),
              ))
                  .then((_) {
                setState(() {
                  gettingdata = true;
                  // getPostedJobs();
                });
              });
            },
            child: Icon(Icons.add)),
        body: Container(
          margin: EdgeInsets.all(10),
          child: _buildContent(context)),);
  }
}
