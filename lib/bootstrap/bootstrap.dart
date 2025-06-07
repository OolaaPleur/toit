import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../app/app.dart';

/// Bootstrap function to initialize the application.
Future<void> bootstrap() async {
  // Set up logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Set up global error handling
  FlutterError.onError = (details) {
    Logger(
      'Flutter',
    ).severe('Flutter error: ${details.exception}', details.stack);
  };

  // Set up BlocObserver
  Bloc.observer = _AppBlocObserver();

  runApp(const MyApp());
}

/// Custom [BlocObserver] for the application.
class _AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    Logger('Bloc').info('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Logger('Bloc').severe('${bloc.runtimeType} error: $error', stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
