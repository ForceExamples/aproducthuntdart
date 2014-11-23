import 'dart:html';
import 'dart:convert';

import 'package:force/force_browser.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:cargo/cargo_client.dart';

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

@Injectable()
class HuntController {
  String name = "";
  String url = "";

  ForceClient forceClient;
  ViewCollection hunts;
  
  HuntController() {
    forceClient = new ForceClient();
    forceClient.connect();
        
    forceClient.onConnected.listen((ConnectEvent ce) {
//        forceClient.on("hunters", (e, sender) {
//          print(e.json);
//          
//          var value = e.json;
//          
//          if (value is Map) {
//            print("is map!");
//          } else if (value is String) {
//            print("is a String!");
//          } else {
//            print("not a string and not a map!");
//          }
//          hunts.insert(0, new Hunt.fromJson(value));
//        });
        hunts = forceClient.register("hunters", new Cargo(MODE: CargoMode.LOCAL));
    });
  }

  void update(id, data) {
    print("$id is a $data");
    if (data is Map) { 
      var hunt = new Hunt.fromJson(data);
      
      hunt.point += 1;
      hunts.update(id, hunt);
    }
  }
  
  // Send message on the channel
  void send() {
    if(name != "" && url != "") {
      forceClient.set("hunters", "hunt", new Hunt(name, url).toJson());
    }
  }
}

void main() {
  applicationFactory()
      .rootContextType(HuntController)
      .run();
}