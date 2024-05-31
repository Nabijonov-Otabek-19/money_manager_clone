class ExpenseFields {
  static const tableName = "my_note";

  static const id = "id";
  static const title = "title";
  static const number = "number";
  static const type = "type";
  static const note = "note";
  static const createdTime = "time";
  static const photo = "photo";

  static final List<String> values = [
    /// Add all fields
    id, title, number, type, note, createdTime, photo,
  ];
}
