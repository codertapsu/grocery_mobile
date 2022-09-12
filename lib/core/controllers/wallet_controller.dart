import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';
import 'package:web3dart/web3dart.dart';

import '../config/chain_config.dart';
import '../config/config.dart';
import '../utils/ethereum_transaction_tester.dart';
import '../utils/load_json.dart';

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  connectionCancelled,
}

class WalletController extends GetxController with WidgetsBindingObserver {
  final _logger = AppConfig.instance.logger;
  // final _ethereum = Web3Client(ChainConfig.rpcUrl, Client(),  socketConnector: () => IOWebSocketChannel.connect(wss).cast<String>());
  final _ethereum = Web3Client(ChainConfig.rpcUrl, Client());
  final RxString address$ = ''.obs;

  late WalletConnect _walletConnector;
  late WalletConnectQrCodeModal _walletConnectModal;
  late EthereumWalletConnectProvider _provider;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _walletConnector != null &&
        _walletConnector.connected &&
        !_walletConnector.bridgeConnected) {
      _walletConnector.reconnect();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void connect(BuildContext context) async {
    try {
      _walletConnector = _createWalletConnector();
      _walletConnectModal =
          WalletConnectQrCodeModal(connector: _walletConnector);

      /// Registers event subscriptions.
      /// https://docs.walletconnect.com/client-api#register-event-subscription
      /// Supported events: connect, disconnect, session_request, session_update
      _walletConnector.on('connect', (SessionStatus session) {
        address$.value = session.accounts.first;
      });
      _walletConnector.on('disconnect', (error) {
        print('Disconnected');
        print(error);
        address$.value = '';
      });
      _walletConnector.on('session_request', (event) {
        print('session_request');
        print(event);
      });
      _walletConnector.on('session_update', (WCSessionUpdateResponse session) {
        if (session.approved) {
          address$.value = session.accounts.first;
        }
      });
      _provider = EthereumWalletConnectProvider(_walletConnectModal.connector);

      await _walletConnectModal.connect(
        context,
        chainId: ChainConfig.chainId,
      );
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<void> disconnect() async {
    await _walletConnectModal.killSession();
  }

  /// @see https://github.com/xclud/web3dart/blob/development/example/contracts.dart
  Future<void> buyWithGroceryCoin(double amount) async {
    try {
      // read the contract abi and tell web3dart where it's deployed (contractAddr)
      final contractJson = loadJson('assets/abi/coin.json');
      final abiCode = jsonEncode(contractJson['abi']);
      final contractName = contractJson['contractName'] as String;
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, contractName),
        EthereumAddress.fromHex(GroceryCoin.address),
      );

      // extracting some functions and events that we'll need later
      final transferEvent = contract.event('Transfer');
      final balanceFunction = contract.function('balanceOf');
      final sendFunction = contract.function('transfer');

      // listen for the Transfer event when it's emitted by the contract above
      final subscription = _ethereum
          .events(
              FilterOptions.events(contract: contract, event: transferEvent))
          .take(1)
          .listen((event) {
        final decoded = transferEvent.decodeResults(event.topics!, event.data!);

        final from = decoded[0] as EthereumAddress;
        final to = decoded[1] as EthereumAddress;
        final value = decoded[2] as BigInt;

        _logger.i('$from sent $value $contractName to $to');
      });

      // check our balance in MetaCoins by calling the appropriate function
      final ownAddress = EthereumAddress.fromHex(address$.value);
      final balances = await _ethereum.call(
          contract: contract, function: balanceFunction, params: [ownAddress]);
      BigInt balance = balances.first;
      var value = EtherAmount.inWei(balance).getValueInUnit(EtherUnit.ether);
      print(value);
      _logger.i('We have $balance $contractName');

      final recipient =
          EthereumAddress.fromHex(ChainConfig.shopOwnerWalletAddress);
      final sender = EthereumAddress.fromHex(address$.value);
      final etherAmount = EtherAmount.fromUnitAndValue(
        EtherUnit.szabo,
        (amount * 1000 * 1000).toInt(),
      ).getInWei;
      final credentials = WalletConnectEthereumCredentials(provider: _provider);

      await _ethereum.sendTransaction(
        credentials,
        Transaction.callContract(
          from: sender,
          contract: contract,
          function: sendFunction,
          gasPrice: EtherAmount.inWei(BigInt.one),
          maxGas: 100000,
          parameters: [recipient, etherAmount],
        ),
      );

      await subscription.asFuture();
      await subscription.cancel();
      await _ethereum.dispose();
    } on WalletConnectException catch (e) {
      Get.snackbar(
        'Failed',
        e.message,
        icon: const Icon(
          Ionicons.ios_warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e(e);
    }
  }

  Future<String?> buyWithEth(double amount) async {
    final recipient =
        EthereumAddress.fromHex(ChainConfig.shopOwnerWalletAddress);

    final sender = EthereumAddress.fromHex(address$.value);

    /// szabo, 10^12 wei or 1 μEther => 1ether = szabo * 10^6 ETH is divisible up to 18 decimal places
    /// This should not set equal to EtherUnit.ether
    /// Because amount may be decimal
    final etherAmount = EtherAmount.fromUnitAndValue(
      EtherUnit.szabo,
      (amount * 1000 * 1000).toInt(),
    );
    // final etherAmount = EtherAmount.fromUnitAndValue(EtherUnit.ether, amount);

    final transaction = Transaction(
      to: recipient,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: etherAmount,
    );

    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    // final credentials = await _ethereum.credentialsFromPrivateKey(privateKey);
    // final address = await credentials.extractAddress();
    // _logger.i(address.hexEip55);
    // _logger.i(await _ethereum.getBalance(address));

    try {
      final txBytes = await _ethereum.sendTransaction(credentials, transaction);
      _ethereum.dispose();
      return txBytes;
    } on WalletConnectException catch (e) {
      Get.snackbar(
        'Failed',
        e.message,
        icon: const Icon(
          Ionicons.ios_warning,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {}

    // Kill the session
    // _connector.killSession();

    return null;
  }

  Future<double> getEthBalance() async {
    final address = EthereumAddress.fromHex(address$.value);
    final amount = await _ethereum.getBalance(address);
    final balance = amount.getValueInUnit(EtherUnit.ether).toDouble();
    _logger.i(balance);

    return balance;
  }

  bool validateAddress({required String address}) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (_) {
      return false;
    }
  }

  WalletConnect _createWalletConnector() {
    return WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        // <-- Meta data of your app appearing in the wallet when connecting
        name: AppConfig.appName,
        description: 'WalletConnect ${AppConfig.appName} App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );
  }
}
