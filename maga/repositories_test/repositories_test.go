package repositories_test

//通常のGOの作法であればrepositories。（そちらでもよいが、通常はtestコードは_testのパッケージにする）
//通常のパッケージに同梱すると、テストコードで使えなくてもいいメソッドや変数がtestで使える。（無駄に密結合)

import (
	"database/sql"
	"fmt"
	"os"
	"testing"

	"github.com/yourname/reponame/models"
	"github.com/yourname/reponame/repositories"

	_ "github.com/go-sql-driver/mysql"
)

var testDB *sql.DB

// テスト関数共通の事前処理 ←関数名固定
func setup() error {
	dbUser := "root"
	dbPassword := "root"
	dbDatabase := "mysql"
	dbConn := fmt.Sprintf("%s:%s@tcp(127.0.0.1:3306)/%s?parseTime=true", dbUser, dbPassword, dbDatabase)

	var err error
	testDB, err = sql.Open("mysql", dbConn)

	if err != nil {
		return err
	}

	return nil
}

// テスト関数共通の事後処理 ←関数名固定
func teardown() {
	testDB.Close()
}

// テストメイン関数 ←関数名固定
func TestMain(m *testing.M) {
	err := setup()
	if err != nil {
		os.Exit(1)
	}

	m.Run()

	teardown()
}

func TestSelectLoginInfo(t *testing.T) {
	tests := []struct {
		testTitle string
		mail      string
		pw        string
		expected  int
	}{
		{
			testTitle: "OK",
			mail:      "hogehoge@gmail.com",
			pw:        "test",
			expected:  200,
		},
		{
			testTitle: "OK",

			mail:     "hogehoge@gmail.com",
			pw:       "testxxx",
			expected: 599,
		},
	}

	for _, test := range tests {
		t.Run(test.testTitle, func(t *testing.T) {
			result := repositories.SelectLoginInfo(testDB, test.mail, test.pw)

			if result != test.expected {
				t.Errorf("StatusCode:get %d but want %d. Parameter: mail= %s, pw= %s\n", result, test.expected, test.mail, test.pw)
			}
		})

	}
}

func TestSelectUserInfo(t *testing.T) {
	tests := []struct {
		testTitle string
		mail      string
		expected  models.UserInfo
	}{
		{
			testTitle: "OK",
			mail:      "hogehoge@gmail.com",
			expected: models.UserInfo{
				M_SHAINKAIIN_ID:  1,
				NAME:             "テスト会員",
				SHAINKAIIN_BANGO: "50004006",
				M_STORE_ID:       1,
				M_STORE_NAME:     "赤坂店",
				M_ROLE_ID:        1,
				M_ROLE_NAME:      "スタンダード会員",
				ISACTIVE:         true,
				MAIL_ADDRESS:     "hogehoge@gmail.com",
				PASSWORD:         "test",
				AVAILABLE_CLASS:  5,
				POST_CODE:        "100-0001",
				ADDRESS:          "東京都板橋区XXXXXXXX999-99",
				BANK_CODE:        "0004",
				BRANCH_CODE:      "135",
				ACCOUNT_TYPE:     "1",
				ACCOUNT_NUMBER:   "9999999",
				NOTE:             "",
				ISYELLOW_BELT:    false,
				ISORANGE_BELT:    false,
				ISGREEN_BELT:     false,
				ISBLUE_BELT:      false,
				ISBROWN_BELT:     false,
				ISBLACK_BELT:     false,
			},
		},
	}

	for _, test := range tests {
		t.Run(test.testTitle, func(t *testing.T) {
			result := repositories.SelectUserInfo(testDB, test.mail)

			if result.MAIL_ADDRESS != test.expected.MAIL_ADDRESS {
				t.Errorf("got:%s,excected:%s \n\n result.M_SHAINKAIIN_ID:%d\n,result.NAME:%s \n,SHAINKAIIN_BANGO:%s\n,M_STORE_ID:%d\n,M_STORE_NAME:%s\n,M_ROLE_ID:%d\n,M_ROLE_NAME:%s\n,ISACTIVE:%t\n,MAIL_ADDRESS:%s\n,PASSWORD:%s\n,AVAILABLE_CLASS:%d\n,POST_CODE:%s\n,ADDRESS:%s\n,BANK_CODE:%s\n,BRANCH_CODE:%s\n,ACCOUNT_TYPE:%s\nACCOUNT_NUMBER:%s\n,NOTE:%s\n,ISYELLOW_BELT:%t\n,ISORANGE_BELT:%t\n,ISGREEN_BELT:%t\n,ISBLUE_BELT:%t\n,ISBROWN_BELT:%t\n,ISBLACK_BELT:%t\n",
					result.MAIL_ADDRESS, test.expected.MAIL_ADDRESS,
					result.M_SHAINKAIIN_ID,
					result.NAME,
					result.SHAINKAIIN_BANGO,
					result.M_STORE_ID,
					result.M_STORE_NAME,
					result.M_ROLE_ID,
					result.M_ROLE_NAME,
					result.ISACTIVE,
					result.MAIL_ADDRESS,
					result.PASSWORD,
					result.AVAILABLE_CLASS,
					result.POST_CODE,
					result.ADDRESS,
					result.BANK_CODE,
					result.BRANCH_CODE,
					result.ACCOUNT_TYPE,
					result.ACCOUNT_NUMBER,
					result.NOTE,
					result.ISYELLOW_BELT,
					result.ISORANGE_BELT,
					result.ISGREEN_BELT,
					result.ISBLUE_BELT,
					result.ISBROWN_BELT,
					result.ISBLACK_BELT,
				)
			}
		})

	}
}

