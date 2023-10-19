// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_cities_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavCitiesAdapter extends TypeAdapter<FavCities> {
  @override
  final int typeId = 0;

  @override
  FavCities read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavCities()
      ..favCityName = fields[0] as String
      ..favCityCountry = fields[1] as String
      ..favCityLat = fields[2] as double
      ..favCityLong = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, FavCities obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.favCityName)
      ..writeByte(1)
      ..write(obj.favCityCountry)
      ..writeByte(2)
      ..write(obj.favCityLat)
      ..writeByte(3)
      ..write(obj.favCityLong);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavCitiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
