abstract class NotificationResponseBase {
  const new({this.id, this.payload});
  final int? id;
  final String? payload;
}
