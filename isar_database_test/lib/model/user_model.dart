import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  List<UserModel> friends;

  UserModel(this.name, this.age, this.friends);

  @override
  String toString() {
    return '$name, $age, $friends';
  }
}
