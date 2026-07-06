import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/weather_condition_icon.dart';
import 'package:weather_app/weather_additional_information.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/weather_live_clock.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with WidgetsBindingObserver {
  late Future<List<Map<String, dynamic>>> weatherData;
  late Timer _weatherRefreshTimer;
  int _timezoneOffset = 0;

  double? _latitude;
  double? _longitude;
  bool _locationLoaded = false;

  void _refreshWeather() {
    if (_locationLoaded && _latitude != null && _longitude != null) {
      setState(() {
        weatherData = Future.wait([
          getCurrentForecast(_latitude!, _longitude!),
          getWeatherForecast(_latitude!, _longitude!),
        ]);
      });
    } else {
      _getLocationAndFetchWeather();
    }
  }

  void _useFallbackLocation() {
    const double fallbackLat = 28.2096;
    const double fallbackLon = 83.9856;
    setState(() {
      _latitude = fallbackLat;
      _longitude = fallbackLon;
      _locationLoaded = true;
      weatherData = Future.wait([
        getCurrentForecast(_latitude!, _longitude!),
        getWeatherForecast(_latitude!, _longitude!),
      ]);
    });
  }

  Future<void> _getLocationAndFetchWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useFallbackLocation();
        return;
      }

      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _locationLoaded = true;
          weatherData = Future.wait([
            getCurrentForecast(_latitude!, _longitude!),
            getWeatherForecast(_latitude!, _longitude!),
          ]);
        });
      } else {
        _useFallbackLocation();
      }
    } catch (e) {
      _useFallbackLocation();
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchWeather();
    WidgetsBinding.instance.addObserver(this);

    _weatherRefreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      if (mounted) _refreshWeather();
    });
  }

  @override
  void dispose() {
    _weatherRefreshTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshWeather();
    }
  }

  Future<Map<String, dynamic>> getCurrentForecast(
    double lat,
    double lon,
  ) async {
    try {
      final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
      final Uri url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': apiKey,
        'units': 'metric',
      });
      final http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception('Failed to load current weather');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast(
    double lat,
    double lon,
  ) async {
    try {
      final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
      final Uri url = Uri.https(
        'api.openweathermap.org',
        '/data/2.5/forecast',
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'appid': apiKey,
          'units': 'metric',
        },
      );
      final http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data;
      } else {
        throw Exception('Failed to load weather forecast.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: _refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: !_locationLoaded
          ? const Center(child: CircularProgressIndicator.adaptive())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: weatherData,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (asyncSnapshot.hasError) {
                  return Center(child: Text(asyncSnapshot.error.toString()));
                }

                final List<Map<String, dynamic>> data = asyncSnapshot.data!;
                final Map<String, dynamic> currentData = data[0];
                final Map<String, dynamic> forecastData = data[1];

                _timezoneOffset =
                    forecastData['city']['timezone'] as int? ??
                    currentData['timezone'] as int? ??
                    0;

                final cityName = currentData['name'];
                final currentWeather = currentData['weather'][0];
                final int currentConditionId = currentWeather['id'];
                final String description = currentWeather['description'];
                final IconData currentIcon =
                    WeatherConditionIcon.getWeatherIcon(currentConditionId);
                final Color currentColor = WeatherConditionIcon.getWeatherColor(
                  currentConditionId,
                );

                final double temperature = (currentData['main']['temp'] as num)
                    .toDouble();
                final String humidity = currentData['main']['humidity']
                    .toString();
                final String windSpeed = (currentData['wind']['speed'] as num)
                    .toStringAsFixed(2);
                final String pressure = currentData['main']['pressure']
                    .toString();

                final forecastList = forecastData['list'] as List;

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        currentColor.withValues(alpha: 1.0),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    currentColor.withValues(alpha: 0.15),
                                    currentColor.withValues(alpha: 0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.white.withValues(alpha: 0.7),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          cityName,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${temperature.toStringAsFixed(2)}°C',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Icon(
                                          currentIcon,
                                          size: 70,
                                          color: currentColor,
                                        ),
                                        const SizedBox(height: 5),
                                        LiveClock(
                                          timezoneOffset: _timezoneOffset,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          description,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Weather Forecast',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 115,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final hourlyForecast = forecastList[index];

                              final DateTime time =
                                  DateTime.fromMillisecondsSinceEpoch(
                                    hourlyForecast['dt'] * 1000,
                                    isUtc: true,
                                  ).add(Duration(seconds: _timezoneOffset));

                              final weatherEntry = hourlyForecast['weather'][0];
                              final int id = weatherEntry['id'];
                              final IconData icon =
                                  WeatherConditionIcon.getWeatherIcon(id);
                              final temperature =
                                  (hourlyForecast['main']['temp'] as num)
                                      .toStringAsFixed(2);

                              return HourlyForecastItem(
                                time: time,
                                icon: icon,
                                temperature: '$temperature°C',
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInformation(
                              icon: Icons.water_drop,
                              label: 'Humidity',
                              value: '$humidity%',
                            ),
                            AdditionalInformation(
                              icon: Icons.air,
                              label: 'Wind Speed',
                              value: '$windSpeed m/s',
                            ),
                            AdditionalInformation(
                              icon: LucideIcons.gauge,
                              label: 'Pressure',
                              value: '$pressure hPa',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
