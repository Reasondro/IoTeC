import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/app.dart';
import 'package:iotec/app/routing/routing_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter router = RoutingService().router;

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_PROJECT_URL"]!,
    anonKey: dotenv.env["SUPABASE_API_KEY"]!,
  );

  runApp(App(router: router));
}
