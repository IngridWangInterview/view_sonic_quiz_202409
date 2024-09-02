class Environment {
  static String websocketIp =
      const String.fromEnvironment('WEBSOCKET_IP', defaultValue: '127.0.0.1');

  static const int websocketPort = int.fromEnvironment(
    'WEBSOCKET_PORT',
    defaultValue: 8080,
  );
}
