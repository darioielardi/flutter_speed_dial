enum SpeedDialOrientation { Up, Down, Left, Right }

extension EnumExtension on SpeedDialOrientation {
  get value => this.toString().split(".")[1];
}
