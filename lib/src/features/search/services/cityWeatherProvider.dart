// ignore_for_file: file_names
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../api/api_key.dart';
import '../model/modelClassCity.dart';

final cityWeatherProvider =
    FutureProvider.family<CityWeatherModel, String>((ref, city) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey&lang=vi'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return CityWeatherModel.fromJson(json);
  } else {
    throw Exception('Failed to load weather data');
  }
});
