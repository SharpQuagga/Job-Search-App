import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squareboat/Model/MyUser.dart';
import 'package:squareboat/Services/auth.dart';
import 'package:squareboat/Services/database.dart';
import 'package:squareboat/signin_services.dart/email_singin_bloc.dart';
import 'package:toast/toast.dart';
import 'package:squareboat/signin_services.dart/email_singin_model.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
  SignInPage({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final Database database = Provider.of<Database>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth, database: database),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, child) => SignInPage(
          bloc: bloc,
        ),
      ),
      // dispose: (context, value) => bloc.dispose(),
    );
  }
}

class _SignInPageState extends State<SignInPage> {
  String _authHint = '';
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  void _showSignInError(Exception exception) {
    Toast.show(exception.toString(), context);
  }

  Widget formFieldd(
      Widget icons, String hintText, TextEditingController controller) {
    bool submitted = false;
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: icons,
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              onSaved: (val) => controller.text = val,
              onChanged: (val) => {submitted = true},
              decoration: InputDecoration(
                errorText: submitted == true && controller.text.length == 0
                    ? 'Field cant be empty'
                    : null,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signInButton(String text, VoidCallback onPressed,bool loading) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: MaterialButton(
          child: Center(child: Text(text)), onPressed: loading==true?null: onPressed),
    );
  }

  changeForm(EmailSignInModel model) {
    widget.bloc.updateWith(
        submitted: false,
        formType: model.formType == FormType.login
            ? FormType.register
            : FormType.login);
    _authHint = '';
  }

  signInWithEmailPassword() async {
    try {
      widget.bloc.updateWith(email: _email.text,password: _password.text,isLoading: true);
      await widget.bloc.signInWithEmailPassword();
    } catch (e) {
      _showSignInError(e);
      widget.bloc.updateWith(isLoading: false);
    } 
  }

  registerWithEmailPassword() async {
    try {
      widget.bloc.updateWith(name: _name.text,email: _email.text,password: _password.text,isLoading: true);
      await widget.bloc.registerWithEmailPassword();
    } catch (e) {
      _showSignInError(e);
      widget.bloc.updateWith(isLoading: false);
    }
  }

  List<Widget> usernameAndPassword(EmailSignInModel model) {
    switch (model.formType) {
      case FormType.login:
        return [
          formFieldd(Icon(Icons.email), 'Email', _email),
          formFieldd(Icon(Icons.fiber_pin), 'Password', _password),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          signInButton('LOGIN', (){signInWithEmailPassword();},model.isLoading),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          signInButton('Need a account? Register',() {changeForm(model);},model.isLoading),
          Padding(
            padding: EdgeInsets.all(8),
          ),
        ];

      case FormType.register:
        return [
          formFieldd(Icon(Icons.person), 'Name', _name),
          formFieldd(Icon(Icons.email), 'Email', _email),
          formFieldd(Icon(Icons.fiber_pin), 'Password', _password),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          signInButton('Register', (){registerWithEmailPassword();},model.isLoading),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          signInButton('Have a account? Login', (){changeForm(model);},model.isLoading),
          Padding(
            padding: EdgeInsets.all(8),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Application'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            StreamBuilder<EmailSignInModel>(
              initialData: EmailSignInModel(),
              stream: widget.bloc.modelStream,
              builder: (context, snapshot) {
                final EmailSignInModel model = snapshot.data;
                return _signInWithEmail(model);
              }
            ),
            SizedBox(height: 8.0),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _signInWithEmail(EmailSignInModel model) {
    return SingleChildScrollView(
          child: Form(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: usernameAndPassword(model),
                )),
          ),
        );
  }
}
