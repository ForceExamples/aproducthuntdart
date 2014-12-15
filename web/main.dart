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
        hunts = forceClient.register("hunters", new Cargo(MODE: CargoMode.LOCAL));
    });
  }

  void update(id, data) {
      var hunt = new Hunt.fromJson(data);
      
      hunt.point += 1;
      hunts.update(id, hunt);
  }
  
  void remove(id) {
     hunts.remove(id);
  }
  
  // Send message on the channel
  void send() {
    if(name != "" && url != "") {
      hunts.set(new Hunt(name, url).toJson());
    }
  }
}

void main() {
  applicationFactory()
      .rootContextType(HuntController)
      .run();
}