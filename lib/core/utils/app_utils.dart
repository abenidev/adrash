import 'package:uuid/uuid.dart';

String getUuid() {
  Uuid uuid = const Uuid();
  return uuid.v4();
}
