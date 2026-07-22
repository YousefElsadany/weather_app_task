import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/weather_bloc.dart';
import 'bloc/weather_event.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/weather_api_service.dart';
import 'services/weather_cache_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (_) => WeatherBloc(
        apiService: WeatherApiService(),
        cacheService: WeatherCacheService(),
      )..add(const WeatherCacheLoadRequested()),
      child: MaterialApp(
        title: "Weather App",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
