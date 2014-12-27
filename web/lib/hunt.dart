library models;

class Hunt {
  String name, url, author;
  
  int point;
  
  DateTime date;

  Hunt(this.name, this.url, {this.point: 0, this.author: "anonymous"}) {
    this.date = new DateTime.now();
  }

  Hunt.fromJson(Map data) {
    name    = data["name"];
    url = data["url"];
    point = data["point"];
    author = (data["author"]==null||data["author"]==''?"anonymous":data["author"]);
    date = new DateTime(data["date"]["year"], data["date"]["month"], data["date"]["day"]);
  }
  
  Map toJson() => {"name": name, "url": url, "point": point, "author": author, "date": { "day": date.day, "month": date.month, "year": date.year }};
  
}