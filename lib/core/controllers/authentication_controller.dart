import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../http/http_client.dart';

class AuthenticationController extends GetxController {
  RxInt counter1 = 0.obs; // For reactive approach or RxInt(0) or Rx<Int>(0)
  int counter2 = 0; // For simple state management approach
  late final HttpClient _httpClient;
  // AuthController(this._loginUseCase);
  // final SignUpUseCase _loginUseCase;
  // final store = Get.find<LocalStorageService>();
  // var isLoggedIn = false.obs;

  // User? get user => store.user;
  // Rxn<UserModel> authUser$ = Rxn<UserModel>();

  // @override
  // void onInit() async {
  //   super.onInit();
  //   _httpClient = HttpClient();
  // }
  @override
  void onInit() {
    _httpClient = HttpClient();
    // Here you can fetch you product from server
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Here, you can dispose your StreamControllers
    // you can cancel timers
    super.onClose();
  }

  void incrementCounter1() {
    counter1.value++;
  }

  void incrementCounter2() {
    counter2++;
    update();
  }

  Future signIn() async {
    try {
      final request = {
        'username': 'admin',
        'password': '123123',
      };
      final response = await _httpClient.post<dynamic>(
        '/auth/login',
        data: request,
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.requestOptions);
        print('object');
      } else {
        print(e.requestOptions.toString());
        print(e.message);
      }
    }
  }

  Future refreshToken() async {
    try {
      final response = await _httpClient.get<dynamic>('/auth/refresh');
      print('ok');
      print(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.requestOptions);
        print('object');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions.toString());
        print(e.message);
      }
    }
    // return response.data;
  }

  // signUpWith(String username) async {
  //   try {
  //     final user = await _loginUseCase.execute(username);
  //     store.user = user;
  //     isLoggedIn.value = true;
  //     isLoggedIn.refresh();
  //   } catch (error) {}
  // }

  // logout() {
  //   store.user = null;
  //   isLoggedIn.value = false;
  // }
}
