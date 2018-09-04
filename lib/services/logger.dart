/// Wrapper for logging enabling use of services such as Firebase in the future.
class Logger<T> {

  //
  final String name = T.runtimeType.toString();

  void _log(String eventType, String message) {
    print("$name:$eventType: $message");
  }

  void event(String message) {
    _log('Event', message);
  }

  void debug(String message) {
    _log('Debug', message);
  }

  void error(String message) {
    _log('Error', message);
  }
}