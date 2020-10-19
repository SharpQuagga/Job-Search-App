import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Services/auth.dart';
import 'package:squareboat/User/All_jobs.dart';
import 'package:squareboat/User/Applied_jobs.dart';


class OptionPage extends StatefulWidget {
  @override
   _OptionPageState createState() => _OptionPageState();
   OptionPage({@required this.uid});
   final String uid;
}
class _OptionPageState extends State<OptionPage> {
  // To sign out of the App
  Future<void> gooleSignout() async {
   final auth = Provider.of<AuthBase>(context,listen: false);
   auth.signOut();
   Navigator.pop(context);
  }

  int _selectedPage = 0;
  List<Widget> pageOptions=[];

    @override
    void initState() {
    super.initState();
    pageOptions = [
    AllJobs(uid: widget.uid),
    AppliedJobs(uid: widget.uid)
  ];
  }



   @override
   Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
           centerTitle: true,
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
           title: Text("User Home",),),
         bottomNavigationBar: BottomNavigationBar(
           currentIndex: _selectedPage,
           backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontSize: 13),
           elevation: 30,
           unselectedItemColor: Colors.grey,
           selectedItemColor: Colors.black,
           selectedFontSize: 10,
           onTap: (int index){
             setState(() {
               _selectedPage = index;
             });
           },
           items: [
             BottomNavigationBarItem(
               icon: Icon(Icons.map),
               backgroundColor: Colors.grey[50],
               title: Text("All Job")
             ),
             BottomNavigationBarItem(
               icon: Icon(Icons.account_circle),
               title: Text("Applied Jobs")
             ),
           ],
         ),
         body: pageOptions[_selectedPage]
       );
  }
} 