func TestSelectReserveInfo(t *testing.T) {
	tests := []struct {
		testTitle string
		mail      string
		expected  models.ReserveInfo
	}{
		{
			testTitle: "OK",
			mail:      "hogehoge@gmail.com",
			expected: models.ReserveInfo{
				MAIL_ADDRESS: "hogehoge@gmail.com",
			},
		},
	}

	for _, test := range tests {
		t.Run(test.testTitle, func(t *testing.T) {
			result := repositories.SelectReserveInfo(testDB, test.mail)

			if result == nil {
				t.Errorf("Parameter: mail:%s, Excected: mail:%s", test.mail, test.expected.MAIL_ADDRESS)
			}

		})

	}
}

func TestSelectSkillInfo(t *testing.T) {
	tests := []struct {
		testTitle string
		mail      string
		belt      string
		expected  models.SkillInfo
	}{
		{
			testTitle: "OK",
			mail:      "hogehoge@gmail.com",
			belt:      "YEL",
			expected: models.SkillInfo{
				MAIL_ADDRESS: "hogehoge@gmail.com",
				BELT:         "YEL",
			},
		},
	}

	for _, test := range tests {
		t.Run(test.testTitle, func(t *testing.T) {
			result := repositories.SelectSkillInfo(testDB, test.mail, test.belt)

			if result == nil {
				t.Errorf("Parameter: mail:%s Belt:%s, Excected: mail:%s Belt:%s", test.mail, test.belt, test.expected.MAIL_ADDRESS, test.expected.BELT)
			}

		})

	}
}

func TestUpdateSkillLevel(t *testing.T) {
	var beforeLevel string

	tests := []struct {
		testTitle         string
		mail              string
		belt              string
		skill_level       string
		t_cur_progress_id int
		expected          models.SkillInfo
	}{
		{
			testTitle:         "OK",
			mail:              "hogehoge@gmail.com",
			belt:              "YEL",
			skill_level:       "3",
			t_cur_progress_id: 1,
			expected: models.SkillInfo{
				MAIL_ADDRESS: "hogehoge@gmail.com",
				BELT:         "YEL",
			},
		},
	}
	for _, test := range tests {

		//更新前のデータを取得する
		before := repositories.SelectSkillInfo(testDB, test.mail, test.belt)

		if len(before) < 1 {
			t.Fatal("fail to get before data")

		}
		//更新前のレコードIDに紐づくスキルレベルを取得する　※データ復元用
		for _, id := range before {
			if id.T_CUR_PROGRESS_ID == test.t_cur_progress_id {
				beforeLevel = id.SKILL_LEVEL
			}
		}
		result := repositories.UpdateSkillLevel(testDB, test.mail, test.belt, test.skill_level, test.t_cur_progress_id)

		if len(result) < 1 {
			t.Fatal("fail to update data")

		}

		//テスト前の状態にデータ復元
		t.Cleanup(func() {
			const sqlStr = `UPDATE T_CUR_PROGRESS SET SKILL_LEVEL = ? WHERE T_CUR_PROGRESS_ID = ?;`

			testDB.Exec(sqlStr, beforeLevel, test.t_cur_progress_id)
		})

	}
}
