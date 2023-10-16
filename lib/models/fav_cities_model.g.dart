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
      ..favCityID = fields[0] as int
      ..favCityName = fields[1] as String
      ..favCityCountry = fields[2] as String
      ..favCityLat = fields[3] as String
      ..favCityLong = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, FavCities obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.favCityID)
      ..writeByte(1)
      ..write(obj.favCityName)
      ..writeByte(2)
      ..write(obj.favCityCountry)
      ..writeByte(3)
      ..write(obj.favCityLat)
      ..writeByte(4)
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
