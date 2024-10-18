class Certificate{
  int id;
  String name;
  String description;
  String? file;
  Certificate({
    required this.id,
    required this.name,
    required this.description,
    this.file
});
}