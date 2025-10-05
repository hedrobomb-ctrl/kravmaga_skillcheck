package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/yourname/reponame/models"
	"github.com/yourname/reponame/services"

	_ "github.com/go-sql-driver/mysql"
)

// ログイン処理
func LoginHandler(w http.ResponseWriter, req *http.Request) {
	var reqLoginInfo models.LoginInfo

	if err := json.NewDecoder(req.Body).Decode(&reqLoginInfo); err != nil {
		http.Error(w, "fail to get request body\n", http.StatusBadRequest)
		return
	}

	/*メールアドレスとパスワードの組み合わせをDBから取得
	できたらOKのレスポンスを返す
	できなかったらエラーのレスポンスを返す
	*/
	status := services.GetLoginInfoService(reqLoginInfo.MAIL_ADDRESS, reqLoginInfo.PASSWORD)

	loginInfo := reqLoginInfo

	w.WriteHeader(status)
	json.NewEncoder(w).Encode(loginInfo)

}

// ユーザ情報取得
func IndexHandler(w http.ResponseWriter, req *http.Request) {
	var reqUserInfo models.UserInfo

	if err := json.NewDecoder(req.Body).Decode(&reqUserInfo); err != nil {
		http.Error(w, "fail to get request body\n", http.StatusBadRequest)
		return
	}

	reqUserInfo = services.GetUserInfoService(reqUserInfo.MAIL_ADDRESS)

	json.NewEncoder(w).Encode(reqUserInfo)

}

// クラス予約情報取得
func ReserveHundler(w http.ResponseWriter, req *http.Request) {
	var reqUserInfo models.UserInfo

	if err := json.NewDecoder(req.Body).Decode(&reqUserInfo); err != nil {
		http.Error(w, "fail to get request body\n", http.StatusBadRequest)
		return
	}

	var reqReserveInfo []models.ReserveInfo = services.GetReserveInfoService(reqUserInfo.MAIL_ADDRESS)

	json.NewEncoder(w).Encode(reqReserveInfo)
}

// 技の習熟度取得
func SkillCheckHundler(w http.ResponseWriter, req *http.Request) {
	var reqSkillInfo models.SkillInfo

	if err := json.NewDecoder(req.Body).Decode(&reqSkillInfo); err != nil {
		http.Error(w, "fail to get request body\n", http.StatusBadRequest)
		return
	}

	var reqReserveInfo []models.SkillInfo = services.GetSkillInfoService(reqSkillInfo.MAIL_ADDRESS, reqSkillInfo.BELT)

	json.NewEncoder(w).Encode(reqReserveInfo)
}

// 技の習熟度更新
func SkillUpdateHundler(w http.ResponseWriter, req *http.Request) {
	var reqSkillInfo models.SkillInfo

	if err := json.NewDecoder(req.Body).Decode(&reqSkillInfo); err != nil {
		http.Error(w, "fail to get request body\n", http.StatusBadRequest)
		return
	}

	var reqReserveInfo []models.SkillInfo = services.UpdateSkillLevel(reqSkillInfo.MAIL_ADDRESS, reqSkillInfo.BELT, reqSkillInfo.SKILL_LEVEL, reqSkillInfo.T_CUR_PROGRESS_ID)
	json.NewEncoder(w).Encode(reqReserveInfo)
}
