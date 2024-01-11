enum DevMode { production, debug }

class Env {
  static const DevMode _devMode = DevMode.production;
  static const String _debugURL = "http://192.168.100.21:3008";
  //static const String _productionURL = "http://194.233.65.179:3002";
  static const String _productionURL = "https://msub-api.kyawthet.com";
  static bool get isDebug => _devMode == DevMode.debug;
  static final baseURL = isDebug ? _debugURL : _productionURL;
}
