library aproducthuntdart;

import 'package:force/force_serverside.dart';
import 'package:bigcargo/bigcargo.dart';
import 'dart:async';

import '../web/lib/hunt.dart';

main() {
  // You can also use a memory implementation here, just switch the CargoMode to MEMORY
  Cargo cargo = new Cargo(MODE: CargoMode.MONGODB, conf: {"address": "mongodb://127.0.0.1/test" });
  
  // Create a force server
  ForceServer fs = new ForceServer(port: 4040, 
                                 clientFiles: '../build/web/');
    
  // Setup logger
  fs.setupConsoleLog();
  
  // wait until our forceserver is been started and our connection with the persistent layer is done!
  Future.wait([fs.start(), cargo.start()]).then((_) { 
      // Tell Force what the start page is!
      fs.server.static("/", "producthunt.html");
     
      fs.publish("hunters", cargo, validate: (CargoPackage fcp, Sender sender) {
        if (fcp.json!=null) {
          // Check if the url is a url ...
          Hunt hunt = new Hunt.fromJson(fcp.json);
          if (!hunt.url.startsWith("http")) {
            fcp.cancel();
            
            sender.reply("notify", "url not correct!");
          }
        }
      });
    
    });
}

