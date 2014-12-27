library user;

import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:async";
import "dart:html";
import "dart:convert";

class UserDataEvent {
  var profile;
  UserDataEvent(this.profile);
}

class UserData {
  
  bool loggedIn = false;
  
  var profile;
  var auth;
  
  StreamController<UserDataEvent> _controller = new StreamController<UserDataEvent>(); 
  
  UserData() {
    auth = new GoogleOAuth2(
        "482180074869-jtuonj4qdfmj6lsulqgcpu1i80q0kqhr.apps.googleusercontent.com",
        ["https://www.googleapis.com/auth/plus.login"],
        tokenLoaded: _oauthReady,
        autoLogin: false);
  }
  
  void login() {
        auth.login(onlyLoadToken: false)
          .then(_oauthReady)
          .catchError((e) {
            print("$e");
          });
  }
  
  Future _oauthReady(Token token) {
    final url = "https://www.googleapis.com/plus/v1/people/me?key=AIzaSyAmvW0rljut3unDFHjUYhoA-V1-UQ11Hd8";

    var headers = getAuthorizationHeaders(token.type, token.data);

    return HttpRequest.request(url, requestHeaders: headers)
      .then((HttpRequest request) {
        if (request.status == 200) {
          profile = JSON.decode(request.responseText);
          print(profile);
          
          _controller.add(new UserDataEvent(profile));
          
          loggedIn = true;
        }
      });
  }
  
  Stream get onUserData => _controller.stream;
  
}