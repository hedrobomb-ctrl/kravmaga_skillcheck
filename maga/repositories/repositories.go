package repositories

import (
	"database/sql"
	"net/http"

	"github.com/yourname/reponame/models"
)

const STATUS_NOT_EXIST int = 599 //DBにデータがない場合のエラーコード

// メールアドレス・パスワードをキーにログイン情報を取得する
func SelectLoginInfo(db *sql.DB, mail string, pw string) int {
	const sqlStr = `SELECT 1 FROM M_SHAINKAIIN WHERE MAIL_ADDRESS=? AND PASSWORD=?;`

	row := db.QueryRow(sqlStr, mail, pw)

	if err := row.Err(); err != nil {
		//500 Internal Server Error
		return http.StatusInternalServerError
	}

	var result int
	err := row.Scan(&result)

	if err != nil {
		//599 DBにデータがない場合のエラーコード
		return STATUS_NOT_EXIST

	} else {
		//200 OK
		return http.StatusOK
	}

}

// メールアドレスをキーにユーザー情報を取得する
func SelectUserInfo(db *sql.DB, mail string) models.UserInfo {
	const sqlStr = `SELECT
						sh.M_SHAINKAIIN_ID,
						sh.NAME,
						sh.SHAINKAIIN_BANGO,
						sh.M_STORE_ID,
						st.NAME,
						sh.M_ROLE_ID,
						r.NAME,
						sh.ISACTIVE,
						sh.MAIL_ADDRESS,
						sh.PASSWORD,
						sh.AVAILABLE_CLASS,
						sh.POST_CODE,
						sh.ADDRESS,
						sh.BANK_CODE,
						sh.BRANCH_CODE,
						sh.ACCOUNT_TYPE,
						sh.ACCOUNT_NUMBER,
						sh.NOTE,
						sh.ISYELLOW_BELT,
						sh.ISORANGE_BELT,
						sh.ISGREEN_BELT,
						sh.ISBLUE_BELT,
						sh.ISBROWN_BELT,
						sh.ISBLACK_BELT
					FROM 
						M_SHAINKAIIN sh
					INNER JOIN
						M_ROLE r
					ON
						sh.M_ROLE_ID = r.M_ROLE_ID
					INNER JOIN
						M_STORE st
					ON
						sh.M_STORE_ID = st.M_STORE_ID	
					WHERE
						sh.MAIL_ADDRESS=?;`
	var newUserInfo models.UserInfo

	row := db.QueryRow(sqlStr, mail)

	if err := row.Err(); err != nil {
		return models.UserInfo{}
	}

	err := row.Scan(
		&newUserInfo.M_SHAINKAIIN_ID,
		&newUserInfo.NAME,
		&newUserInfo.SHAINKAIIN_BANGO,
		&newUserInfo.M_STORE_ID,
		&newUserInfo.M_STORE_NAME,
		&newUserInfo.M_ROLE_ID,
		&newUserInfo.M_ROLE_NAME,
		&newUserInfo.ISACTIVE,
		&newUserInfo.MAIL_ADDRESS,
		&newUserInfo.PASSWORD,
		&newUserInfo.AVAILABLE_CLASS,
		&newUserInfo.POST_CODE,
		&newUserInfo.ADDRESS,
		&newUserInfo.BANK_CODE,
		&newUserInfo.BRANCH_CODE,
		&newUserInfo.ACCOUNT_TYPE,
		&newUserInfo.ACCOUNT_NUMBER,
		&newUserInfo.NOTE,
		&newUserInfo.ISYELLOW_BELT,
		&newUserInfo.ISORANGE_BELT,
		&newUserInfo.ISGREEN_BELT,
		&newUserInfo.ISBLUE_BELT,
		&newUserInfo.ISBROWN_BELT,
		&newUserInfo.ISBLACK_BELT)

	if err != nil {
		return models.UserInfo{}

	} else {
		return newUserInfo
	}

}

// メールアドレスをキーにユーザーの予約情報を取得する
func SelectReserveInfo(db *sql.DB, mail string) []models.ReserveInfo {
	const sqlStr = `SELECT
						sh.MAIL_ADDRESS,
						sch.M_STORE_ID,
						st.NAME,
						sch.M_CLASS_ID,
						cla.NAME,
						date_format(sch.START_DATE,'%Y年%m月%d日 %H時%i分'),
						sch.ROOM,
						tea.NAME
					FROM 
						T_RESERVE r
					INNER JOIN
						M_SHAINKAIIN sh
					ON
						r.M_SHAINKAIIN_ID = sh.M_SHAINKAIIN_ID
					INNER JOIN
						T_SCHEDULE sch
					ON
						r.T_SCHEDULE_ID = sch.T_SCHEDULE_ID
					INNER JOIN
						M_CLASS cla
					ON
						sch.M_CLASS_ID = cla.M_CLASS_ID
					INNER JOIN
						M_STORE st
					ON
						sch.M_STORE_ID = st.M_STORE_ID
					INNER JOIN
						M_SHAINKAIIN tea
					ON
						sch.M_SHAINKAIIN_ID = tea.M_SHAINKAIIN_ID					
					WHERE
						sh.MAIL_ADDRESS=?
					ORDER BY
						sch.START_DATE ASC;`

	rows, err := db.Query(sqlStr, mail)

	if err := rows.Err(); err != nil {
		return []models.ReserveInfo{}
	}

	ReservInfoArray := make([]models.ReserveInfo, 0)

	for rows.Next() {
		var newReserveInfo models.ReserveInfo

		rows.Scan(
			&newReserveInfo.MAIL_ADDRESS,
			&newReserveInfo.M_STORE_ID,
			&newReserveInfo.M_STORE_NAME,
			&newReserveInfo.M_CLASS_ID,
			&newReserveInfo.M_CLASS_NAME,
			&newReserveInfo.START_DATE,
			&newReserveInfo.ROOM,
			&newReserveInfo.TEACHER,
		)

		if err != nil {
			return []models.ReserveInfo{}

		} else {
			ReservInfoArray = append(ReservInfoArray, newReserveInfo)
		}
	}

	return ReservInfoArray
}

