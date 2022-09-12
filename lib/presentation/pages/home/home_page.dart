import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/authentication_controller.dart';
import '../../../core/controllers/wallet_controller.dart';
import '../../controllers/home_controller.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // final AuthController _authController = Get.put(AuthController());
//   final AuthController _authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             child: ElevatedButton(
//               onPressed: () {
//                 _authController.incrementCounter1();
//               },
//               child: Text('Update GetBuilder'),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _authController.signIn();
//             },
//             child: Text('Signin'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _authController.refreshToken();
//             },
//             child: Text('Refresh'),
//           ),
//           _information2(),
//           _information3(),
//           Expanded(
//             child: _information(),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _information() {
//     return Container(
//       child: Center(
//         child: Obx(
//           () => Text('Counter is ${_authController.counter1.value}'),
//         ),
//       ),
//     );
//   }

//   Widget _information2() {
//     /**
//      * initialize CounterController if you use it first time in your views
//      */
//     return GetBuilder<AuthController>(
//       init: AuthController(),
//       builder: (controller) => Text('Counter2: ${controller.counter1.value}'),
//     );
//   }

//   Widget _information3() {
//     /**
//      * No need to initialize CounterController again here
//      * since it is already initialized in the previous GetBuilder
//      */
//     return GetBuilder<AuthController>(
//       builder: (controller) => Text('Counter2: ${controller.counter1.value}'),
//     );
//   }
// }

class HomePage extends GetView<HomeController> {
  @override
  String get tag => (HomeController).toString();

  late AuthenticationController _authenticationController;
  final _walletController = Get.find<WalletController>();

  HomePage({Key? key}) : super(key: key) {
    _authenticationController = Get.find<AuthenticationController>(
      tag: (AuthenticationController).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () {
                _authenticationController.incrementCounter1();
              },
              child: Text('Update GetBuilder'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _authenticationController.signIn();
            },
            child: Text('Signin'),
          ),
          ElevatedButton(
            onPressed: () {
              _walletController.connect(context);
            },
            child: Text('Conenct wallet'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _walletController.disconnect();
            },
            child: Text(
              'disconnect',
            ),
          ),
          Obx(
            () => Text(
                'Your wallet address is ${_walletController.address$.value}'),
          ),
          ElevatedButton(
            onPressed: () {
              _walletController.buyWithEth(10.5);
            },
            child: Text('Test send ETH'),
          ),
          ElevatedButton(
            onPressed: () {
              _walletController.buyWithGroceryCoin(15.5);
            },
            child: Text('Test send Coin'),
          ),
          ElevatedButton(
            onPressed: () {
              _walletController.getEthBalance();
            },
            child: Text('Get ETH balance'),
          ),
          ElevatedButton(
            onPressed: () {
              _authenticationController.refreshToken();
            },
            child: Text('Refresh'),
          ),
          _information2(),
          _information3(),
          Container(
            child: Center(
              child: Obx(
                () => Text('Counter home is ${controller.counter.value}'),
              ),
            ),
          ),
          Expanded(
            child: _information(),
          )
        ],
      ),
    );
  }

  Widget _information() {
    return Container(
      child: Center(
        child: Obx(
          () => Text('Counter is ${_authenticationController.counter1.value}'),
        ),
      ),
    );
  }

  Widget _information2() {
    /**
     * initialize CounterController if you use it first time in your views
     */
    return GetBuilder<AuthenticationController>(
      init: AuthenticationController(),
      builder: (controller) => Text('Counter2: ${controller.counter1.value}'),
    );
  }

  Widget _information3() {
    /**
     * No need to initialize CounterController again here
     * since it is already initialized in the previous GetBuilder
     */
    return GetBuilder<AuthenticationController>(
      builder: (controller) => Text('Counter2: ${controller.counter1.value}'),
    );
  }
}
