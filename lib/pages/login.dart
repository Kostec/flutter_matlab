import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttermatlab/services/network.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage>{
  GlobalKey<FormBuilderState> _formKey = GlobalKey();

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      attribute: 'email',
                      decoration: InputDecoration(labelText: 'email', labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    FormBuilderTextField(
                      attribute: 'username',
                      decoration: InputDecoration(labelText: 'username', labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      keyboardType: TextInputType.text,
                    ),
                    FormBuilderTextField(
                      attribute: 'password',
                      decoration: InputDecoration(labelText: 'password', labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ],
                )
            ),
            Container(
              child:
                RaisedButton(
                  child: Text('Login'),
                  onPressed: _login,
                )
            ),
            Container(
                child:
                RaisedButton(
                  child: Text('SignUp'),
                  onPressed: _signUp,
                )
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    Fluttertoast.showToast(msg: 'signup');
    _formKey.currentState.save();
    var values = _formKey.currentState.value;
    await Network.Login(values['username'], values['password']);
  }
  void _signUp() async {
    Fluttertoast.showToast(msg: 'signup');
    _formKey.currentState.save();
    var data = _formKey.currentState.value;
    await Network.SignUp(data);
  }
}