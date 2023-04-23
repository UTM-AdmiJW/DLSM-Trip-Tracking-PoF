


/// Every model that is stored in the database should implement this interface.
abstract class SqfliteModel {
  int? id;

  SqfliteModel({this.id});

  Map<String, dynamic> toMap();
}