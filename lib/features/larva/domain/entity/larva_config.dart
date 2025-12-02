import 'package:json_annotation/json_annotation.dart';

part 'larva_config.g.dart';

@JsonSerializable()
class LarvaConfig {
  @_OperationTypeConverter()
  final List<Operation> operations;
  final List<List<int>> clips;
  final Map<String, dynamic> values;

  LarvaConfig({required this.operations, required this.clips, required this.values});

  factory LarvaConfig.fromJson(Map<String, dynamic> json) => _$LarvaConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LarvaConfigToJson(this);
}

@JsonSerializable(createToJson: false, createFactory: false)
sealed class Operation {
  String type;

  Operation(this.type);

  factory Operation.fromJson(Map<String, dynamic> json) => switch (json["type"]) {
    "clip" => ClipOperation.fromJson(json),
    "convolution" => ConvolutionOperation.fromJson(json),
    "two_valuation" => TwoValuationOperation.fromJson(json),
    "reverse" => ReverseOperation.fromJson(json),
    _ => throw Exception("Unknown type: ${json['type']}"),
  };
}

@JsonSerializable()
class ClipOperation extends Operation {
  final int x;
  final int y;
  final int width;
  final int height;

  ClipOperation({required this.x, required this.y, required this.width, required this.height})
    : super("clip");

  factory ClipOperation.fromJson(Map<String, dynamic> json) => _$ClipOperationFromJson(json);

  Map<String, dynamic> toJson() => _$ClipOperationToJson(this);
}

@JsonSerializable()
class ConvolutionOperation extends Operation {
  final List<List<num>> kernel;

  ConvolutionOperation({required this.kernel}) : super("convolution");

  factory ConvolutionOperation.fromJson(Map<String, dynamic> json) =>
      _$ConvolutionOperationFromJson(json);

  Map<String, dynamic> toJson() => _$ConvolutionOperationToJson(this);
}

@JsonSerializable()
class TwoValuationOperation extends Operation {
  final num threshold;

  TwoValuationOperation({required this.threshold}) : super("two_valuation");

  factory TwoValuationOperation.fromJson(Map<String, dynamic> json) =>
      _$TwoValuationOperationFromJson(json);

  Map<String, dynamic> toJson() => _$TwoValuationOperationToJson(this);
}

@JsonSerializable()
class ReverseOperation extends Operation {
  ReverseOperation() : super("reverse");

  factory ReverseOperation.fromJson(Map<String, dynamic> json) => _$ReverseOperationFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseOperationToJson(this);
}

class _OperationTypeConverter implements JsonConverter<Operation, Map<String, dynamic>> {
  const _OperationTypeConverter();

  @override
  Operation fromJson(Map<String, dynamic> json) => Operation.fromJson(json);

  @override
  Map<String, dynamic> toJson(Operation object) => throw UnimplementedError();
}
