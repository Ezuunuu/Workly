import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workly/app.dart';
import 'package:workly/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // .env 파일 로드

  await setupLocator(); // DI 초기화

  runApp(App());
}
