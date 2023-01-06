import 'package:isar/isar.dart';

part 'email.g.dart';

@collection
class User {
   Id id = Isar.autoIncrement; // you can also use id = null to auto increment

   String? name;

   int? age;

   @override
   String toString() {
      return '$id, $name, $age';
   }
}