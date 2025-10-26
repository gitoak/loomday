import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logging/logger.dart';
import 'env.dart';

/// AppEnvironment-Provider
final envProvider = Provider<AppEnvironment>((_) => AppEnvironment.development);

/// Logger-Provider
final loggerProvider = Provider<AppLogger>((_) => AppLogger());
