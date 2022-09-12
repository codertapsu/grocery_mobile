import 'dart:convert';

import 'package:web3dart/web3dart.dart';

const Map<String, StateMutability> _mutabilityNames = {
  'pure': StateMutability.pure,
  'view': StateMutability.view,
  'nonpayable': StateMutability.nonPayable,
  'payable': StateMutability.payable,
};

const Map<String, ContractFunctionType> _functionTypeNames = {
  'function': ContractFunctionType.function,
  'constructor': ContractFunctionType.constructor,
  'fallback': ContractFunctionType.fallback,
};

final RegExp array = RegExp(r'^(.*)\[(\d*)\]$');

_parseTuple(
  String name,
  String typeName,
  List<FunctionParameter> components,
) {
  // The type will have the form tuple[3][]...[1], where the indices after the
  // tuple indicate that the type is part of an array.
  assert(
    RegExp(r'^tuple(?:\[\d*\])*$').hasMatch(typeName),
    '$typeName is an invalid tuple type',
  );

  final arrayLengths = <int?>[];
  var remainingName = typeName;

  while (remainingName != 'tuple') {
    final arrayMatch = array.firstMatch(remainingName)!;
    remainingName = arrayMatch.group(1)!;

    final insideSquareBrackets = arrayMatch.group(2)!;
    if (insideSquareBrackets.isEmpty) {
      arrayLengths.insert(0, null);
    } else {
      arrayLengths.insert(0, int.parse(insideSquareBrackets));
    }
  }

  return CompositeFunctionParameter(name, components, arrayLengths);
}

_parseParams(List? data) {
  if (data == null || data.isEmpty) return [];

  final elements = <FunctionParameter>[];
  for (final entry in data) {
    elements.add(_parseParam(entry as Map));
  }

  return elements;
}

_parseParam(Map entry) {
  final name = entry['name'] as String;
  final typeName = entry['type'] as String;

  if (typeName.contains('tuple')) {
    final components = entry['components'] as List;
    return _parseTuple(name, typeName, _parseParams(components));
  } else {
    final type = parseAbiType(entry['type'] as String);
    return FunctionParameter(name, type);
  }
}

parseContractFromJson(String jsonData, String name) {
  dynamic data = json.decode(jsonData);
  data.forEach((element) {
    print('object');
  });
  final functions = <ContractFunction>[];
  final events = <ContractEvent>[];
  for (final element in data) {
    final type = element['type'] as String;
    final name = (element['name'] as String?) ?? '';
    print('data1');

    if (type == 'event') {
      final anonymous = element['anonymous'] as bool;
      final components = <EventComponent>[];

      for (final entry in element['inputs']) {
        print('data');
        components.add(
          EventComponent(
            _parseParam(entry as Map),
            entry['indexed'] as bool,
          ),
        );
      }

      events.add(ContractEvent(anonymous, name, components));
      continue;
    }

    final mutability = _mutabilityNames[element['stateMutability']];
    final parsedType = _functionTypeNames[element['type']];
    if (parsedType == null) continue;

    final inputs = _parseParams(element['inputs'] as List?);
    final outputs = _parseParams(element['outputs'] as List?);

    functions.add(
      ContractFunction(
        name,
        inputs,
        outputs: outputs,
        type: parsedType,
        mutability: mutability ?? StateMutability.nonPayable,
      ),
    );
  }

  return ContractAbi(name, functions, events);
}
