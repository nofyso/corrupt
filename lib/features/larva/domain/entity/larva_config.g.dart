// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'larva_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LarvaConfig _$LarvaConfigFromJson(Map<String, dynamic> json) => LarvaConfig(
  operations: (json['operations'] as List<dynamic>)
      .map((e) => const _OperationTypeConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  clips: (json['clips'] as List<dynamic>)
      .map((e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
      .toList(),
  values: json['values'] as Map<String, dynamic>,
);

Map<String, dynamic> _$LarvaConfigToJson(LarvaConfig instance) => <String, dynamic>{
  'operations': instance.operations.map(const _OperationTypeConverter().toJson).toList(),
  'clips': instance.clips,
  'values': instance.values,
};

ClipOperation _$ClipOperationFromJson(Map<String, dynamic> json) => ClipOperation(
  x: (json['x'] as num).toInt(),
  y: (json['y'] as num).toInt(),
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
)..type = json['type'] as String;

Map<String, dynamic> _$ClipOperationToJson(ClipOperation instance) => <String, dynamic>{
  'type': instance.type,
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
};

ConvolutionOperation _$ConvolutionOperationFromJson(Map<String, dynamic> json) =>
    ConvolutionOperation(
      kernel: (json['kernel'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
          .toList(),
    )..type = json['type'] as String;

Map<String, dynamic> _$ConvolutionOperationToJson(ConvolutionOperation instance) =>
    <String, dynamic>{'type': instance.type, 'kernel': instance.kernel};

TwoValuationOperation _$TwoValuationOperationFromJson(Map<String, dynamic> json) =>
    TwoValuationOperation(threshold: json['threshold'] as num)..type = json['type'] as String;

Map<String, dynamic> _$TwoValuationOperationToJson(TwoValuationOperation instance) =>
    <String, dynamic>{'type': instance.type, 'threshold': instance.threshold};

ReverseOperation _$ReverseOperationFromJson(Map<String, dynamic> json) =>
    ReverseOperation()..type = json['type'] as String;

Map<String, dynamic> _$ReverseOperationToJson(ReverseOperation instance) => <String, dynamic>{
  'type': instance.type,
};
