import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../core/components/common.dart';
import '../../../utils/style.dart';
import '../../../utils/weather_translator.dart';
import '../../forecast/data/providers.dart';
import '../../home/data/weather_icon_handler.dart';
import '../components/weather_attribute.dart';
import '../data/providers.dart';

class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  void _showMoreDetails(BuildContext context, dynamic weatherData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Thông tin chi tiết",
            style: AppStyle.textTheme.titleSmall,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.water_drop_rounded,
                    attribute: "Độ ẩm",
                    value: weatherData['Humidity'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.brightness_high_sharp,
                    attribute: "Chỉ số UV",
                    value: weatherData['UVIndex'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.sunny,
                    attribute: "Bình minh",
                    value: weatherData['Sunrise'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.cloud,
                    attribute: "Tỉ lệ mây",
                    value: weatherData['Cloud %'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.tire_repair_rounded,
                    attribute: "Áp suất không khí",
                    value: weatherData['Pressure'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.air_rounded,
                    attribute: "Tốc độ gió",
                    value: weatherData['WindSpeed'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.thermostat_rounded,
                    attribute: "Cảm giác như",
                    value: weatherData['FeelsLike'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.wb_twilight_rounded,
                    attribute: "Hoàng hôn",
                    value: weatherData['Sunset'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.visibility_rounded,
                    attribute: "Tầm nhìn",
                    value: weatherData['Visiblity'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
                  child: weatherAttributeBox(
                    context,
                    icon: Icons.umbrella_rounded,
                    attribute: "Mưa",
                    value: weatherData['Rain'],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherDataAsync = ref.watch(currentWeatherDataProvider);
    final quarterlyWeatherDataAsync = ref.watch(quarterlyWeatherDataProvider);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            currentWeatherDataAsync.when(
              data: (data) {
                if (data.cityName == "Globe") {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                }
                return Column(
                  children: [
                    const Gap(8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_sharp,
                          color: Colors.red,
                        ),
                        Text(
                          "Vị trí hiện tại",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.cityName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hôm nay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                    const Gap(18),
                    Column(
                      children: [
                        MatContainer.primary(
                          context: context,
                          topPad: 24,
                          bottomPad: 32,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WeatherIconHandler.getImage(
                                        iconCode: data.weather[0].icon,
                                        height: 200,
                                        width: 200,
                                      ) ??
                                      Image.network(
                                        "https://openweathermap.org/img/wn/${data.weather[0].icon}@4x.png",
                                      ),
                                  const Gap(16),
                                ],
                              ),
                              Text(
                                "${data.main.temp.toStringAsFixed(0)} °C",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              Text(
                                translateWeatherCondition(data.weather[0].main),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MatContainer1.primary(
                          context: context,
                          height: 205,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: weatherAttribute(
                                          context,
                                          icon: Icons.water_drop_rounded,
                                          attribute: "Độ ẩm",
                                          value: "${data.main.humidity} %",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 12.0, 12.0, 4.0),
                                        child: weatherAttribute(
                                          context,
                                          icon: Icons.brightness_high_sharp,
                                          attribute: "Chỉ số UV",
                                          value: "3",
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: weatherAttribute(
                                          context,
                                          icon: Icons.air_rounded,
                                          attribute: "Tốc độ gió",
                                          value:
                                              "${data.wind.speed.toString()} m/s",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 12.0, 12.0, 4.0),
                                        child: weatherAttribute(
                                          context,
                                          icon: Icons.thermostat_rounded,
                                          attribute: "Cảm giác như",
                                          value:
                                              "${data.main.feelsLike.round().toString()}°C",
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  iconSize: 35.0,
                                  onPressed: () {
                                    int unixTimestampsunrise = data.sys.sunrise;
                                    int unixTimestampsunset = data.sys.sunset;

                                    DateTime sunRise =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            unixTimestampsunrise * 1000);
                                    DateTime sunSet =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            unixTimestampsunset * 1000);

                                    String sunRiseMain =
                                        DateFormat('h:mm a').format(sunRise);
                                    String sunSetMain =
                                        DateFormat('h:mm a').format(sunSet);

                                    _showMoreDetails(context, {
                                      'iconCode': data.weather[0].icon,
                                      'temp':
                                          "${data.main.temp.toStringAsFixed(0)} °C",
                                      'description': translateWeatherCondition(
                                          data.weather[0].main),
                                      'Humidity': "${data.main.humidity} %",
                                      'WindSpeed':
                                          "${data.wind.speed.toString()} m/s",
                                      'UVIndex': "3",
                                      'FeelsLike':
                                          "${data.main.feelsLike.round().toString()}°C",
                                      'Sunrise': sunRiseMain,
                                      'Sunset': sunSetMain,
                                      'Cloud %':
                                          "${data.clouds.all.toString()}%",
                                      'Visiblity':
                                          "${data.visibility.toString()} m",
                                      'Rain': data.rain?.h ?? "No Rain",
                                      'Pressure': "${data.main.pressure} Pa"
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.arrow_drop_down_outlined))
                            ],
                          ),
                        ),
                        const Gap(8),
                      ],
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    'Error : $error',
                    textAlign: TextAlign.center,
                  ),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            MatContainer.primary(
              context: context,
              child: Column(
                children: [
                  const Text(
                    "Quarterly Forecast",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                  ),
                  const Gap(8),
                  SizedBox(
                      height: 200, // Adjust the height as needed
                      child: quarterlyWeatherDataAsync.when(data: (data) {
                        if (data.city.name == "Globe") {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              //Time Formatter
                              DateTime date =
                                  DateTime.parse(data.list[index].dtTxt);
                              String formattedDate =
                                  DateFormat.MMMMd('vi_VN').format(date);
                              String formattedTime =
                                  DateFormat.jm().format(date);
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                width: 150, // Adjust the width as needed
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(formattedDate),
                                    Text(formattedTime),
                                    WeatherIconHandler.getImage(
                                          iconCode:
                                              data.list[index].weather[0].icon,
                                          height: 80,
                                          width: 100,
                                        ) ??
                                        Image.network(
                                            "https://openweathermap.org/img/wn/${data.list[index].weather[0].icon}@2x.png"),
                                    Text(
                                        "${data.list[index].main.temp.toStringAsFixed(0)}°C")
                                  ],
                                ),
                              );
                            },
                          ),
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
                      })),
                ],
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
