class PlayerRepository {
  static int id = 0;

  static int getId() {
    id += 1;
    return id;
  }
}
