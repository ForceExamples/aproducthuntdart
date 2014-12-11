library aproducthuntdart;

import 'package:force/force_serverside.dart';
import 'package:mustache4dart/mustache4dart.dart';
import 'package:bigcargo/bigcargo.dart';
import 'dart:async';

main() {
  // You can also use a memory implementation here, just switch the CargoMode to MEMORY
  Cargo cargo = new Cargo(MODE: CargoMode.MONGODB, conf: {"collection": "store", "address": "mongodb://127.0.0.1/test" });
  
  // Create a force server
  ForceServer fs = new ForceServer(port: 4040, 
                                 clientFiles: '../build/web/');
    
  // Setup logger
  fs.setupConsoleLog();
  
  // wait until our forceserver is been started and our connection with the persistent layer is done!
  Future.wait([fs.start(), cargo.start()]).then((_) { 
      // we need to change {{ into [[ because of angular
      if (fs.server.viewRender is MustacheRender) {
         MustacheRender mustacheRender = fs.server.viewRender;
         mustacheRender.delimiter = new Delimiter('[[', ']]');
      }
      
      // Tell Force what the start page is!
      fs.server.use("/", (req, model) => "producthunt");
     
      fs.publish("hunters", cargo, (data, params, id) {
        print("send some data $data");
        return true;
      });
    
    });
}

