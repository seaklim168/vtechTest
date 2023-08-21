import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class ItemModel {
  ItemModel();

  @HiveField(0, defaultValue: 0)
  int? id;

  @HiveField(1, defaultValue: '')
  String? strId;

  @HiveField(2, defaultValue: '')
  String? title;

  @HiveField(3, defaultValue: false)
  bool? isCompleted;
}
