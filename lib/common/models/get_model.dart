import '../utils/enums.dart';

class GetModel {
  final From? from;
  final String? keyword;
  final String? genre;
  final String? actor;
  final Object? extra;
  const GetModel({
    this.from = From.home,
    this.keyword,
    this.actor,
    this.genre,
    this.extra,
  });
}
