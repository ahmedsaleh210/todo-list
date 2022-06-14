import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget
{
  final titleController = TextEditingController();
  final timecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
       listener: (context,state) {
         if (state is AppInsertonDatabase) {
           Navigator.pop(context);
         }
       },
        builder: (context,state) {
       var isSelected = AppCubit.get(context).isSelected;
         return Scaffold(

           key: scaffoldKey,
           appBar: AppBar(
             backgroundColor: Colors.black54,
             title: Center(
               child: Text(
                 AppCubit.get(context).titles[AppCubit.get(context).currentIndex],
               ),
             ),
           ),
           body:
           BuildCondition(
             condition: state is !AppGetdatabaseLoadingState,
             builder: (context) => AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
             fallback: (context) => const Center(child: CircularProgressIndicator()),
           ),
           // AppCubit.get(context).tasks.length == 0 ?
           // Center(child: CircularProgressIndicator())
           //     : AppCubit.get(context).screens[AppCubit.get(context).currentIndex],

           floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
               onPressed: ()
           {
             if (AppCubit.get(context).isBottomSheetShown == true) {
               if(formkey.currentState!.validate()) {
                 AppCubit.get(context).insertToDatabase(
                     title: titleController.text,
                     time: timecontroller.text,
                     date: datecontroller.text); 
               }

             } else
             {
               scaffoldKey.currentState!.showBottomSheet(
                     (context) => Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Container(
                     color: Colors.grey[200],
                     child: Form(
                       key: formkey,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           defaultformfield(context,
                             controller: titleController,
                             type: TextInputType.text,
                             validator: (value) {
                               if (value.isEmpty) {
                                 return 'title is empty';
                               }
                               return null;
                             },
                             label: 'Text Title',
                             prefix: Icons.title,
                           ),
                           const SizedBox(height: 10,),

                           defaultformfield(context,
                               controller: timecontroller,
                               type: TextInputType.text,
                               validator: (value) {
                                 if (value.isEmpty) {
                                   return 'Time is Empty';
                                 }
                                 return null;
                               },
                               label: 'Task Time',
                               isClickable: true,
                               prefix: Icons.watch_later_outlined,
                               onTap: () {
                                 showTimePicker(context: context,
                                     initialTime: TimeOfDay.now()).then((value) {
                                   timecontroller.text = value!.format(context).toString();
                                 });
                               }
                           ),
                           const SizedBox(height: 10,),
                           defaultformfield(context,
                             controller: datecontroller,
                             type: TextInputType.datetime,
                             validator: ( value) {
                               if (value.isEmpty) {
                                 return 'Date is Empty';
                               }
                               return null;
                             },
                             label: 'Task Date',
                             isClickable: true,
                             prefix: Icons.calendar_today,
                             onTap: () {
                               showDatePicker(context: context, initialDate: DateTime.now(),
                                   firstDate: DateTime.now(),
                                   lastDate: DateTime.parse("2026-09-10")
                               ).then((value) {
                                 datecontroller.text = DateFormat.yMMMd().format(value!);
                               });
                             },
                           )

                         ],
                       ),
                     ),
                   ),
                 ),

               ).closed.then((value) {
                 AppCubit.get(context).changeBottomSheetState(
                     isShow: false,
                     icon: Icons.edit);
               });

               AppCubit.get(context).changeBottomSheetState(
                   isShow: true,
                   icon: Icons.add);
             }


           },
               child: Icon(
                 AppCubit.get(context).isBottomSheetShown ? Icons.add : Icons.edit,
               ),
           ),
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
           bottomNavigationBar: BottomAppBar(
             shape: const CircularNotchedRectangle(),
             child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 SizedBox.fromSize(
                   size: const Size(70, 70), // button width and height
                   child: ClipOval(
                     child: Material(
                       color: Colors.white, // button color
                       child: InkWell(
                         splashColor: Colors.grey, // splash color
                         onTap: () {AppCubit.get(context).changeIndex(0);}, // button pressed
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Icon(Icons.menu,
                               size: 25,
                               color: isSelected[0] ? Colors.red : Colors.grey,), // icon

                             const Text("Tasks",
                             style: TextStyle(
                               fontWeight: FontWeight.w800,
                             ),), // text
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox.fromSize(
                   size: const Size(70, 70), // button width and height
                   child: ClipOval(
                     child: Material(
                       color: Colors.white, // button color
                       child: InkWell(
                         splashColor: Colors.grey, // splash color
                         onTap: () {AppCubit.get(context).changeIndex(1);}, // button pressed
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Icon(Icons.check,
                               size: 25,
                               color: isSelected[1] ? Colors.red : Colors.grey,), // icon

                             const Text("Done",
                               style: TextStyle(
                                 fontWeight: FontWeight.w800,
                               ),), // text
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox.fromSize(
                   size: const Size(70, 70), // button width and height
                   child: ClipOval(
                     child: Material(
                       color: Colors.white, // button color
                       child: InkWell(
                         splashColor: Colors.grey, // splash color
                         onTap: () {AppCubit.get(context).changeIndex(2);}, // button pressed
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.archive_outlined,
                               size: 25,
                               color: isSelected[2] ? Colors.red : Colors.grey,), // icon

                             const Text("Archived",
                               style: TextStyle(
                                 fontWeight: FontWeight.w800,
                               ),), // text
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 IconButton(onPressed: () {},
                   icon: const Icon(Icons.settings),
                   iconSize: 30.0,
                   color: isSelected[3] ? Colors.red : Colors.grey,),
               ],
             ),
           ),
         );
        },
      ),
    );
  }
  



}

