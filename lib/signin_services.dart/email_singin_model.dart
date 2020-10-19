
enum FormType { login, register }

class EmailSignInModel{
  EmailSignInModel({
    this.name = '',
    this.email = '',
    this.password = '',
    this.formType = FormType.login,
    this.isLoading = false,
    this.submitted = false
  });

  final String name;
  final String email;
  final String password;
  final FormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel copyWith({
    String name,
    String email,
   String password,
   FormType formType,
   bool isLoading,
   bool submitted,
  }){
    return EmailSignInModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted
    );
  }


}