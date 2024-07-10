import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/crm/data/data source/remote_data_source_interface.dart';
import '../../../features/crm/data/data%20source/remote_data_source_implementation.dart';
import '../../../features/crm/data/repositories/repo_implementation.dart';
import '../../../features/crm/domain/repository%20interfaces/repo_interface.dart';
import '../../../features/crm/domain/usecases/crm_usecases.dart';
import '../../utils/common_widgets/error_dialog.dart';
import '../../utils/constants/endpoints.dart';
import '../extentions.dart';
import '../local_repo/local_lists_repository.dart';
import '../local_repo/local_repository.dart';
import '../local_repo/local_user_repository.dart';
import '../routing/navigation_service.dart';
import 'environment.dart';

/*
   This code represents the initialization and dependency injection setup for a Flutter application using the GetIt package.
   It registers and configures various singletons and dependencies for the application. 
 */

// sl and Env: sl is an instance of the GetIt service locator.
// Env is an enumeration that represents the running environment of the application.
final sl = GetIt.instance;
const Env runningEnvironment = Env.stage;

// This method is responsible for initializing the application's
// dependencies and configuring the service locator.
Future<void> init() async {
  //await Connectivity().checkConnectivity();

  sl.registerLazySingleton<LocalRepo>(
    () => LocalRepo(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<LocalListsRepo>(
    () => LocalListsRepo(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<LocalUserRepo>(
    () => LocalUserRepo(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<Environment>(() => Environment(runningEnvironment));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //  Creates a Dio client instance with the desired configuration and registers it as a lazy singleton.
  // interceptor for the Dio client that handles responses.
  // If the response indicates an unauthenticated status (status code 401),
  // it sets permit to false. However,
  // the code related to showing an error dialog and navigating to an unauthenticated route is currently commented out.
  Dio client = Dio(
    BaseOptions(
      baseUrl: sl<Environment>().baseURL,
      headers: sl<Environment>().headers,
      contentType: 'application/json',
      connectTimeout:  25000,
      receiveTimeout:  20000,
    ),
  );
  client.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        bool permit = true;

        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            Map<String, dynamic> res = response.data;
            if (res.containsKey('data')) {
              res = res['data'];
            }

            if (res['status'].toString() == '401') {
              permit = false;
              if (sl<NavigationService>().getParentName() !=
                  'unauthenticated') {
                showErrorDialog(
                  title: 'Error!'.localized(),
                  message: 'unauthenticated'.localized(),
                  onOkTap: () => {},
                  //routeSettings: const RouteSettings(name: 'unauthenticated'),
                );
              }
            }
          } else if (response.data is List<dynamic>) {
            //List<dynamic> res = response.data;
          }
        }

        if (permit) {
          handler.next(response);
        }
      },
      onError: (e, handler) {
        if (e.response?.data == "Expired Token") {
          var user = sl<LocalUserRepo>().getLoggedUser();
          var userToken = sl<LocalUserRepo>().getUserToken();
          Map<String, dynamic> data = {};
          data["grant_type"] = "refresh_token";

          data["username"] = user?.userName;
          data["client_id"] = user?.clientID;
          data["client_secret"] = user?.clientSecret;
          data["access_token"] = "${userToken?.accessToken}";
          data["refresh_token"] = userToken?.refreshToken;
          data["scope"] = "offline_access";

          sl<Dio>().options.headers.remove("Authorization");
          RefreshUserTokenUseCase(sl()).call(data).then(
                (value) => {
                  if (value != null)
                    {
                      sl<LocalUserRepo>().setUserToken(value),
                      sl<Dio>().options.headers.addAll(
                        {
                          'Authorization': '${value.accessToken}',
                          "contentType": 'application/json',
                        },
                      ),
                      e.requestOptions.headers["Authorization"] =
                          value.accessToken,
                      client
                          .request(
                            e.requestOptions.path,
                            data: e.requestOptions.data,
                            queryParameters: e.requestOptions.queryParameters,
                            options: Options(
                              method: e.requestOptions.method,
                              headers: e.requestOptions.headers,
                              sendTimeout: e.requestOptions.sendTimeout,
                              receiveTimeout: e.requestOptions.receiveTimeout,
                              extra: e.requestOptions.extra,
                              responseType: e.requestOptions.responseType,
                              receiveDataWhenStatusError:
                                  e.requestOptions.receiveDataWhenStatusError,
                              requestEncoder: e.requestOptions.requestEncoder,
                              responseDecoder: e.requestOptions.responseDecoder,
                              maxRedirects: e.requestOptions.maxRedirects,
                              validateStatus: e.requestOptions.validateStatus,
                              contentType: e.requestOptions.contentType,
                              listFormat: e.requestOptions.listFormat,
                              followRedirects: e.requestOptions.followRedirects,
                            ),
                          )
                          .then((value) => {
                                handler.next(e),
                              }),
                    }
                },
              );
        } else {
          handler.next(e);
          return;
        }
      },
    ),
  );


  sl.registerLazySingleton<Dio>(() => client);
  sl.registerLazySingleton<Endpoints>(() => Endpoints());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton<RepoInterface>(() => RepoImplementation(remoteDataSource: sl()));
  sl.registerLazySingleton<RemoteDataSourceInterFace >(() => RemoteDataSourceImplementation(client:sl()));

}


