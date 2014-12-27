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
  
  HuntController() {
    forceClient = new ForceClient();
    forceClient.connect();
    
    forceClient.onConnected.listen((ConnectEvent ce) {
        hunts = forceClient.register("hunters", new Cargo(MODE: CargoMode.LOCAL));
        
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
  
  void today() {
    _addDateParams(0);
  }
  
  void yesterday() {
    _addDateParams(-1);
  }
  
  void _addDateParams(int timeFactor) {
    DateTime now = new DateTime.now();
        
    Map params = new Map();
    params['date'] = {'day': (now.day + timeFactor), 'month': now.month, 'year': now.year};
        
    hunts = forceClient.register("hunters", new Cargo(MODE: CargoMode.LOCAL), params: params);
  }

  void update(key, value) {
      var hunt = new Hunt.fromJson(value);
      hunt.point += 1;
      
      hunts.update(key, hunt);
  }
  
  // Send message on the channel
  void send() {
    if(name != "" && url != "") {
      var author = (userData.profile!=null?userData.profile["displayName"]:'anonym');
      hunts.set(new Hunt(name, url, author: author).toJson());
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