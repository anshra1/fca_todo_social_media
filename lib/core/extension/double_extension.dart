import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

extension DoubleExt on double {
  Widget get gap => Gap(this);
}
