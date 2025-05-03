import 'package:hive/hive.dart';

part 'chicken_data.g.dart';

@HiveType(typeId: 0)
class ChickenData {
  @HiveField(0)
  final int umur;

  @HiveField(1)
  final double berat;

  @HiveField(2)
  final double habisPakan;

  @HiveField(3)
  final int matiAyam;

  @HiveField(4)
  final double fcr;

  ChickenData({
    required this.umur,
    required this.berat,
    required this.habisPakan,
    required this.matiAyam,
    required this.fcr,
  });
}