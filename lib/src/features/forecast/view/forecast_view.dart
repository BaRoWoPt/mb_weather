import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
// import '../../../utils/weather_translator.dart';
import '../../../core/components/common.dart';
import '../../../utils/style.dart';
import '../../dashboard/components/weather_attribute.dart';
import '../../home/data/weather_icon_handler.dart';
import '../data/providers.dart';
import 'package:translator/translator.dart';

final translator = GoogleTranslator();

Future<String> translateText(String text) async {
  try {
    var translation = await translator.translate(text, from: 'en', to: 'vi');
    return translation.text;
  } catch (e) {
    return text; // Trả về văn bản gốc nếu dịch thất bại
  }
}

class ForecastView extends ConsumerStatefulWidget {
  const ForecastView({super.key});

  @override
  ConsumerState<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends ConsumerState<ForecastView> {
  void _showWeatherDetails(BuildContext context, dynamic weatherData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Hero(
          tag: 'daily_forecast_animation',
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Center(
              child: Text(
                "Thông tin thời tiết",
                style: AppStyle.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ngày dự báo
                  Text(
                    weatherData['date'],
                    style: AppStyle.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Hình ảnh thời tiết
                  SizedBox(
                    height: 128,
                    width: 128,
                    child: WeatherIconHandler.getImage(
                          iconCode: weatherData['iconCode'],
                        ) ??
                        Image.network(
                            "https://openweathermap.org/img/wn/${weatherData['iconCode']}@4x.png"),
                  ),
                  const SizedBox(height: 8),

                  // Mô tả thời tiết
                  Text(
                    weatherData['description'], // Sử dụng mô tả đã dịch
                    style: AppStyle.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Các chỉ số thời tiết
                  weatherAttributeBox(
                    context,
                    icon: Icons.thermostat,
                    attribute: "Cao nhất",
                    value: "${weatherData['tempMax']}°C",
                  ),
                  const SizedBox(height: 8),

                  weatherAttributeBox(
                    context,
                    icon: Icons.thermostat_outlined,
                    attribute: "Thấp nhất",
                    value: "${weatherData['tempMin']}°C",
                  ),
                  const SizedBox(height: 8),

                  weatherAttributeBox(
                    context,
                    icon: Icons.water_drop,
                    attribute: "Độ ẩm",
                    value: "${weatherData['humidity']} %",
                  ),
                  const SizedBox(height: 8),

                  weatherAttributeBox(
                    context,
                    icon: Icons.cloud,
                    attribute: "Tỉ lệ mây",
                    value: "${weatherData['cloud %']} %",
                  ),
                ],
              ),
            ),

            // Nút đóng
            actions: [
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Đóng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quarterlyForecast = ref.watch(quarterlyWeatherDataProvider);
    return Scaffold(
      body: quarterlyForecast.when(data: (data) {
        return Column(
          children: [
            const Gap(8),
            Center(
              child: Text(
                'Dự báo thời tiết theo ngày',
                style: AppStyle.textTheme.titleLarge,
              ),
            ),
            const Gap(8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final filterIndex = index * 8;
                    DateTime date =
                        DateTime.parse(data.list[filterIndex].dtTxt);
                    String formattedDate =
                        DateFormat.MMMMd('vi_VN').format(date);

                    return GestureDetector(
                      onTap: () async {
                        String translatedDescription = await translateText(
                            data.list[filterIndex].weather[0].description);

                        _showWeatherDetails(context, {
                          'cloud %': data.list[filterIndex].clouds.all,
                          'iconCode': data.list[filterIndex].weather[0].icon,
                          'date': formattedDate,
                          'tempMax': data.list[filterIndex].main.tempMax
                              .toStringAsFixed(0),
                          'tempMin': (data.list[filterIndex].main.tempMin - 5)
                              .toStringAsFixed(0),
                          'description': translatedDescription,
                          'humidity': data.list[filterIndex].main.humidity,
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: MatContainer.primary(
                            context: context,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 16, 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedDate,
                                          // data.list[filterIndex].dtTxt.substring(0, 10),
                                          style: AppStyle.textTheme.titleSmall,
                                        ),
                                        Text(data.list[filterIndex].weather[0]
                                            .description),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 128,
                                        width: 100,
                                        child: WeatherIconHandler.getImage(
                                              iconCode: data.list[filterIndex]
                                                  .weather[0].icon,
                                            ) ??
                                            Image.network(
                                                "https://openweathermap.org/img/wn/${data.list[filterIndex].weather[0].icon}@2x.png"),
                                      ),
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              "${(data.list[filterIndex].main.tempMin - 5).toStringAsFixed(0)}°C"),
                                          Text(
                                              "${data.list[filterIndex].main.tempMax.toStringAsFixed(0)}°C"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }, error: (error, stackTrace) {
        return Center(
          child: Text(
            'Error : $error',
            textAlign: TextAlign.center,
          ),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
