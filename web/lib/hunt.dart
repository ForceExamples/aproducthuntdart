library models;

class Hunt {
  String name, url;
  
  int point;
  
  DateTime date;

  Hunt(this.name, this.url, {this.point: 0}) {
    this.date = new DateTime.now();
  }

  Hunt.fromJson(Map data) {
    print("going to transform data");
    print(data);
    name    = data["name"];
    url = data["url"];
    point = data["point"];
    date = new DateTime(data["date"]["year"], data["date"]["month"], data["date"]["day"]);
  }
  
  Map toJson() => {"name": name, "url": url, "point": point, "date": { "day": date.day, "month": date.month, "year": date.year }};
  
}