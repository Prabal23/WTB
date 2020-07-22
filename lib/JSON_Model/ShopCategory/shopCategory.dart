import 'package:json_annotation/json_annotation.dart';

part 'shopCategory.g.dart';

@JsonSerializable()
class ShopCategory {
  List<Cat> cat;
  ShopCategory(this.cat);
  factory ShopCategory.fromJson(Map<String, dynamic> json) =>
      _$ShopCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ShopCategoryToJson(this);
}

@JsonSerializable()
class Cat {
  var id;
  var name;

  Cat(this.id, this.name);
  factory Cat.fromJson(Map<String, dynamic> json) =>
      _$CatFromJson(json);
  Map<String, dynamic> toJson() => _$CatToJson(this);
}
