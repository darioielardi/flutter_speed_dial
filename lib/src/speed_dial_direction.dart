enum SpeedDialDirection { Up, Down, Left, Right }

extension EnumExtension on SpeedDialDirection {
  get value => this.toString().split(".")[1];
}
