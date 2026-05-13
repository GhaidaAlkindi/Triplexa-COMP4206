import 'package:flutter/material.dart';
import '/model/colorPalette.dart';

class Sharedwidgets{


  static Widget buildHeader(String title, String details){
    return Container(
      width: double.infinity,                               //the top bar width is all covered
      decoration: const BoxDecoration(
        color: Colorpalette.steelBlue, 
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))
      ),
      padding: const EdgeInsets.only(bottom: 20),           //space the bottom only
      child: SafeArea(
        bottom: false,                                      //only padding for the status bar
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), //left and right padding
          child:Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              if (onClose != null)                            // show X only if onClose is provided
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              Text(title, style: const TextStyle( fontFamily: 'Nunito',fontWeight: FontWeight.bold,
                fontSize: 26, color: Colors.white),),       //print the ttile
              Text(details, style: const TextStyle( fontFamily: 'Nunito',
                  fontSize: 20, color: Colors.white70),),   //print the details
            ],
          )
      )),
    );
  }                                                         //end of buildHeader

  static Widget buildFooter(int index, Function(int) onTap){
    const icons=[                                           //the bottom 3 icons
      {'icon': Icons.airplanemode_active_rounded, 'label':'Trips'},
      {'icon': Icons.location_city_rounded, 'label':'Cities'},
      {'icon': Icons.calendar_month_rounded, 'label':'Days'} ];

    return Container(
      height: 80,                                           //the whole bar
      decoration: const BoxDecoration( color: Colorpalette.warmTerracotta,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceAround,    //to spread the row elements
        children:[
          for (int i = 0; i < icons.length; i++)
            GestureDetector(
              onTap: () => onTap(i),                        //tell the page which page is taped
              child:AnimatedContainer( duration: const Duration(milliseconds: 200), //smooth animtion
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(                  //highlighting the cliked icon
                  color: i == index? Colors.white24 :Colors.transparent,
                  borderRadius: BorderRadius.circular(40),),
                child:Column( mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icons[i]['icon'] as IconData,      //the clicked icon is bigger
                        color: Colors.white,  size: i == index ? 30:25),
                    Text(icons[i]['label'] as String,       //print the icon texts
                        style: TextStyle( fontFamily:'DMSans', fontSize: 13,color: Colors.white,))
                  ],
                ), ),
            ),
        ],
      ), );
  }
}


