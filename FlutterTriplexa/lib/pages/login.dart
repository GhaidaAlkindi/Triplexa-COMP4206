import 'package:flutter/material.dart';
import 'package:triplexa/pages/homePage.dart';
import '../model/colorPalette.dart';

class login extends StatefulWidget {  //for the toggle button
  const login({super.key});           //constructor
  @override
  State<StatefulWidget> createState() => loginState();
}

class loginState extends State<login>{
  bool isLogin =true;                 //when the toggle is active to login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 50),   //create a space for the top
          Image.asset('assets/images/creamLogo.png', width: 130, height: 130,), //logo
          const SizedBox(height: 10),   //create a space below the logo
          const Text('Triplexa'         //display the title
            , style: TextStyle(fontFamily:'Nunito', fontSize: 30, fontWeight: FontWeight.bold, color: Colorpalette.cream),),
          const Text('Plan Every Step'  //display the slogan
            , style: TextStyle(fontFamily:'Nunito', fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
          const SizedBox(height: 30),   //create a space before the form

          Container(                    //login and sigh up toggle
            width: 200, height: 45, padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFBFD0D8), borderRadius: BorderRadius.circular(30)
            ),
            child: Row(children: [      //create the toggle buttons
              Expanded(child: GestureDetector(onTap:() => setState(() => isLogin=true),
                child: Container(       //the login button
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isLogin? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text('Login',
                    style: TextStyle(fontFamily:'Nunito',fontWeight: FontWeight.bold, fontSize:18,
                        color:isLogin ? Colorpalette.steelBlue : Colors.white)),
                  ),
                ),
              ),

              Expanded(child: GestureDetector(onTap:() => setState(() => isLogin= false),
                child: Container(       //the signup button
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: !isLogin? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text('Signup',
                      style: TextStyle(fontFamily:'Nunito',fontWeight: FontWeight.bold, fontSize:18,
                          color:!isLogin ? Colorpalette.steelBlue : Colors.white)),
                ),
              ),
              ),                          //end of the toggle buttons
              
            ],),
          ),

          const SizedBox(height: 30),                 //create a space before the form

          Container(
            width: double.infinity,                   //take full available width
            margin: const EdgeInsets.only(left: 30),  //moving the container to the right
            padding: const EdgeInsets.all(15),        //spacing inside the container
            decoration: const BoxDecoration(color: Colorpalette.cream,
              borderRadius: BorderRadius.only(        //giving the container 2 sides radius
                topLeft: Radius.circular(35), bottomLeft: Radius.circular(35),
              )
            ),

            child: Column(                        //create the form vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),      //ENAIL field
                const Text('   EMAIL ADDRESS', style:TextStyle( fontFamily: 'Nunito',fontWeight: FontWeight.bold,
                  fontSize: 16, color: Colorpalette.warmTerracotta)),
                const SizedBox(height: 3,),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'User@example.com',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta,width: 1.8)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 1.8)),
                  ),
                ),

                const SizedBox(height: 10,),    //PASSWORD field
                const Text('   PASSWORD', style:TextStyle( fontFamily: 'Nunito',fontWeight: FontWeight.bold,
                    fontSize: 16, color: Colorpalette.warmTerracotta)),
                const SizedBox(height: 3,),
                TextField(
                  obscureText: true,            //hide the password
                  decoration: InputDecoration(hintText: '••••••••••••',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14
                  ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta,width: 2)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colorpalette.warmTerracotta, width: 2)),
                  ),
                ),

                if(isLogin)                     //Forgot password display button in login state
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
                SizedBox(                                            //button shape
                  width: double.infinity, height: 50,
                  child:  ElevatedButton(onPressed:(){
                    Navigator.push(                                  //new route om the stack
                        context,MaterialPageRoute(                   //fot the page transition
                            builder:(context) => const trips()       //call the trips page
                        )
                    );
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colorpalette.warmTerracotta, elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                    child: Text(isLogin? 'Login': 'Sign Up',          //display the button text
                        style: const TextStyle(fontFamily:'Nunito', fontSize:20, fontWeight: FontWeight.bold, color: Colors.white )),
                  ),
                ),


              ],
            ),
          )

        ],),
      )),
    );
  }
}