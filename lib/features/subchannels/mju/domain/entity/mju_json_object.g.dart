// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mju_json_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MjuLoginPublicKey _$MjuLoginPublicKeyFromJson(Map<String, dynamic> json) =>
    MjuLoginPublicKey(json['modulus'] as String, json['exponent'] as String);

Map<String, dynamic> _$MjuLoginPublicKeyToJson(MjuLoginPublicKey instance) => <String, dynamic>{
  'modulus': instance.modulus,
  'exponent': instance.exponent,
};

MjuClassEntry _$MjuClassEntryFromJson(Map<String, dynamic> json) => MjuClassEntry(
  json['kcmc'] as String,
  json['xqmc'] as String,
  json['cdmc'] as String,
  json['xm'] as String,
  json['xqj'] as String,
  json['zcd'] as String,
  json['jcs'] as String,
);

Map<String, dynamic> _$MjuClassEntryToJson(MjuClassEntry instance) => <String, dynamic>{
  'kcmc': instance.name,
  'xqmc': instance.place,
  'cdmc': instance.classroom,
  'xm': instance.teacher,
  'xqj': instance.dayOfWeek,
  'zcd': instance.weeks,
  'jcs': instance.classTime,
};

MjuExamEntity _$MjuExamEntityFromJson(Map<String, dynamic> json) => MjuExamEntity(
  json['kcmc'] as String,
  json['kssj'] as String?,
  json['cdmc'] as String?,
  json['zwh'] as String?,
  json['kch'] as String?,
  json['xm'] as String?,
  json['cdxqmc'] as String?,
  json['ksfs'] as String?,
);

Map<String, dynamic> _$MjuExamEntityToJson(MjuExamEntity instance) => <String, dynamic>{
  'kcmc': instance.name,
  'kssj': instance.timeRaw,
  'cdmc': instance.room,
  'zwh': instance.seat,
  'kch': instance.classId,
  'xm': instance.studentName,
  'cdxqmc': instance.campus,
  'ksfs': instance.form,
};
