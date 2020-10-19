import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Services/auth.dart';
import 'package:squareboat/home_page.dart';
import 'package:squareboat/signin_services.dart/signin_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<CUser>(
          stream: auth.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              CUser user = snapshot.data;
              if (user == null) {
                return SignInPage.create(context);
              }
              return HomePage(uid: user.uid);
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
  }
}
