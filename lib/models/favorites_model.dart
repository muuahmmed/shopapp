class ChangeFavouritesModel {
  bool? status;
  String? message;

  ChangeFavouritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message'];
  }
}
