import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';

class SignupScreen extends StatefulWidget { const SignupScreen({super.key}); @override State<SignupScreen> createState() => _SignupScreenState(); }
class _SignupScreenState extends State<SignupScreen> {
  final _email=TextEditingController(); final _password=TextEditingController();
  bool _loading=false; String? _error;
  @override Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(appBar: AppBar(title: const Text('Sign up')), body: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [
      TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
      TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
      const SizedBox(height:12),
      if (_error!=null) Text(_error!, style: const TextStyle(color: Colors.red)),
      ElevatedButton(onPressed: _loading?null:() async { setState(()=>_loading=true); final res = await auth.signUp(_email.text.trim(), _password.text); setState(()=>_loading=false); if (res!=null) setState(()=>_error=res); }, child: _loading? const CircularProgressIndicator(): const Text('Create account')),
    ],),),);
  }
}
