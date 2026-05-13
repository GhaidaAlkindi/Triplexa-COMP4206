import 'package:flutter/material.dart';
import '../model/colorPalette.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {                    //for the toggle button
  const login({super.key});                             //constuctor
  @override
  State<StatefulWidget> createState() => loginState();
}

class loginState extends State<login>{
  bool isLogin = true;                                  //when the toggle is active to login
  bool _loading = false;
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();           //for form validtion

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }
  
  InputDecoration _fieldStyle(String hint) => InputDecoration(   //shared field decoration
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 1.8)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 1.8)),
    focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 2)),
    errorBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red, width: 1.8)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red, width: 2)),
    errorStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.red),
  );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() => _loading = false);
      String msg = 'Something went wrong. Please try again.';
      if (e.code == 'user-not-found')   msg = 'No account found with this email.';
      if (e.code == 'wrong-password')   msg = 'Incorrect password.';
      if (e.code == 'email-already-in-use') msg = 'An account already exists with this email.';
      if (e.code == 'weak-password')    msg = 'Password is too weak.';
      if (e.code == 'invalid-email')    msg = 'Invalid email address.';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 50),
          Image.asset('assets/images/creamLogo.png', width: 130, height: 130),
          const SizedBox(height: 10),
          const Text('UITriplexa', style: TextStyle(fontFamily: 'Nunito', fontSize: 30, fontWeight: FontWeight.bold, color: Colorpalette.cream)),
          const Text('Plan Every Step', style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: 30),

          // toggle
          Container(
            width: 200, height: 45, padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFBFD0D8), borderRadius: BorderRadius.circular(30)),
            child: Row(children: [
              Expanded(child: GestureDetector(onTap: () => setState(() => isLogin = true),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: isLogin ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                      child: Text('Login', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 18,
                          color: isLogin ? Colorpalette.steelBlue : Colors.white))))),
              Expanded(child: GestureDetector(onTap: () => setState(() => isLogin = false),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: !isLogin ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                      child: Text('Signup', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 18,
                          color: !isLogin ? Colorpalette.steelBlue : Colors.white))))),
            ]),
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 30),
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Colorpalette.cream,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(35), bottomLeft: Radius.circular(35))),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 10),
                const Text('   EMAIL ADDRESS', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 16, color: Colorpalette.warmTerracotta)),
                const SizedBox(height: 3),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldStyle('User@example.com'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                const Text('   PASSWORD', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 16, color: Colorpalette.warmTerracotta)),
                const SizedBox(height: 3),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: _fieldStyle('••••••••••••'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 8) return 'Password must be at least 8 characters';
                    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least one uppercase letter';
                    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least one number';
                    return null;
                  },
                ),

                if (isLogin)
                  Align(alignment: Alignment.centerRight,
                      child: TextButton(onPressed: () {},
                          child: const Text('Forgot password?', style: TextStyle(fontFamily: 'Nunito', fontSize: 15, color: Colorpalette.steelBlue, fontWeight: FontWeight.bold))))
                else
                  const SizedBox(height: 32),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      )),
    );
  }
}
