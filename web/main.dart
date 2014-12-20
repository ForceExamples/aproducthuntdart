import 'dart:html';
import 'dart:convert';

import 'package:force/force_browser.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:cargo/cargo_client.dart';

import 'lib/hunt.dart';

@Injectable()
class HuntController {
  String name = "";
  String url = "";
  
  String error = "";

  ForceClient forceClient;
  ViewCollection hunts;
  
  HuntController() {
    forceClient = new ForceClient();
    forceClient.connect();
        
    forceClient.onConnected.listen((ConnectEvent ce) {
        hunts = forceClient.register("hunters", new Cargo(MODE: CargoMode.LOCAL));
    });
    
    forceClient.on("notify", (message, sender) {
      error = message.json;
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
      // reset error field
      error = "";
    }
  }
}

void main() {
  applicationFactory()
      .rootContextType(HuntController)
      .run();
}