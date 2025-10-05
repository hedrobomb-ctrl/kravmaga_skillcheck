//予約情報
class Skillinfo{
  final String mail_address;
  final String skill_name;
  final String skill_type;
  final String skill_type_name;
  final String belt;
  final String belt_name;
  final String skill_level;
  final int t_cur_progress_id;


  Skillinfo({
    required this.mail_address,
    required this.skill_name,
    required this.skill_type,
    required this.skill_type_name,
    required this.belt,
    required this.belt_name,
    required this.skill_level,
    required this.t_cur_progress_id});

  factory Skillinfo.fromJSon(Map<String,dynamic> json){

    return Skillinfo(
      mail_address: json['mail_address'],
      skill_name: json['skill_name'],
      skill_type: json['skill_type'],
      skill_type_name: json['skill_type_name'],
      belt: json['belt'],
      belt_name: json['belt_name'],
      skill_level: json['skill_level'],
      t_cur_progress_id: json['t_cur_progress_id'],
    );
  }
}