// 習熟度情報を取得
func SelectSkillInfo(db *sql.DB, mail string, belt string) []models.SkillInfo {
	const sqlStr = `select
		? as MAIL_ADDRESS
    	, RPAD(cur.NAME, 30, '　') as SKILL_NAME
    	, RPAD(cur.TECHNIQUE_TYPE, 20, '　') as TECHNIQUE_TYPE
   		, RPAD(case 
            when cur.TECHNIQUE_TYPE = 'FUN' 
                then 'ファンダメンタルズ' 
            when cur.TECHNIQUE_TYPE = 'CON' 
                then 'コンバティブ' 
            when cur.TECHNIQUE_TYPE = 'DEF' 
                then 'ディフェンス' 
            when cur.TECHNIQUE_TYPE = 'SEL' 
                then 'セルフディフェンス' 
            when cur.TECHNIQUE_TYPE = 'SOF' 
                then 'ソフトテクニック' 
            when cur.TECHNIQUE_TYPE = 'FAL' 
                then 'フォール' 
            when cur.TECHNIQUE_TYPE = 'GRO' 
                then 'グラウンドファイティング' 
            end
        , 20, '　') as TECHNIQUE_TYPE_NAME
    	, cur.BELT as BELT
    	, RPAD(case 
            when cur.BELT = 'YEL' 
                then 'イエローベルト' 
            when cur.BELT = 'ORA' 
                then 'オレンジベルト' 
            when cur.BELT = 'GRE' 
                then 'グリーンベルト' 
            when cur.BELT = 'BLU' 
                then 'ブルーベルト' 
            when cur.BELT = 'BRO' 
                then 'ブラウンベルト' 
            when cur.BELT = 'BLA' 
                then 'ブラックベルト' 
            end
        , 20, '　') as BELT_NAME
    , tcp.SKILL_LEVEL as SKILL_LEVEL
    , tcp.T_CUR_PROGRESS_ID as T_CUR_PROGRESS_ID 
	from
    	t_cur_progress tcp 
    	JOIN m_shainkaiin sh 
        	on tcp.M_SHAINKAIIN_ID = sh.M_SHAINKAIIN_ID 
    	join m_curriculum cur 
        	on tcp.M_CURRICULUM_ID = cur.M_CURRICULUM_ID 
	where
    	sh.MAIL_ADDRESS=?
    	and cur.BELT=?
	order by
    	cur.ORDERBY asc;`

	rows, err := db.Query(sqlStr, mail, mail, belt)

	if err := rows.Err(); err != nil {
		return []models.SkillInfo{}
	}

	SkillInfoArray := make([]models.SkillInfo, 0)

	for rows.Next() {
		var newSkillInfo models.SkillInfo

		rows.Scan(
			&newSkillInfo.MAIL_ADDRESS,
			&newSkillInfo.SKILL_NAME,
			&newSkillInfo.SKILL_TYPE,
			&newSkillInfo.SKILL_TYPE_NAME,
			&newSkillInfo.BELT,
			&newSkillInfo.BELT_NAME,
			&newSkillInfo.SKILL_LEVEL,
			&newSkillInfo.T_CUR_PROGRESS_ID,
		)

		if err != nil {
			return []models.SkillInfo{}

		} else {
			SkillInfoArray = append(SkillInfoArray, newSkillInfo)
		}
	}

	return SkillInfoArray
}

// 習熟度を更新し、取得後の習熟度情報を返す
func UpdateSkillLevel(db *sql.DB, mail string, belt string, skill_level string, t_cur_progress_id int) []models.SkillInfo {
	const sql = `UPDATE T_CUR_PROGRESS SET SKILL_LEVEL = ? WHERE T_CUR_PROGRESS_ID = ?;`

	tx, err := db.Begin()

	if err != nil {
		tx.Rollback()
		return []models.SkillInfo{}
	}

	//習熟度情報を更新する
	_, err = tx.Exec(sql, skill_level, t_cur_progress_id)

	if err != nil {
		tx.Rollback()
		return []models.SkillInfo{}
	}

	if err := tx.Commit(); err != nil {
		return []models.SkillInfo{}
	}

	//更新後のデータを再取得
	SkillInfo := SelectSkillInfo(db, mail, belt)
	return SkillInfo

}
