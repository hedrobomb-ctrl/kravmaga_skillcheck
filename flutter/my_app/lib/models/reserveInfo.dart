//予約情報
class Reserveinfo{
  final String mail_address;
  final int m_store_id;
  final String m_store_name;
  final int m_class_id;
  final String m_class_name;
  final String start_date;
  final String room;
  final String teachar;


  Reserveinfo({
    required this.mail_address,
    required this.m_store_id,
    required this.m_store_name,
    required this.m_class_id,
    required this.m_class_name,
    required this.start_date,
    required this.room,
    required this.teachar});

  factory Reserveinfo.fromJSon(Map<String,dynamic> json){

    return Reserveinfo(
        mail_address: json['mail_address'],
        m_store_id: json['m_store_id'],
        m_store_name: json['m_store_name'],
        m_class_id: json['m_class_id'],
        m_class_name: json['m_class_name'],
        start_date: json['start_date'],
        room: json['room'],
        teachar: json['teacher'],
    );
  }
}