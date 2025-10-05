package models

// ログイン情報
type LoginInfo struct {
	MAIL_ADDRESS string `json:"mail_address"` //メールアドレス
	PASSWORD     string `json:"password"`     //パスワード
}

// ユーザー情報
type UserInfo struct {
	M_SHAINKAIIN_ID  int    `json:"m_shainkaiin_id"`  //社員会員ID
	NAME             string `json:"name"`             //姓名
	SHAINKAIIN_BANGO string `json:"shainkaiin_bango"` //社員会員番号
	M_STORE_ID       int    `json:"m_store_id"`       //店舗ID
	M_STORE_NAME     string `json:"m_store_name"`     //店舗名
	M_ROLE_ID        int    `json:"m_role_id"`        //権限ID
	M_ROLE_NAME      string `json:"m_role_name"`      //権限名
	ISACTIVE         bool   `json:"isactive"`         //有効フラグ
	MAIL_ADDRESS     string `json:"mail_address"`     //メールアドレス
	PASSWORD         string `json:"password"`         //パスワード
	AVAILABLE_CLASS  int    `json:"available_class"`  //参加可能クラス数
	POST_CODE        string `json:"post_code"`        //郵便番号
	ADDRESS          string `json:"address"`          //住所
	BANK_CODE        string `json:"bank_code"`        //銀行コード
	BRANCH_CODE      string `json:"branch_code"`      //支店コード
	ACCOUNT_TYPE     string `json:"account_type"`     //口座種別
	ACCOUNT_NUMBER   string `json:"account_number"`   //口座番号
	NOTE             string `json:"note"`             //健康上の留意点
	ISYELLOW_BELT    bool   `json:"isyellow_belt"`    //イエローベルト所持
	ISORANGE_BELT    bool   `json:"isorange_belt"`    //オレンジベルト所持
	ISGREEN_BELT     bool   `json:"isgreen_belt"`     //グリーンベルト所持
	ISBLUE_BELT      bool   `json:"isblue_belt"`      //ブルーベルト所持
	ISBROWN_BELT     bool   `json:"isbrown_belt"`     //ブラウンベルト所持
	ISBLACK_BELT     bool   `json:"isblack_belt"`     //ブラックベルト所持
}

// 予約情報
type ReserveInfo struct {
	MAIL_ADDRESS string `json:"mail_address"` //メールアドレス
	M_STORE_ID   int    `json:"m_store_id"`   //店舗ID
	M_STORE_NAME string `json:"m_store_name"` //店舗名
	M_CLASS_ID   int    `json:"m_class_id"`   //クラスID
	M_CLASS_NAME string `json:"m_class_name"` //クラス名
	START_DATE   string `json:"start_date"`   //日時
	ROOM         string `json:"room"`         //部屋
	TEACHER      string `json:"teacher"`      //担当者
}

// 習熟度情報
type SkillInfo struct {
	MAIL_ADDRESS      string `json:"mail_address"`      //メールアドレス
	SKILL_NAME        string `json:"skill_name"`        //技名
	SKILL_TYPE        string `json:"skill_type"`        //技種別
	SKILL_TYPE_NAME   string `json:"skill_type_name"`   //技種別名
	BELT              string `json:"belt"`              //ベルト
	BELT_NAME         string `json:"belt_name"`         //ベルト名
	SKILL_LEVEL       string `json:"skill_level"`       //習熟度
	T_CUR_PROGRESS_ID int    `json:"t_cur_progress_id"` //カリキュラム進捗ID

}
