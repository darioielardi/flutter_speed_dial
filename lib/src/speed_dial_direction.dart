enum SpeedDialDirection { up, down, left, right }

extension EnumExtension on SpeedDialDirection {
  bool get isDown => this == SpeedDialDirection.down;
  bool get isUp => this == SpeedDialDirection.up;
  bool get isLeft => this == SpeedDialDirection.left;
  bool get isRight => this == SpeedDialDirection.right;
}
