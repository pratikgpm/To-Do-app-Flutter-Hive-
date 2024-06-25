import 'package:hive/hive.dart';
import 'package:do_it/model/notes_model.dart';

class Boxes{
  static Box<NotesModel> getData()=>Hive.box<NotesModel>('myBox');
}