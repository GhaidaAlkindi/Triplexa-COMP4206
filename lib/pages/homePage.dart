import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uitriplexa/pages/trip.dart';
import 'package:uitriplexa/pages/login.dart';
import '../model/colorPalette.dart';
import '../model/Trip.dart';
import '../model/listOfTrips.dart';
import 'package:uitriplexa/sharedWidgets.dart';
import 'package:uitriplexa/pages/dayPlanner.dart';

class trips extends StatefulWidget {                            //the trips page
  const trips({super.key});
  @override
  State<trips> createState() => tripState();
}

class tripState extends State<trips> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();              //to open the drawer from the header

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);    //3 tabs for the trip statuses
  }

  @override
  void dispose() {
    _tabController.dispose();                                   //clean up
    super.dispose();
  }

  final List<Trip> tripslist = List.from(listOfTrips);

  Color statusColor(String status){                             //a function to return the color baced on status
    switch(status){
      case 'active': return Colorpalette.sageGreen;
      case 'planning': return Colorpalette.warmTerracotta;
      default: return Colorpalette.steelBlue; }                //for the history status
  }

  String statusLabel(String status) {                          //return the label
    switch (status) {
      case 'active': return 'Active';
      case 'planning': return 'Planning';
      default: return 'History';
    }
  }

  Widget statBox(String val, String lbl){
    return Column(children: [                                  //to print the top statisics summary
      Text(val,style: const TextStyle(                         //print the number
              fontFamily: 'Nunito',fontSize: 17,
              fontWeight: FontWeight.bold, color:Colors.white),),
      Text(lbl, style: const TextStyle(                        //print the stat name
              fontFamily: 'DMSans', fontSize: 15, color: Colors.white)),
    ]); }

  Widget verticalDiv() =>                                      //dividing the statisics using a vertical line
      Container(width: 1, height: 26, color: Colorpalette.lightGray);

  Widget headerBar() {
    final cities = 7;                                          //to displya on top
    final places = 24;

    return Container(                                          //the top navigation bar
      width: double.infinity,                                  //the whole screen
      decoration: const BoxDecoration(
        color: Colorpalette.steelBlue,                         //the bar color
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)), ),
      padding: const EdgeInsets.only(bottom:20),
      child: SafeArea( bottom: false,                          //only pad the top
        child: Padding( padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [ const SizedBox(height: 12),
              Row(                                             //a row for the greetng
                crossAxisAlignment: CrossAxisAlignment.start,  //align everything to the top
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),    //nudge the icon down a little
                    child: GestureDetector(                    //menu icon to open the drawer
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: const Icon(Icons.menu_rounded, color: Colors.white, size: 26))),
                  const SizedBox(width: 10),
                  const Expanded(child: Column(               //column for the greeting and the user
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning',style: TextStyle(
                              fontFamily: 'Nunito', fontSize: 16,color: Colors.white)),
                      Text('User',style: TextStyle(
                          fontFamily: 'Nunito', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  )),
                  CircleAvatar( radius: 22,                   //for the user profile picture
                    backgroundColor: Colors.white24,
                    child:const Icon(Icons.person, color: Colors.white, size: 26),
                  ), ],
              ),

              const SizedBox(height: 10),                     //seprate the greeting from the statistics

              Container(                                      //print statistics bar
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration( color: Colors.white12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [                                 //print the summary with dividors
                    statBox('${tripslist.length}','Trips'),
                    verticalDiv(),                            //divide between the stats
                    statBox('$cities','Cities'),
                    verticalDiv(),  statBox('$places','places'),
                  ],),
              ),

            ],
          ),
        ),
      ),
    );                                                        //end of the navigation bar
  }

  void _deleteTrip(Trip trip) {                              //alert dialog before deleting
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Delete "${trip.name}"?', style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
      content: Text('This will remove ${trip.name} and all its data.', style: const TextStyle(fontFamily: 'DMSans')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),           //cancel
          child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        TextButton(
          onPressed: (){
            setState(() => tripslist.remove(trip));          //remove the trip
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(      //snackbar after delete
              SnackBar(content: Text('"${trip.name}" deleted'),
                backgroundColor: Colorpalette.warmTerracotta,
                behavior: SnackBarBehavior.floating));
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _addTrip() {                                          //dialog form for adding a new trip
    final nameCtrl  = TextEditingController();
    final datesCtrl = TextEditingController();
    final flagCtrl  = TextEditingController(text: '🌍');
    String selectedStatus = 'planning';
    XFile? pickedImage;                                      //photo picked from gallery

    showDialog(context: context, builder: (ctx) =>
      StatefulBuilder(builder: (ctx, setStateDialog) =>
        Theme(                                               //override the default purple flutter colors
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: Colorpalette.steelBlue)),
          child: AlertDialog(
          title: const Text('Add New Trip', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [

            GestureDetector(                                 //photo picker at the top of the dialog
              onTap: () async {
                final XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked == null) return;
                final ext = picked.path.split('.').last.toLowerCase();
                if (!['jpg','jpeg','png'].contains(ext)) return;  //only jpg and png allowed
                final bytes = await picked.readAsBytes();
                if (bytes.length > 5 * 1024 * 1024) return;       //max 5mb
                setStateDialog(() => pickedImage = picked);
              },
              child: Container(
                height: 110, width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colorpalette.cream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)),
                child: pickedImage != null
                  ? ClipRRect(                               //show the selected image preview
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(File(pickedImage!.path), fit: BoxFit.cover, width: double.infinity))
                  : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.add_photo_alternate_rounded, size: 32, color: Colors.grey),
                      SizedBox(height: 6),
                      Text('Add trip photo', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colors.grey)),
                    ]),
              )),

            TextField(controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Trip Name', hintText: 'e.g. Japan 2026')),
            TextField(controller: datesCtrl,
              decoration: const InputDecoration(labelText: 'Dates', hintText: 'e.g. Apr 10-24')),
            TextField(controller: flagCtrl,
              decoration: const InputDecoration(labelText: 'Flag Emoji', hintText: '🌍')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(                 //status dropdown
              value: selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'planning', child: Text('Planning')),
                DropdownMenuItem(value: 'active',   child: Text('Active')),
                DropdownMenuItem(value: 'history',  child: Text('History')),
              ],
              onChanged: (v) => setStateDialog(() => selectedStatus = v!)),
          ])),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
            TextButton(
              onPressed: (){
                if(nameCtrl.text.trim().isEmpty) return;    //dont add if name is empty
                setState(() => tripslist.add(Trip(
                  name: nameCtrl.text.trim(),
                  dates: datesCtrl.text.trim(),
                  cities: 0, days: 0,
                  flag: flagCtrl.text.trim(),
                  status: selectedStatus,
                  imagePath: pickedImage?.path ?? '')));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showMaterialBanner( //banner after adding
                  MaterialBanner(
                    content: Text('"${nameCtrl.text.trim()}" added to your trips!',
                      style: const TextStyle(fontFamily: 'DMSans')),
                    backgroundColor: Colorpalette.sageGreen.withOpacity(0.15),
                    leading: const Icon(Icons.check_circle, color: Colorpalette.sageGreen),
                    actions: [ TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                      child: const Text('OK', style: TextStyle(color: Colorpalette.sageGreen)))],
                  ));
              },
              child: const Text('Add', style: TextStyle(color: Colorpalette.steelBlue, fontWeight: FontWeight.bold))),
          ],
        ))));
  }

  Widget statuspill(String status) {                         //for the status print: planning, active..
    return Container(                                        //pill container
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor(status).withOpacity(0.15),        //making the pill transparent
        borderRadius:BorderRadius.circular(30), ),
      child: Text(                                           //print the text
        statusLabel(status),
        style: TextStyle(
            fontFamily: 'Nunito', fontSize: 14,fontWeight: FontWeight.bold, color: statusColor(status)),
      ),
    );
  }

  Widget tripContainer(Trip trip){
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/cities'), //tap the card to go to cities
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0,2))]),
        child: ClipRRect(                                    //clip so photo corners follow card radius
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(                            //image strecthes to match content height
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

              if(trip.imagePath.isNotEmpty)                  //local photo picked from gallery
                Image.file(File(trip.imagePath),
                  width: 90, fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => const SizedBox())
              else if(trip.imageUrl.isNotEmpty)              //network photo for existing trips
                Image.network(trip.imageUrl,
                  width: 90, fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => const SizedBox()),

              Expanded(child: Padding(                       //all the text content on the right
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Expanded(child: Column(                    //flag + name + details
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(trip.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Flexible(child: Text(trip.name,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 18,
                            fontWeight: FontWeight.bold, color: Colorpalette.warmTerracotta))),
                      ]),
                      const SizedBox(height: 3),
                      Text('${trip.dates} · ${trip.cities} ${trip.cities==1?'city':'cities'} · ${trip.days} days',
                        style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, color: Colorpalette.steelBlue)),
                    ])),

                  Column(                                    //X then pill stacked on the right
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _deleteTrip(trip),
                        child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                      const SizedBox(height: 8),
                      statuspill(trip.status),
                    ]),

                ]))),

            ]),
          ),
        ),
      ),
    ); }

  Widget tripGridCard(Trip trip) {                           //card design for the history grid
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0,3))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(                                       //photo section with overlays
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(children: [

                trip.imageUrl.isNotEmpty                     //destination photo
                  ? Image.network(trip.imageUrl, height: 105, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_,__,___) => Container(height: 105,
                        color: Colorpalette.steelBlue.withOpacity(0.2),
                        child: Center(child: Text(trip.flag, style: const TextStyle(fontSize: 40)))))
                  : Container(height: 105, color: Colorpalette.steelBlue.withOpacity(0.2),
                      child: Center(child: Text(trip.flag, style: const TextStyle(fontSize: 40)))),

                Positioned(                                  //gradient fade at bottom of photo
                  bottom: 0, left: 0, right: 0,
                  child: Container(height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.45), Colors.transparent])))),

                Positioned(                                  //flag sitting on the gradient
                  bottom: 7, left: 10,
                  child: Text(trip.flag, style: const TextStyle(fontSize: 22))),

                Positioned(                                  //X delete button on photo
                  top: 7, right: 7,
                  child: GestureDetector(
                    onTap: () => _deleteTrip(trip),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 13, color: Colors.white)))),
              ])),

            Padding(                                         //text info below the photo
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.name,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 14,
                      fontWeight: FontWeight.bold, color: Colorpalette.warmTerracotta)),
                  const SizedBox(height: 3),
                  Text('${trip.dates} · ${trip.days}d',
                    style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, color: Colorpalette.steelBlue)),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight,
                    child: statuspill(trip.status)),
                ])),

          ])));
  }

  Widget section(String ttl, List<Trip> lst){               //divide section ACTIVE, PLANNING and HISTORY
    if (lst.isEmpty) {
      return const SizedBox.shrink(); }                     //if no trips in the section we shrink the space
    return Column(                                          //else we display
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ Padding(
          padding: const EdgeInsets.only(left: 30, top: 18),
          child: Text(ttl,                                  //print the section TITLE
              style: const TextStyle( fontFamily: 'Nunito', fontSize: 14,
                  fontWeight: FontWeight.w600,              //semibold
                  color: Colors.grey, letterSpacing:1.4)), ),

        for(int i=0; i<lst.length;i++)                     //print all the trips in the section
          tripContainer(lst[i])
      ],
    ); }

  @override                                                  //building the page
  Widget build(BuildContext context) {
    final active = tripslist.where((t) => t.status =='active').toList();    //seprate the trips by their status
    final planning = tripslist.where((t) => t.status =='planning').toList();
    final history= tripslist.where((t) => t.status =='history').toList();

    return Scaffold(
      key: _scaffoldKey,                                     //needed to open the drawer from the header
      backgroundColor: Colorpalette.cream,
      drawer: Drawer(
        backgroundColor: Colorpalette.cream,
        child: ListView(children: [
          DrawerHeader(                                      //the top part of the drawer
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(color: Colorpalette.steelBlue),
            child: Stack( children: [                        //stack the logo image behind the text
              Positioned.fill(
                child: Image.asset('assets/images/creamLogo.png', //local png asset
                  fit: BoxFit.contain, opacity: const AlwaysStoppedAnimation(0.4))),
              Padding( padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('Triplexa', style: TextStyle(fontFamily: 'Nunito', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Plan Every Step', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.white70)),
                  ],),),
            ])),

          ListTile(                                          //stay on trips page
            leading: const Icon(Icons.airplanemode_active_rounded, color: Colorpalette.steelBlue),
            title: const Text('My Trips', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: Colorpalette.steelBlue)),
            onTap: () => Navigator.pop(context)),

          ListTile(                                          //log out and go back to login
            leading: const Icon(Icons.logout_rounded, color: Colorpalette.steelBlue),
            title: const Text('Log Out', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: Colorpalette.steelBlue)),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            }),

          const Divider(),

          ListTile(                                          //close the drawer
            leading: const Icon(Icons.close_rounded, color: Colors.grey),
            title: const Text('Cancel', style: TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
            onTap: () => Navigator.pop(context)),
        ],),
      ),
      body:Column( children: [
        headerBar(),                                         //display the top bar

          TabBar(                                            //the status tabs below the blue header
            controller: _tabController,
            labelColor: Colorpalette.warmTerracotta,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colorpalette.warmTerracotta,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,               //hide the grey line
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Planning'),
              Tab(text: 'History'),
            ],),

          Expanded(                                          //each tab shows its trips
            child: TabBarView( controller: _tabController,
              children: [
                ListView(padding: const EdgeInsets.only(bottom:80),   //active trips
                  children: [ for(final t in active) tripContainer(t) ]),
                ListView(padding: const EdgeInsets.only(bottom:80),   //planning trips
                  children: [ for(final t in planning) tripContainer(t) ]),
                GridView.count(                              //history shown as a responsive grid
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2, //3 cols in landscape
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                  children: [ for(final t in history) tripGridCard(t) ]),
              ],),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(           //the + button for adding a trip
        onPressed: () => _addTrip(),
        backgroundColor: Colorpalette.warmTerracotta,
        elevation: 2,                                       //shadow 2
        shape: const CircleBorder(),                        //make it circle
        child:const Icon(Icons.add, color: Colors.white, size: 28)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, //float above the bar

      bottomNavigationBar: BottomAppBar(                    //0 means trips is active
        color: Colorpalette.warmTerracotta,
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(                                //we are here
              onTap: null,
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.airplanemode_active_rounded, color: Colors.white, size: 22),
                Text('Trips', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white)),
              ])),
            GestureDetector(                                //go to cities
              onTap: () => Navigator.pushReplacementNamed(context, '/cities'),
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.location_city_rounded, color: Colors.white60, size: 22),
                Text('Cities', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
            GestureDetector(                                //go to days
              onTap: () => Navigator.pushReplacementNamed(context, '/dayplanner'),
              child: const Column( mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_month_rounded, color: Colors.white60, size: 22),
                Text('Days', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: Colors.white60)),
              ])),
          ],
        ),
      )
    );
  }
}
