import 'package:dart_project/featchingapi.dart';

void main() async {
  FeatchingApi api = FeatchingApi();
  try {
    await api.featchningApi();
  } catch (e) {
    print("Main caught error: $e");
  }
}