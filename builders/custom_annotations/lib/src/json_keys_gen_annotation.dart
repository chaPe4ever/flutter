class JSONKeysGen {
  const new({required this.jsonPath});
  final String jsonPath;
}

const jsonTransKeysGen = JSONKeysGen(jsonPath: 'assets/translations/en.json');
