class QueryParameters {
  int? id;
  int? userId;
  String? status;
  String? name;
  int? categoryId;
  int? artistId;
  String? email;
  bool? withSettled;
  int? page;
  int? perPage = 8;
  int? limit;
  String? loanId;
  bool? latest;
  bool? featured;
  bool? random;

  QueryParameters({
    this.id,
    this.userId,
    this.status,
    this.perPage,
    this.name,
    this.categoryId,
    this.artistId,
    this.email,
    this.withSettled,
    this.page,
    this.limit,
    this.loanId,
    this.latest,
    this.featured,
    this.random,
  });
}
