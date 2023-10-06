/// Environment variables and shared app constants.
abstract class Constants {
  static const String graphUrl = String.fromEnvironment(
    'GRAPH_URL',
    defaultValue: 'http://localhost:4000/',
  );
}