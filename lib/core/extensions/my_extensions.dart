extension AssetExtension on String {
  String get pngIcon => 'assets/images/$this.png';

  String get svgIcon => 'assets/images/$this.svg';

  String get jpgIcon => 'assets/images/$this.jpg';
}
