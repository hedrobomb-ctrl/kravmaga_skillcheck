package services

import (
	"net/http"

	"github.com/yourname/reponame/models"
	"github.com/yourname/reponame/repositories"
)

// ログイン情報を取得
func GetLoginInfoService(mail string, pw string) int {
	db, err := connectDB()
	if err != nil {
		//500 Internal Server Error
		return http.StatusInternalServerError
	}
	defer db.Close()

	status := repositories.SelectLoginInfo(db, mail, pw)

	return status

}

// ユーザー情報を取得
func GetUserInfoService(mail string) models.UserInfo {
	db, err := connectDB()
	if err != nil {
		//500 Internal Server Error
		return models.UserInfo{}
	}
	defer db.Close()

	UserInfo := repositories.SelectUserInfo(db, mail)

	return UserInfo

}

// 予約情報を取得
func GetReserveInfoService(mail string) []models.ReserveInfo {
	db, err := connectDB()
	if err != nil {
		//500 Internal Server Error
		return []models.ReserveInfo{}
	}
	defer db.Close()

	ReserveInfo := repositories.SelectReserveInfo(db, mail)

	return ReserveInfo

}

// 習熟度情報を取得
func GetSkillInfoService(mail string, belt string) []models.SkillInfo {
	db, err := connectDB()
	if err != nil {
		//500 Internal Server Error
		return []models.SkillInfo{}
	}
	defer db.Close()

	SkillInfo := repositories.SelectSkillInfo(db, mail, belt)

	return SkillInfo

}

// 習熟度を更新し、取得後の習熟度情報を返す
func UpdateSkillLevel(mail string, belt string, skill_level string, t_cur_progress_id int) []models.SkillInfo {
	db, err := connectDB()
	if err != nil {
		return []models.SkillInfo{}
	}
	defer db.Close()

	SkillInfo := repositories.UpdateSkillLevel(db, mail, belt, skill_level, t_cur_progress_id)

	if err != nil {
		return []models.SkillInfo{}

	} else {
		return SkillInfo
	}
}
