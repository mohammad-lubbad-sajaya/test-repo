
import '../../utils/constants/endpoints.dart';

enum Env { production, stage }

class Environment {
  final Env environment;
  late String baseURL;
  late String testUsername;
  late String testUserPass;
  late Map<String, dynamic> headers;

  Environment(this.environment) {
    switch (environment) {
      case Env.production:
        baseURL = Endpoints.baseUrl;
        testUsername = 'qq';
        testUserPass = '123@@@aaaAAA';
        headers = {
          // 'Connection': 'keep-alive',
          // 'Accept-Encoding': 'gzip, deflate, br',
          // 'Accept': '*/*',
          // 'Content-Type': 'application/x-www-form-urlencoded',
        };
        break;
      case Env.stage:
        baseURL = Endpoints.baseUrl;
        testUsername = 'qq';
        testUserPass = '123@@@aaaAAA';
        headers = {
          // 'Connection': 'keep-alive',
          // 'Accept-Encoding': 'gzip, deflate, br',
          // 'Accept': '*/*',
          // 'Content-Type': 'application/x-www-form-urlencoded',
        };
        break;
    }
  }
}
