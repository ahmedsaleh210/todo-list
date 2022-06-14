import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/layout/cubit/states.dart';
import 'package:todo_list/modules/archived_tasks/archivedtasks.dart';
import 'package:todo_list/modules/done_tasks/donetasks.dart';
import 'package:todo_list/modules/tasks/tasks.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isBottomSheetShown = false;
  List<bool> isSelected = [true, false, false];
  IconData fabIcon = Icons.edit;
  int currentIndex = 0;
  late Database database;
  List <Map> tasks = [];
  List <Map> doneTasks = [];
  List <Map> archiveTasks = [];

  List <Widget> screens = [
    const TasksScreen(), // index 0
    DoneTasksScreen(), // index 1
    const ArchivedTasksScreen(), // index 2
  ];

  List <String> titles = [
    'Tasks', // index 0
    'Done Tasks', // index 1
    'Archived Tasks', // index 2
  ];

  void changeIndex (int index) {
    currentIndex = index;
    isSelected = [false,false,false,false];
    isSelected[index] = true;
    emit(AppChangeBottomNavBarState());
  }



  void createDatabase() {
    openDatabase('todo.db',
        version:1,
        onCreate:(Database db , int version) async
        {
          print('database created');
          await db.execute('CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)');

          {try {print ('Table Created');} catch (e) {print ('Error when creating Table');}
          }

        },
        onOpen: (database) {
           getDatabase(database);
          print('database opened');
        }

    ).then((value) {
      database=value;
    emit(AppCreateDatabase());
    });
  }

  Future insertToDatabase({
    required String title,
    required  String time,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn.rawInsert('INSERT INTO Tasks (title, data, time, status) VALUES ("$title", "$date", "$time", "New")')
          .then((value)
      {
        print('$value inserted sucessfully');
        emit(AppInsertonDatabase());
        getDatabase(database);
      }).catchError((e){print("error when inserted new record ${e.toString()}");});
      return null;
    }
    );
  }

  void getDatabase (database) {
    tasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetdatabaseLoadingState());
     database.rawQuery('SELECT * FROM Tasks').then((value) {
       value.forEach((element){
         if (element['status'] == 'New') {
           tasks.add(element);
         } else if (element['status'] == 'done') {
           doneTasks.add(element);
         } else {
           archiveTasks.add(element);
         }

       });
       emit(AppGetfromDatabase());
     });
  }

  void updateDate ({
    required String status,
    required int id
  }) async {
        database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        [status, '$id']
      ).then((value) {
        emit(AppUpdateonDatabase());
        getDatabase(database);
      });
  }



  void deleteData ({
    required int id
  }) async {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id])
        .then((value) {
      emit(AppDeleteFromDatabase());
      getDatabase(database);
    });
  }

  
  void changeBottomSheetState (
  {
  required bool isShow,
  required IconData icon,
}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheet());
  }


}