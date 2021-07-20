
class BusinessModel {
  String name;
  int totalCapacity;
  int currHeadCount;
  double percentCapacity;
  int waitTime;

  BusinessModel({this.name, this.totalCapacity, this.currHeadCount, this.percentCapacity, this.waitTime});

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      name: json['name'],
      totalCapacity: json['total_capacity'],
      currHeadCount: json['current_headcount'],
      percentCapacity: json['percent_capacity'],
      waitTime: json['wait_time'],
    );
  }
}
