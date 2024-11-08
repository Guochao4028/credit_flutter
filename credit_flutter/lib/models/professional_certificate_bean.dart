import 'package:json_annotation/json_annotation.dart'; 
  
part 'professional_certificate_bean.g.dart';


@JsonSerializable()
  class ProfessionalCertificateBean extends Object {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'content')
  List<ProfessionalCertificateContent> content;

  @JsonKey(name: 'explain')
  String explain;

  ProfessionalCertificateBean(this.name,this.content,this.explain,);

  factory ProfessionalCertificateBean.fromJson(Map<String, dynamic> srcJson) => _$ProfessionalCertificateBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProfessionalCertificateBeanToJson(this);

}

  
@JsonSerializable()
  class ProfessionalCertificateContent extends Object {

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'content')
  String content;

  ProfessionalCertificateContent(this.title,this.content,);

  factory ProfessionalCertificateContent.fromJson(Map<String, dynamic> srcJson) => _$ProfessionalCertificateContentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProfessionalCertificateContentToJson(this);

}

  
