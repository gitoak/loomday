// ignore_for_file: public_member_api_docs

enum AppFlavor { dev, stage, prod, demo, e2e }

extension AppFlavorX on AppFlavor {
  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'dev';
      case AppFlavor.stage:
        return 'stage';
      case AppFlavor.prod:
        return 'prod';
      case AppFlavor.demo:
        return 'demo';
      case AppFlavor.e2e:
        return 'e2e';
    }
  }

  bool get isProduction => this == AppFlavor.prod;

  static AppFlavor parse(final String value) {
    final normalized = value.toLowerCase().trim();
    switch (normalized) {
      case 'development':
      case 'dev':
        return AppFlavor.dev;
      case 'staging':
      case 'stage':
        return AppFlavor.stage;
      case 'production':
      case 'prod':
        return AppFlavor.prod;
      case 'demo':
        return AppFlavor.demo;
      case 'e2e':
        return AppFlavor.e2e;
      default:
        return AppFlavor.dev;
    }
  }
}
