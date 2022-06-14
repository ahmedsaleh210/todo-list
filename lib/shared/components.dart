import 'package:flutter/material.dart';
import 'package:todo_list/layout/cubit/cubit.dart';

Widget defaultButton(
    {
  double width = double.infinity,
  Color background = Colors.blue,
  required Function function,
  required String text,
    }) =>
    Container(
  color: Colors.blue,
  child: MaterialButton(onPressed: function(),
      child: const Text(
        'LOGIN',
        style: TextStyle(
            color: Colors.white
        ),

      )
  ),
);

Widget defaultformfield (context,{
  required TextEditingController controller,
  required TextInputType type,
  Function(String val)? onchanged,
  Function? onSupmited,

  required FormFieldValidator validator,
  required String label,
  required IconData prefix,
  Function? onTap,
  IconData? suffix,
  bool isClickable=false,
  bool secure = false,
}

) =>
    TextFormField(
      controller: controller,
      obscureText: secure,
      keyboardType: type,
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold
      ),

      decoration: InputDecoration(
        labelStyle: const TextStyle(
            color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
        labelText: label,
        prefixIcon: Icon(prefix,
        color: Colors.grey,
        ),
        suffixIcon: suffix != null ? Icon(suffix,) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),

        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),

      ),
      readOnly: isClickable,
      onChanged: onchanged,
      onTap: onTap!=null? (){onTap();}:null,
      validator: validator,

    );

var h = 1;
Widget buildTaskItem(Map model,context,Color color,bool doneVisible,bool archiveVisible) => Dismissible(
  key: Key(model['id'].toString()),

  background: Container(
    color: Colors.red,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: const [
          Icon(Icons.delete, color: Colors.white),
          Text('Move to trash', style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  ),
secondaryBackground: archiveVisible == true ? Container(
  color: Colors.blue,
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Icon(Icons.delete, color: Colors.white),
        Text('Move to Archive', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
) : Container(
  color: Colors.lightGreen,
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Icon(Icons.delete, color: Colors.white),
        Text('Move to Done Tasks', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
) ,
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          foregroundColor: Colors.white,

          backgroundColor: color,

          radius: 40.0,

          child:

          Text(model['time'],

          style: const TextStyle(fontWeight: FontWeight.bold),),

        ),

        const SizedBox(width: 20.0,),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(model['title'],

                style: const TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 18.0

                ),

              ),

              Text(model['data'],

                style: const TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        const SizedBox(width: 20,),
        doneVisible == true ? IconButton(onPressed: () {


          {AppCubit.get(context).updateDate(status: 'done', id: model['id']);}

        },
            icon: Icon(Icons.check_box,

        color: Colors.lightGreen[700],)):Container(),

        archiveVisible == true ? IconButton(onPressed: () {

        // if (model['status'] != 'archive') {

         AppCubit.get(context).updateDate(status: 'archive', id: model['id']);
        }, icon: Icon(Icons.archive,

          color: Colors.blue[700],)):Container(),

        IconButton(onPressed: () {

          // if (model['status'] != 'archive') {

          AppCubit.get(context).deleteData(id: model['id'],);

          // }

          // else
          //
          //   showDialog(
          //
          //     context: context,
          //
          //     builder: (BuildContext context) {
          //
          //       return AlertDialog(
          //
          //         title: Text('Attention!',
          //
          //           style: TextStyle(
          //
          //             fontWeight: FontWeight.bold,
          //
          //           ),),
          //
          //         content: Text("This Task Is Already in Archive Tasks",),
          //
          //         actions: [
          //
          //           TextButton(
          //
          //             child: Text("Cancel",
          //
          //             style: TextStyle(color: Colors.red,
          //
          //             fontWeight: FontWeight.bold),),
          //
          //             onPressed: () {Navigator.of(context).pop();},
          //
          //           ),
          //
          //         ],
          //
          //       );
          //
          //     },
          //
          //   );



        }, icon: Icon(Icons.delete,

          color: Colors.red[700],)),

      ],

    ),

  ),
  onDismissed: (direction) {
    if (direction == DismissDirection.startToEnd) {
      AppCubit.get(context).deleteData(id: model['id'],);
    } else if (direction == DismissDirection.endToStart){
      if (model['status'] != 'archive') {
        AppCubit.get(context).updateDate(status: 'archive', id: model['id']);
      } else {
        AppCubit.get(context).updateDate(status: 'done', id: model['id']);
      }
    }
  },
);

 Widget myDivider() =>  Padding(
   padding: const EdgeInsets.symmetric(horizontal: 20.0),
   child: Container(
     height: 1,
     color: Colors.grey[300],
     width: double.infinity,
   ),
 );

    void navigateTo(context,widget) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    }
