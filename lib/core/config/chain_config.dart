/// https://academy.binance.com/en/articles/connecting-metamask-to-binance-smart-chain
class BscMainnet {
  static const networkName = 'Smart Chain';
  static const rpcUrl = 'https://bsc-dataseed.binance.org';
  static const chainId = 56;
  static const chainIdHex = '0x38';
  static const symbol = 'BNB';
  static const blockExplorerUrl = 'https://bscscan.com';
}

class BscTestnet {
  static const networkName = 'Smart Chain - Testnet';
  static const rpcUrl = 'https://data-seed-prebsc-1-s1.binance.org:8545';
  static const chainId = 97;
  static const chainIdHex = '0x61';
  static const symbol = 'BNB';
  static const blockExplorerUrl = 'https://testnet.bscscan.com';
}

class GroceryTestnet {
  static const networkName = 'Grocery Chain';
  static const rpcUrl = 'https://coin.codertapsu.dev';
  static const chainId = 1337;
  static const chainIdHex = '0x539';
  static const symbol = 'ETH';
  static const blockExplorerUrl = '';
}

class GroceryCoin {
  static const address = '0x9247607cAFC4aD858ADF2C3914Cc9Cc8C9C60608';
}

class ChainConfig {
  static const isProduction = false;
  static const chainIdHex =
      isProduction ? BscMainnet.chainIdHex : GroceryTestnet.chainIdHex;

  static const rpcUrl =
      isProduction ? BscMainnet.rpcUrl : GroceryTestnet.rpcUrl;

  static const chainId =
      isProduction ? BscMainnet.chainId : GroceryTestnet.chainId;

  static const networkName =
      isProduction ? BscMainnet.networkName : GroceryTestnet.networkName;

  static const blockExplorerUrl = isProduction
      ? BscMainnet.blockExplorerUrl
      : GroceryTestnet.blockExplorerUrl;

  static const symbol =
      isProduction ? BscMainnet.symbol : GroceryTestnet.symbol;
  static const decimals = 18;

  /// Shop owner wallet address
  static const shopOwnerWalletAddress =
      '0xd6e707a6a75593C274a9441D4248161697578A76';
}
