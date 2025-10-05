//ユーザ情報
class UserInfo {
  final int m_shainkaiin_id;
  final String name;
  final String shainkaiin_bango;
  final int m_store_id;
  final String m_store_name;
  final int m_role_id;
  final String m_role_name;
  final bool isactive;
  final String mail_address;
  final String password;
  final int available_class;
  final String post_code;
  final String address;
  final String bank_code;
  final String branch_code;
  final String account_type;
  final String account_number;
  final String note;
  final bool isyellow_belt;
  final bool isorange_belt;
  final bool isgreen_belt;
  final bool isblue_belt;
  final bool isbrown_belt;
  final bool isblack_belt;

  UserInfo({
    required this.m_shainkaiin_id,
    required this.name,
    required this.shainkaiin_bango,
    required this.m_store_id,
    required this.m_store_name,
    required this.m_role_id,
    required this.m_role_name,
    required this.isactive,
    required this.mail_address,
    required this.password,
    required this.available_class,
    required this.post_code,
    required this.address,
    required this.bank_code,
    required this.branch_code,
    required this.account_type,
    required this.account_number,
    required this.note,
    required this.isyellow_belt,
    required this.isorange_belt,
    required this.isgreen_belt,
    required this.isblue_belt,
    required this.isbrown_belt,
    required this.isblack_belt,
  });

  factory UserInfo.fromJSon(Map<String, dynamic> json) {
    return UserInfo(
      m_shainkaiin_id: json['m_shainkaiin_id'],
      name: json['name'],
      shainkaiin_bango: json['shainkaiin_bango'],
      m_store_id: json['m_store_id'],
      m_store_name: json['m_store_name'],
      m_role_id: json['m_role_id'],
      m_role_name: json['m_role_name'],
      isactive: json['isactive'],
      mail_address: json['mail_address'],
      password: json['password'],
      available_class: json['available_class'],
      post_code: json['post_code'],
      address: json['address'],
      bank_code: json['bank_code'],
      branch_code: json['branch_code'],
      account_type: json['account_type'],
      account_number: json['account_number'],
      note: json['note'],
      isyellow_belt: json['isyellow_belt'],
      isorange_belt: json['isorange_belt'],
      isgreen_belt: json['isgreen_belt'],
      isblue_belt: json['isblue_belt'],
      isbrown_belt: json['isbrown_belt'],
      isblack_belt: json['isblack_belt'],
    );
  }
}
