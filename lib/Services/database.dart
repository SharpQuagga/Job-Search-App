import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:squareboat/Model/Job.dart';
import 'package:squareboat/Model/MyUser.dart';

abstract class Database {
  Future<void> createJob(Job job, String uid);
  Stream<List<Job>> alljobsStream();
  Future<String> getRecruiterName(String uid);
  Future<void> addUser(String id, MyUser user);
  Stream<List<Job>> recruiterJobs(String uid);
  Future<void> applyForJob(Job job, String userUid);
  Future<MyUser> getUserNameEmail(String uid);
  Stream<List<Job>> userJobApplied(String uid);
  Stream<List<MyUser>> usersAppliedRecruiter(Job job);
}

class FirestoreDatabase extends Database {

  final firestoreInstance = FirebaseFirestore.instance;

  Future<void> addUser(String id, MyUser user) async {
    await firestoreInstance.collection('User').doc(id).set(user.toMap());

    await firestoreInstance
        .collection('Recruiter')
        .doc(id)
        .set({'Name': user.name, 'Email': user.email});
  }

  Future<String> getRecruiterName(String uid) async {
    String name = '';
    var d = await firestoreInstance.collection("Recruiter").doc(uid).get();
    name = d.data()['Name'];
    print('name' + name);
    return name;
  }

  Future<MyUser> getUserNameEmail(String uid) async {
    var d = await firestoreInstance.collection("User").doc(uid).get();
    MyUser user = new MyUser(name: d.data()['Name'], email: d.data()['Email']);
    return user;
  }

  Future<void> createJob(Job job, String uid) async {
    await firestoreInstance
        .collection('All_Jobs')
        .doc(job.recruiterwhoposted + job.jobname)
        .set(job.toMap());

    await firestoreInstance
        .collection("Recruiter")
        .doc(uid)
        .collection("Job_Posted")
        .doc(job.jobname)
        .set({'jobname': job.jobname});
  }

  Stream<List<Job>> alljobsStream() {
    final snapshots = firestoreInstance.collection("All_Jobs").snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Job(
            jobname: snapshot.data()['jobname'],
            recruiterwhoposted: snapshot.data()['recruiterwhoposted']))
        .toList());
  }

  Stream<List<Job>> recruiterJobs(String uid) {
    final snapshots = firestoreInstance
        .collection("Recruiter")
        .doc(uid)
        .collection("Job_Posted")
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) =>
            Job(jobname: snapshot.data()['jobname'], recruiterwhoposted: null))
        .toList());
  }

  Future<void> applyForJob(Job job, String userUid) async {
    await firestoreInstance
        .collection("User")
        .doc(userUid)
        .collection("Job_Applied")
        .add(job.toMap());

    var u = await getUserNameEmail(userUid);
    await firestoreInstance
        .collection("All_Jobs")
        .doc(job.recruiterwhoposted + job.jobname)
        .collection("Job_Applied")
        .add(u.toMap());
  }

  Stream<List<Job>> userJobApplied(String uid) {
    final snapshots = firestoreInstance
        .collection("User")
        .doc(uid)
        .collection('Job_Applied')
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Job(
            jobname: snapshot.data()['jobname'],
            recruiterwhoposted: snapshot.data()['recruiterwhoposted']))
        .toList());
  }

  Stream<List<MyUser>> usersAppliedRecruiter(Job job) {
    
    final snapshots = firestoreInstance
        .collection("All_Jobs")
        .doc(job.jobname)
        .collection('Job_Applied')
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => MyUser(
            name: snapshot.data()['Name'],
            email: snapshot.data()['Email']))
        .toList());
  }


}
