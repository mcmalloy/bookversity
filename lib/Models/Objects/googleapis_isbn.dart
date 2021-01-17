class ISBNBody{
  int totalItems;
  ISBNBody(this.totalItems);

  ISBNBody.fromJson(Map<String, dynamic> json)
      : totalItems = int.parse(json['totalItems']);
}