import 'dart:async';

import 'package:squareboat/Model/MyUser.dart';
import 'package:squareboat/Services/auth.dart';
import 'package:squareboat/Services/database.dart';
import 'package:squareboat/signin_services.dart/email_singin_model.dart';

class EmailSignInBloc{
  EmailSignInBloc({this.auth,this.database});
  final AuthBase auth;
  final Database database;

  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();


  void dispose(){
    _modelController.close();
  }

   Future<void> signInWithEmailPassword() async {
    try {
      updateWith(isLoading: true);
      await auth.signInWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      rethrow;
      // _showSignInError(e);
    } finally {
      updateWith(isLoading: true);
    }
  }

  Future<void> registerWithEmailPassword() async {
    try {
      updateWith(isLoading: true);
      var dd = await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      // Adding User and Recruiter to database
      await database.addUser(dd.uid,MyUser(name:_model.name, email: _model.email));
    } catch (e) {
      rethrow;
      // _showSignInError(e);
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({
    String name,
    String email,
    String password,
    FormType formType,
    bool isLoading,
    bool submitted,
  }){
    _model = _model.copyWith(
      name: name,
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );

    _modelController.add(_model);
  }



}