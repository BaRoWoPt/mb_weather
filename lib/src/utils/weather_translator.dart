// lib/utils/weather_translator.dart
String translateWeatherCondition(String condition) {
  const Map<String, String> weatherTranslations = {
    "scattered clouds": "mây rải rác",
    "Clear": "Trời quang",
    "Clouds": "Nhiều mây",
    "Rain": "Mưa",
    "Drizzle": "Mưa phùn",
    "Thunderstorm": "Dông bão",
    "Snow": "Tuyết",
    "Mist": "Sương mù",
    "Fog": "Sương dày",
    "Haze": "Khói bụi",
    "Smoke": "Khói",
    "Dust": "Bụi",
    "Squall": "Gió giật",
    "Tornado": "Lốc xoáy"
  };

  return weatherTranslations[condition] ?? condition;
}
