import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/components/common.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../forecast/view/forecast_view.dart';
import '../../map/provider/location_provider.dart';
import '../../map/view/map_view.dart';
import '../../settings/view/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _locationPermissionGranted = false;
  bool _locationServices = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    requestLocationPermission();
    checkLocationConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      for (var i in connectivityResult) {
        if (i == ConnectivityResult.mobile || i == ConnectivityResult.wifi) {
          setState(() {
            isConnected = true;
          });
        }
      }
    }
  }

  Future<void> checkLocationConnection() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      // Location services are not enabled, show error message
      setState(() {
        _locationServices = false;
      });
    } else {
      setState(() {
        _locationServices = true;
      });
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationPermissionGranted = false;
        });
        return;
      }
    }

    setState(() {
      _locationPermissionGranted = true;
      LocationNotifier().getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationPermissionGranted) {
      return Scaffold(
        appBar: appBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_disabled_sharp,
                color: Colors.red,
                size: 60.0,
              ),
              const Gap(10.0),
              const SizedBox(
                width: 500.0,
                child: Column(
                  children: [
                    Text(
                      'Yêu cầu quyền truy cập vị trí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Gap(7.5),
                    Text("Khởi động lại để kích hoạt")
                  ],
                ),
              ),
              const Gap(15.0),
              ElevatedButton(
                  onPressed: () => {
                        AppSettings.openAppSettings(
                            type: AppSettingsType.location)
                      },
                  child: const Text("Mở cài đặt vị trí")),
              const Gap(10.0),
              ElevatedButton(
                  onPressed: () => requestLocationPermission(),
                  child: const Text("Thử lại"))
            ],
          ),
        ),
      );
    }

    if (!_locationServices) {
      return Scaffold(
        appBar: appBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off_sharp,
                color: Colors.red,
                size: 60.0,
              ),
              const Gap(10.0),
              const SizedBox(
                width: 500.0,
                child: Column(
                  children: [
                    Text(
                      'Quyền truy cập vị trí đã tắt',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Gap(7.5),
                    Text("Hãy bật quyền truy cập vị trí")
                  ],
                ),
              ),
              const Gap(15.0),
              ElevatedButton(
                  onPressed: () => {
                        AppSettings.openAppSettings(
                            type: AppSettingsType.location)
                      },
                  child: const Text("Mở cài đặt vị trí")),
              const Gap(10.0),
              ElevatedButton(
                  onPressed: () => checkLocationConnection(),
                  child: const Text("Thử lại"))
            ],
          ),
        ),
      );
    }

    if (!isConnected) {
      return Scaffold(
        appBar: appBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_sharp,
                color: Colors.red,
                size: 60.0,
              ),
              const Gap(10.0),
              SizedBox(
                width: 500.0,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: const Text(
                        'Cần có kết nối mạng để truy cập',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Gap(7.5),
                    const Text("Hãy kiểm tra kết nối mạng của bạn")
                  ],
                ),
              ),
              const Gap(15.0),
              ElevatedButton(
                  onPressed: () => checkInternetConnection(),
                  child: const Text("Thử lại")),
              const Gap(10),
              ElevatedButton(
                  onPressed: () => AppSettings.openAppSettings(
                      type: AppSettingsType.wireless),
                  child: const Text("Mở cài đặt trên thiết bị"))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: navBar(),
      body: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return Consumer(
            builder: (context, ref, child) {
              return [
                const DashBoard(),
                const ForecastView(),
                const MapView(),
                const SettingsView(),
              ][ref.watch(bottomNavigationBarProvider)];
            },
          );
        },
      ),
    );
  }
}
