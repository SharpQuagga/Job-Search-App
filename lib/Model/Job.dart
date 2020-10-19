
import 'package:flutter/foundation.dart';

class Job{
  Job({@required this.jobname, @required this.recruiterwhoposted});
  String jobname;
  String recruiterwhoposted;

  Map<String,dynamic> toMap(){
    return {
      'jobname':jobname,
      'recruiterwhoposted':recruiterwhoposted
    };
  }

}