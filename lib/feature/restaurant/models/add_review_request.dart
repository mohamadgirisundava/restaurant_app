class AddReviewRequest {
  String id;
  String name;
  String review;

  AddReviewRequest({
    required this.id,
    required this.name,
    required this.review,
  });

  Map<String, dynamic> toJson() => {"id": id, "name": name, "review": review};
}
