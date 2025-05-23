import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/app.dart';
import 'package:iotec/app/routing/routing_service.dart';

void main() {
  GoRouter router = RoutingService().router;

  runApp(App(router: router));
}
