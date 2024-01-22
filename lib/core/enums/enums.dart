enum ThemeMode {
  light,
  dark
}

enum Userkarma {
  comment(1),
  textPost(2),
  imagePost(3),
  linkPost(3),
  delete(-1);

  final int karma;
  const Userkarma(this.karma);
}