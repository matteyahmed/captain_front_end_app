class ApiConstants {
  static String baseUrl = 'http://10.0.2.2:8000/api';
  // static String baseUrl = 'http://127.0.0.1:8000/api';
  // static String baseUrl = 'https://arrivaapp6-production.up.railway.app/api';
  // static String baseUrl = 'https://arrivaapp005-production.up.railway.app/api';
  //
  static String loginUserEndpoint = '/login/';
  static String logOutUserEndpoint = '/logout/';
  //
  static String userProfileEndpoint = '/profile/';
  static String onOffCaptain = '/assign-captain/';
  static String allBoats = '/all-boats/';

  // Item Request
  static String itemRequestSubmit = '/itemrequest-submit/';
  static String itemReqeustView = '/itemrequest-view/';
  static String itemUpdateReqeust = '/itemrequest-update-view/';

  static String leaveRequestSubmit = '/leaverequest-submit/';
  static String leaveRequestView = '/leaverequest/';


  // Fuel Sheet
  static String fuelSheetSubmit = '/fuelsheet-submit/';
  static String fuelSheetView = '/fuelsheet-view/';

  // Trip Sheet
  static String tripSheetViewEndpoint = '/tripsheet-view/';
  static String tripSheetSubmitEndpoint = '/tripsheet-submit/';

  // CheckList
  static String checkListViewEndPoint = '/checklist-view/';
  static String checkListFormSubmit = '/checklist-submit/';
}

class SocketConstants {
  // static String baseSocket = "wss://arrivaapp6-production.up.railway.app/ws";
  // static String baseSocket = "wss://arrivaapp005-production.up.railway.app/ws";
  static String baseSocket = "ws://10.0.2.2:8000/ws";
  static String socketCaptain = '/captain/?token=';
  static String socketTripSheet = '/tripsheet/?token=';
}