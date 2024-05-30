class ExpenseFields {
  static const tableName = "my_note";

  static const id = "id";
  static const title = "title";
  static const description = "description";
  static const number = "number";
  static const type = "type";
  static const createdTime = "time";
  static const photo = "photo";

  static final List<String> values = [
    /// Add all fields
    id, title, description, number, type, createdTime, photo,
  ];
}
