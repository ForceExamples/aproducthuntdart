library models;

class Hunt {
  String name, url;
  
  int point;

  Hunt(this.name, this.url, {this.point: 0});

  Hunt.fromJson(Map data) {
    print("going to transform data");
    print(data);
    name    = data["name"];
    url = data["url"];
    point = data["point"];
  }

  Map toJson() => {"name": name, "url": url, "point": point};
}