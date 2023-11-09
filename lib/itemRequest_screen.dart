import 'dart:ffi';

import 'package:captain_app_2/ItemRequest_form.dart';
import 'package:captain_app_2/api/api_service.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:captain_app_2/components/nav_anim_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

import 'package:captain_app_2/api/constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ItemRequestScreen extends StatefulWidget {
  final String apiUrl;
  final String token;
  const ItemRequestScreen({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<ItemRequestScreen> createState() => _ItemRequestScreenState();
}

class _ItemRequestScreenState extends State<ItemRequestScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? itemsRequested;
  bool isLoading = false;
  bool isChecked = false;
  List<int> myIds = [];
  List<String> myReceived = [];
  List<TextEditingController> receivedControllers = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData method when the widget is initialized
  }

  Future<void> _handleRefresh() async {
    // Call the fetchData function to refresh the data
    await fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String? token = await TokenService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    http.Response response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.itemReqeustView),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        itemsRequested = jsonDecode(response.body);
        isLoading = false;
        // print("From FuelSheet View: ${itemsRequested}");
      });
    } else {
      setState(() {
        isLoading = false;
        print("Nothing to show from Fuel SHeet");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Preprocess the itemsRequested list to group items by day
    final receivedContoller = TextEditingController();

    Map<String, List<Map<String, dynamic>>> groupedItems = itemsRequested !=
            null
        ? itemsRequested!.fold({},
            (Map<String, List<Map<String, dynamic>>> acc, item) {
            String createdDate = item['created_date'];
            String createdBy = item['created_by'];
            String day =
                DateFormat('MMM d y').format(DateTime.parse(createdDate));
            String groupKey = '$day\n$createdBy'; // Combine date and createdBy

            if (!acc.containsKey(groupKey)) {
              acc[groupKey] = [];
            }

            acc[groupKey]!.add(item);
            return acc;
          })
        : {};

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('ITEM REQUEST'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            legendIcons(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: groupedItems.entries.map(
                  (entry) {
                    String formattedDate = entry.key;

                    List<Widget> itemWidgets = entry.value.map((item) {
                      String itemName = item['item'];
                      int quantity = item['quantity'];
                      String status = item['status'];
                      String received = item['received'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // createdByWidget,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Text('$status', style: TextStyle(fontSize: 12)),
                                  StatusBasedCheckbox(
                                    status: status,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '$itemName',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('$quantity',
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ItemRequestListChecBox(status: received),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList();

                    List<Widget> itemSubmiWdget = entry.value.map((item) {
                      String status = item['status'];
                      String itemName = item['item'];
                      int quantity = item['quantity'];
                      String received = item['received'];
                      int ids = item['id'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // createdByWidget,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        StatusBasedCheckbox(status: status),
                                        SizedBox(width: 5),
                                        Text(
                                          itemName,
                                          style: TextStyle(fontSize: 12),
                                          overflow: TextOverflow.fade,
                                          
                                        ),
                                      ],
                                    ),
                                    if (status == 'C')
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '$quantity',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            // Show CaptainReceivedCheckBox fields only when status is 'C'
                                            CaptainReceivedCheckBox(
                                              received: received,
                                              onChanged: (value) {
                                                _apiService.updateItemRequest(
                                                    ids, value);
                                                print(
                                                    "This is from Submit view $value and the $ids, $itemName");
                                                myIds.add(ids);
                                                myReceived.add(received);
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 150),
                                    title: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Items can only be Received, when Dispatched from Work shop',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.pink.shade800),
                                          ),
                                        ],
                                      ),
                                    ),
                                    content: SingleChildScrollView(child: Column(children: itemSubmiWdget)),
                                  );
                                });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          itemWidgets, // Add the itemWidgets here
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          elevation: 10.0,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
          backgroundColor: Colors.black,
          onPressed: () => {
            Navigator.push(
                context,
                SlidePageRoute(
                    page: ItemRequestForm(
                      apiUrl: widget.apiUrl,
                      token: widget.token,
                    ),
                    context: context)),
          },
        ),
      ),
    );
  }

  Column legendIcons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.check_box_outlined,
                    color: Colors.blue[800], size: 20),
                SizedBox(width: 5),
                Text(
                  'Dispatched',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
                     SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.indeterminate_check_box_outlined,
                    color: Colors.blue[800], size: 20),
                SizedBox(width: 5),
                Text(
                  'Pending',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
                                 SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.assignment_late_outlined, color: Colors.blue[800], size: 20),
                SizedBox(width: 5),
                Text(
                  'No stock',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
                                 SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Received',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Icon(Icons.check_box_outlined,
                    color: Colors.pink[800], size: 20),
              ],
            ),
                      SizedBox(width: 10),
            Row(
              children: [
                Text(
                  'Not Received',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          SizedBox(width: 5),
                Icon(Icons.highlight_off_outlined,
                    color: Colors.pink[800], size: 20),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class ItemRequestListChecBox extends StatefulWidget {
  final String status;

  ItemRequestListChecBox({
    required this.status,
  });

  @override
  _ItemRequestListChecBoxState createState() => _ItemRequestListChecBoxState();
}

class _ItemRequestListChecBoxState extends State<ItemRequestListChecBox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.status == 'r') {
      isChecked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (widget.status == 'r') {
      icon = Icon(
        Icons.check_box_outlined,
        color: Colors.pink[800],
        size: 20,
      );
    } else {
      icon = Icon(
        Icons.highlight_off_outlined,
        color: Colors.pink[800],
        size: 20,
      );
    }
    return Container(
      child: Column(
        children: [icon],
      ),
    );
  }
}

class StatusBasedCheckbox extends StatefulWidget {
  final String status;

  StatusBasedCheckbox({
    required this.status,
  });

  @override
  _StatusBasedCheckboxState createState() => _StatusBasedCheckboxState();
}

class _StatusBasedCheckboxState extends State<StatusBasedCheckbox> {
  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (widget.status == 'C') {
      icon = Icon(
        Icons.check_box_outlined,
        color: Colors.blue[800],
        size: 20,
      );
    } else if (widget.status == 'p') {
      icon = Icon(
        Icons.indeterminate_check_box_outlined,
        color: Colors.blue[800],
        size: 20,
      );
    } else {
      icon = Icon(
        Icons.assignment_late_outlined,
        color: Colors.blue[800],
        size: 20,
      );
    }
    return Container(
      child: Column(
        children: [icon],
      ),
    );
  }
}

class CaptainReceivedCheckBox extends StatefulWidget {
  final String received;
  final Function(String) onChanged;

  CaptainReceivedCheckBox({required this.received, required this.onChanged});

  @override
  _CaptainReceivedCheckBoxState createState() =>
      _CaptainReceivedCheckBoxState();
}

class _CaptainReceivedCheckBoxState extends State<CaptainReceivedCheckBox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.received == 'r') {
      isChecked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Checkbox(
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // visualDensity: VisualDensity.compact,
        value: isChecked,
        onChanged: (bool? newValue) {
          setState(() {
            isChecked = newValue ?? false;
            widget.onChanged(isChecked ? 'r' : 'n');
          });
        },
      ),
    );
  }
}
