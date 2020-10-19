import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Services/database.dart';
import 'package:squareboat/common_widgets/custom_job_tile.dart';

class AllJobs extends StatefulWidget {
  @override
  _AllJobsState createState() => _AllJobsState();
  AllJobs({@required this.uid});
  final String uid;
}

class _AllJobsState extends State<AllJobs> {
  List<String> _aap = [];
  List<Job> _applied = [];

  void cc() async {
    final database = Provider.of<Database>(context, listen: false);
    _applied = await database.userJobApplied(widget.uid).first;
    print('ssss');
    print(_applied[0].jobname + _applied[0].recruiterwhoposted);
    for (int i = 0; i < _applied.length; i++) {
      _aap.add(_applied[i].jobname + _applied[i].recruiterwhoposted);
    }
    print('qqqq' + _aap.toString());
  }

  bool check(Job job) {
    String now = job.jobname + job.recruiterwhoposted;
    print('nnnnn' + now);
    if (_aap.contains(now)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    cc();
    bool cl = false;
    bool loading = false;
    final database = Provider.of<Database>(context, listen: false);
    return Stack(
      children: [
      loading==false?Container():CircularProgressIndicator(),
       StreamBuilder<List<Job>>(
      stream: database.alljobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map((job) => JobTile(
                    jobname: job.jobname,
                    recruiterwhoposted: job.recruiterwhoposted,
                    applyApplicatiosn: cl == false ? 'Apply' : 'Applied',
                    showButton: !check(job),
                    callback: () async {
                      if (cl == false) {
                        setState(() {
                          loading=true;
                        });
                        await database.applyForJob(job, widget.uid);
                        setState(() {
                          cc();
                          cl = true;
                          loading=false;
                        });
                      }
                      cl = false;
                    },
                  ))
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Some error occurred' + snapshot.error.toString()));
        }
        return Center(child: CircularProgressIndicator());
      },
    )
      ],
    );
  }
}
