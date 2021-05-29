enum SpeedDialDirection { Up, Down, Left, Right }

extension EnumExtension on SpeedDialDirection {
  /// Get Value of The SpeedDialDirection Enum like Up, Down, etc. in String format
  String get value => this.toString().split(".")[1];
}
