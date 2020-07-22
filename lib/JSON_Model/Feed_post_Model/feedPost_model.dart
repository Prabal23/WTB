import 'package:json_annotation/json_annotation.dart';

part 'feedPost_model.g.dart';

@JsonSerializable()
class FeedPost {
  List<Feed> feed;
  var llid;
  var lcid;
  var lsid;
  var sid;
  FeedPost(this.feed, this.lcid, this.llid, this.lsid, this.sid);
  factory FeedPost.fromJson(Map<String, dynamic> json) =>
      _$FeedPostFromJson(json);
  Map<String, dynamic> toJson() => _$FeedPostToJson(this);
}

@JsonSerializable()
class Feed {
  var id;
  @JsonKey(name: "user_id")
  var userId;
  var status;
  var activityType;
  var interest;
  var link;
  var privacy;
  var type;
  var likeCount;
  var commentCount;
  var shareCount;
  var like;
  List<Images> images;
  Fuser fuser;
  Group group;
  Products product;
  Shop shop;
  Offers offer;
  @JsonKey(name: "__meta__")
  final Meta meta;

  Feed(
      this.id,
      this.status,
      this.activityType,
      this.interest,
      this.like,
      this.privacy,
      this.commentCount,
      this.images,
      this.likeCount,
      this.link,
      this.shareCount,
      this.fuser,
      this.type,
      this.meta,
      this.userId,
      this.group,
      this.product,
      this.shop,
      this.offer);

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

@JsonSerializable()
class Images {
  var id;
  var file;
  var thum;
  var type;

  Images(this.id, this.file, this.thum, this.type);
  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Fuser {
  var id;
  var firstName;
  var lastName;
  var userName;
  var profilePic;
  var jobTitle;

  Fuser(this.id, this.firstName, this.lastName, this.userName, this.jobTitle,
      this.profilePic);
  factory Fuser.fromJson(Map<String, dynamic> json) => _$FuserFromJson(json);
  Map<String, dynamic> toJson() => _$FuserToJson(this);
}

@JsonSerializable()
class Group {
  var id;
  var name;
  var about;
  var logo;
  Group(this.id, this.name, this.about, this.logo);
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class Products {
  var id;
  var productName;
  @JsonKey(name: "shop_id")
  dynamic shopId;
  SingleImage singleImage;
  Products(this.id, this.productName, this.shopId, this.singleImage);
  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}

@JsonSerializable()
class SingleImage {
  var id;
  var image;
  SingleImage(this.id, this.image);
  factory SingleImage.fromJson(Map<String, dynamic> json) =>
      _$SingleImageFromJson(json);
  Map<String, dynamic> toJson() => _$SingleImageToJson(this);
}

@JsonSerializable()
class Shop {
  var id;
  var shopName;
  var shopLink;
  var logo;
  Shop(this.id, this.shopName, this.shopLink, this.logo);
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}

@JsonSerializable()
class Offers {
  var id;
  var title;
  var description;
  var price;

  Offers(this.id, this.title, this.description, this.price);
  factory Offers.fromJson(Map<String, dynamic> json) => _$OffersFromJson(json);
  Map<String, dynamic> toJson() => _$OffersToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "totalComments_count")
  dynamic totalCommentsCount;
  @JsonKey(name: "totalLikes_count")
  dynamic totalLikesCount;
  @JsonKey(name: "totalShares_count")
  dynamic totalSharesCount;

  Meta(
    this.totalCommentsCount,
    this.totalLikesCount,
    this.totalSharesCount,
  );
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
