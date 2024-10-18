class File {
  final int id;
  final String file;
  final DateTime createDate;
  final bool status;

  File({
    required this.id,
    required this.file,
    required this.createDate,
    required this.status,
  });

  // Factory để tạo File từ JSON
  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'] as int,
      file: json['file'] as String,
      createDate: DateTime.parse(json['createDate'] as String),
      status: json['status'] as bool,
    );
  }

  // Phương thức để chuyển đổi File thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'createDate': createDate.toIso8601String(),
      'status': status,
    };
  }

  // Factory để tạo File ban đầu với giá trị mặc định
  factory File.initial() {
    return File(
      id: 0,
      file: "https://png.pngtree.com/png-clipart/20190903/original/pngtree-store-icon-png-image_4419850.jpg",
      createDate: DateTime.now(),
      status: true,
    );
  }
}