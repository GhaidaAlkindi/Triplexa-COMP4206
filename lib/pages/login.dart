import 'package:flutter/material.dart';
import '../model/colorPalette.dart';

class login extends StatefulWidget {                    //for the toggle button
  const login({super.key});                             //constuctor
  @override
  State<StatefulWidget> createState() => loginState();
}

class loginState extends State<login>{
  bool isLogin = true;                                  //when the toggle is active to login
  final _formKey = GlobalKey<FormState>();              //for form validtion

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 50),                   //create a space for the top
          Image.asset('assets/images/creamLogo.png', width: 130, height: 130,), //logo
          const SizedBox(height: 10),                   //create a space below the logo
        const Text('UITriplexa'                       //display the title
            , style: TextStyle(fontFamily:'Nunito', fontSize: 30, fontWeight: FontWeight.bold, color: Colorpalette.cream),),
          const Text('Plan Every Step'                  //display the slogan
            , style: TextStyle(fontFamily:'Nunito', fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
          const SizedBox(height: 30),                   //create a space before the form

          Container(                                    //login and sign up toggle
           width: 200, height: 45, padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFBFD0D8), borderRadius: BorderRadius.circular(30)),
            child: Row(children: [                      //create the toggle buttons
              Expanded(child: GestureDetector(onTap:() => setState(() => isLogin=true),
                child: Container(                       //the login button
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isLogin? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(25)),
                  child: Text('Login',
                    style: TextStyle(fontFamily:'Nunito',fontWeight: FontWeight.bold, fontSize:18,
                        color:isLogin ? Colorpalette.steelBlue : Colors.white)),
                  ))),
              Expanded(child: GestureDetector(onTap:() => setState(() => isLogin= false),
                child: Container(                       //the signup button
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: !isLogin? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text('Signup',
                      style: TextStyle(fontFamily:'Nunito',fontWeight: FontWeight.bold, fontSize:18,
                          color:!isLogin ? Colorpalette.steelBlue : Colors.white)),
                )),
              ),                                        //end of the toggle buttons
            ],),
          ),

          const SizedBox(height: 30),                   //create a space before the form

          Container(
            width: double.infinity,                     //take full available width
            margin: const EdgeInsets.only(left: 30),    //moving the container to the right
            padding: const EdgeInsets.all(15),          //spacing inside the container
            decoration: const BoxDecoration(color: Colorpalette.cream,
              borderRadius: BorderRadius.only(          //giving the container 2 sides radius
                topLeft: Radius.circular(35), bottomLeft: Radius.circular(35),
              )),
            child: Form(                                //wrap fields in a Form for validation
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const Text('   EMAIL ADDRESS', style:TextStyle( fontFamily: 'Nunito',fontWeight: FontWeight.bold,
                    fontSize: 16, color: Colorpalette.warmTerracotta)),
                  const SizedBox(height: 3,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldStyle('User@example.com'),
                    validator:(value) {                //email validtion
                      if (value == null ||value.isEmpty) return 'Email is required';
                      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                      if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
                      return null;
                    },
                  ),

                  const SizedBox(height: 10,),
                  const Text('   PASSWORD', style:TextStyle( fontFamily: 'Nunito',fontWeight: FontWeight.bold,
                      fontSize: 16, color: Colorpalette.warmTerracotta)),
                  const SizedBox(height: 3,),
                  TextFormField(
                    obscureText: true,                  //hide the password
                    decoration: _fieldStyle('••••••••••••  '),
                    validator: (value) {                //password validation
                     if (value == null || value.isEmpty) return 'Password is required';
                      if(value.length < 8) return 'Password must be at least 8 characters';
                      if(!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least one uppercase letter';
                      if(!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least one number';
                      return null;
                    },
                  ),

                  if(isLogin)                           //Forgot password display button in login state
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){},
                          child: const Text('Forgot password?',
                          style: TextStyle(fontFamily:'Nunito',fontSize:15, color: Colorpalette.steelBlue, fontWeight: FontWeight.bold),
                          )),
                    )
                  else
                    const SizedBox(height: 32,),
                  const SizedBox(height: 10,),
                  SizedBox(                             //button shape
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {    //validate before going home
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text(isLogin? 'Login': 'Sign Up',     //display the button text
                          style: const TextStyle(fontFamily:'Nunito', fontSize:20, fontWeight: FontWeight.bold, color: Colors.white )),
                    ),
                  )]),
            ))

        ],),
      )),
    );
  }
}
