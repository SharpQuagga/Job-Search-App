import 'package:flutter/material.dart';


class JobTile extends StatefulWidget {
  JobTile({@required this.callback,@required this.jobname,@required this.recruiterwhoposted,@required this.applyApplicatiosn,@required this.showButton});
  final VoidCallback callback;
  final String jobname;
  final String recruiterwhoposted;
  final String applyApplicatiosn;
  final bool showButton;

  @override
  _JobTileState createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 20,
      shadowColor: Colors.white24,
      child: ListTile(
        trailing: Container(
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(20)),
          child: widget.showButton==true?
           MaterialButton(
            onPressed: () {
              widget.callback();
            },
            child: Text(
              widget.applyApplicatiosn,
              style: TextStyle(color: Colors.white),
            ),
          ):Container(
            margin: EdgeInsets.all(8),
            child: Text('Applied',style: TextStyle(color: Colors.white),)),
        ),
        title: Text('Job: '+widget.jobname),
        subtitle: widget.recruiterwhoposted!=null?Text('Recruiter: '+widget.recruiterwhoposted):null,
      ),
    );
  }
}
