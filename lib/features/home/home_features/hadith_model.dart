class HadithModel {
  final int id;
  final int idInBook;
  final int chapterId;
  final int bookId;
  final String arabic;
  final String narrator;
  final String englishText;

  HadithModel({
    required this.id,
    required this.idInBook,
    required this.chapterId,
    required this.bookId,
    required this.arabic,
    required this.narrator,
    required this.englishText,
  });

  factory HadithModel.fromFirestore(Map<String, dynamic> data) {
    return HadithModel(
      id: data['id'] ?? 0,
      idInBook: data['idInBook'] ?? 0,
      chapterId: data['chapterId'] ?? 0,
      bookId: data['bookId'] ?? 0,
      arabic: data['arabic'] ?? '',
      narrator: data['english']['narrator'] ?? '',
      englishText: data['english']['text'] ?? '',
    );
  }
}
