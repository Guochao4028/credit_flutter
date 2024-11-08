/// *
/// -  @Date: 2022-09-07 15:27
/// -  @LastEditTime: 2022-09-07 15:41
/// -  @Description:
///
/// *
/// -  @Date: 2022-09-07 15:27
/// -  @LastEditTime: 2022-09-07 15:27
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'person_management_list_model.g.dart';

@JsonSerializable()
class PersonManagementListModel extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<PersonManagementListItemModel> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  PersonManagementListModel(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory PersonManagementListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PersonManagementListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PersonManagementListModelToJson(this);
}

@JsonSerializable()
class PersonManagementListItemModel extends Object {
  @JsonKey(name: 'companyId')
  int companyId;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'jobTitle')
  String jobTitle;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'updateTimeTs')
  int updateTimeTs;

  @JsonKey(name: 'userId')
  int userId;

  PersonManagementListItemModel(
    this.companyId,
    this.createTimeTs,
    this.id,
    this.jobTitle,
    this.name,
    this.phone,
    this.status,
    this.updateTimeTs,
    this.userId,
  );

  factory PersonManagementListItemModel.fromJson(
          Map<String, dynamic> srcJson) =>
      _$PersonManagementListItemModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PersonManagementListItemModelToJson(this);
}
