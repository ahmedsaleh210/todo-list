

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/layout/cubit/cubit.dart';
import 'package:todo_list/layout/cubit/states.dart';
import 'package:todo_list/shared/components.dart';


class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state){
        var tasks = AppCubit.get(context).doneTasks;
        return BuildCondition(
          condition: tasks.length > 0 ,
          builder: (context) => Container(
            child: ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(tasks[index],context,Colors.lightGreen,false,true),
                separatorBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                        width: double.infinity,
                      ),
                    ),
                itemCount: tasks.length),
          ),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 100,
                  color: Colors.grey,
                ),
                Text('No Done Tasks Yet',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),)
              ],
            ),
          ) ,
        );
      },
    );
  }
}
