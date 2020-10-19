import 'package:flutter/material.dart';
import 'package:squareboat/Recruiter/Recruiter.dart';
import 'package:squareboat/User/option_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  HomePage({@required this.uid});
  final String uid;
}

class _HomePageState extends State<HomePage> {

  Widget customButton(String text, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      height: 60.0,
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: RaisedButton(
        elevation: 15.0,
        onPressed: onPressed,
        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(7.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }


  void goToOptionPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OptionPage(uid: widget.uid,)));
  }

  void goToRecruiterPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Recruiter(uid: widget.uid)));
  }

  Widget _recAndCandButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customButton('Candidate Home', goToOptionPage),
          SizedBox(
            height: 80,
          ),
          customButton('Recruiter Home', goToRecruiterPage),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body:_recAndCandButton()
        
        );
  }
}
