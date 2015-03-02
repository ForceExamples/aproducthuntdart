import 'package:force/force_browser.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:cargo/cargo_client.dart';

import 'lib/hunt.dart';
import 'lib/user_data.dart';

@Injectable()
class HuntController {
  String name = "";
  String url = "";
  
  String error = "";

  ForceClient forceClient;
  ViewCollection hunts;
  UserData userData;
  
  Cargo cargo;
  
  HuntController() {
    forceClient = new ForceClient();
    forceClient.connect();
    cargo = new Cargo(MODE: CargoMode.LOCAL);
    
    forceClient.onConnected.listen((ConnectEvent ce) {
        Options options = new Options(limit: 5, revert: true);
        hunts = forceClient.register("hunters", cargo, deserialize: Hunt.deserializeFromJson, options: options);
        
        // user loggin data
        userData = new UserData();
        userData.onUserData.listen((UserDataEvent ude) {
           forceClient.initProfileInfo(ude.profile);
        });
    });
    
    forceClient.on("notify", (message, sender) {
      error = message.json;
    });
  }
  
  void all() {
    hunts = forceClient.register("hunters", cargo, deserialize: Hunt.deserializeFromJson);
  }
  
  void today() {
    _addDateParams(0);
  }
  
  void yesterday() {
    _addDateParams(-1);
  }
  
  void _addDateParams(int timeFactor) {
    DateTime now = new DateTime.now();
    
    // revert the list! Latest on top ...
    Options options = new Options(revert: true);
        
    Map params = new Map();
    params['date'] = {'day': (now.day + timeFactor), 'month': now.month, 'year': now.year};
        
    hunts = forceClient.register("hunters", cargo, options: options, deserialize: Hunt.deserializeFromJson, params: params);
  }

  void update(key, Hunt hunt) {
      hunt.vote();
      
      hunts.update(key, hunt);
  }
  
  // Send message on the channel
  void send() {
    if(name != "" && url != "") {
      var author = (userData.profile!=null?userData.profile["displayName"]:'anonym');
      hunts.set(new Hunt(name, url, author: author));
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