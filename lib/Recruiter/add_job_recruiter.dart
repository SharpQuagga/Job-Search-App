import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Services/database.dart';

class AddJob extends StatefulWidget {
  @override
  _AddJobState createState() => _AddJobState();
  AddJob({@required this.uid});
  final String uid;
}

TextEditingController _jobName = new TextEditingController();
final firestoreInstance = FirebaseFirestore.instance;

class _AddJobState extends State<AddJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _jobName,
                decoration:
                    InputDecoration.collapsed(hintText: 'Enter Job name'),
              ),
            ),
            SheetButton(
              uid: widget.uid,
            )
          ],
        ),
      ),
    );
  }
}

// Statefull Widget for Button
class SheetButton extends StatefulWidget {
  _SheetButtonState createState() => _SheetButtonState();
  SheetButton({@required this.uid});
  final String uid;
}

class _SheetButtonState extends State<SheetButton> {
  bool checking = false;
  bool success = false;

  Future<void> addJobToDatabse() async {
    setState(() {
      checking = true;
    });

    final database = Provider.of<Database>(context, listen: false);
    var dd = await database.getRecruiterName(widget.uid);
    await database.createJob(
        Job(jobname: _jobName.text, recruiterwhoposted: dd), widget.uid);

    setState(() {
      success = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    _jobName.text = '';
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return !checking
        ? MaterialButton(
            color: Colors.grey[800],
            onPressed: () async {
              addJobToDatabse();
            },
            child: Text(
              'Add Job',
              style: TextStyle(color: Colors.white),
            ),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                color: Colors.green,
              );
  }
}
