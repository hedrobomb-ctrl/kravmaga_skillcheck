/* Goではファイル名がxxx_test.goとなっているファイルはテストが書かれたファイルと認識さ
れます。そのため、きちんとそのパターンに沿った命名をするのがとても重要です。


通常Goには「main以外のパッケージ名はそのファイルが格納されているディレクトリ名と同名
にする必要がある」というルールがあります。そのため、本来repositoriesディレクトリ内に
あるGoのプログラムはrepositoriesパッケージに所属させなくてはいけません。しかし、この
ルールは「テストファイルxxx_test.goでは[ディレクトリ名]_testというパッケージ名を使っ
ても良い」という例外があるのです。
今回はrepositories_testというパッケージ名を使うことにしました。

*/

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

// ユニットテスト用のメソッド名：Test（テストしたいメソッド名）　	←固定
// 引数：（t *testing.T）, 戻り値なし							 ←固定
func TestSelectArticleDetail(t *testing.T) {
	/*
			expected := models.Article{ //期待値
				ID:       1,
				Title:    "firstPost",
				Contents: "This is my first blog",
				UserName: "saki",
				NiceNum:  3,
			}

		//本物のメソッド呼ぶ
		//got 実行結果 models.Article型
		got, err := repositories.SelectArticleDetail(db, expected.ID)

		if got.ID != expected.ID {
			t.Errorf("Title:get %d but want %d\n", got.ID, expected.ID) //Error：後続処理も行う
		}
		if got.Title != expected.Title {
			t.Errorf("Title:get %s but want %s\n", got.Title, expected.Title) //Error：後続処理も行う
		}
		if got.Contents != expected.Contents {
			t.Errorf("Contents:get %s but want %s\n", got.Contents, expected.Contents) //Error：後続処理も行う
		}
		if got.UserName != expected.UserName {
			t.Errorf("Username:get %s but want %s\n", got.UserName, expected.UserName) //Error：後続処理も行う
		}
		if got.NiceNum != expected.NiceNum {
			t.Errorf("NiceNum:get %d but want %d\n", got.NiceNum, expected.NiceNum) //Error：後続処理も行う
		}
	*/
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
		//サブテスト関数 テスト関数の中にさらに個別のテストを追加
		//go test -v オプションを点けると全てのテストの結果を参照できる
		t.Run(test.testTitle, func(t *testing.T) {
			got, err := repositories.SelectArticleDetail(testDB, test.expected.ID)
			if err != nil {
				t.Fatal(err)
			}

			if got.ID != test.expected.ID {
				t.Errorf("Title:get %d but want %d\n", got.ID, test.expected.ID) //Error：後続処理も行う
			}
			if got.Title != test.expected.Title {
				t.Errorf("Title:get %s but want %s\n", got.Title, test.expected.Title) //Error：後続処理も行う
			}
			if got.Contents != test.expected.Contents {
				t.Errorf("Contents:get %s but want %s\n", got.Contents, test.expected.Contents) //Error：後続処理も行う
			}
			if got.UserName != test.expected.UserName {
				t.Errorf("Username:get %s but want %s\n", got.UserName, test.expected.UserName) //Error：後続処理も行う
			}
			if got.NiceNum != test.expected.NiceNum {
				t.Errorf("NiceNum:get %d but want %d\n", got.NiceNum, test.expected.NiceNum) //Error：後続処理も行う
			}

		})
	}
}

/*このように「go testコマンド一つで、ユニットテストが実行できる」ようにすることで、「テス
トの自動化がやりやすくなる」というメリットがあります。

コードの修正・追加を行うたびに、「その追加したコードが正しく動くかどうか？」以外にも「そ
の作業によって、既存のコードによってできている機能がおかしくなっていないか？」8というこ
とも確かめる必要があります。つまり、テストの実行というのは追加・修正のたびに、頻繁に行
えることが望ましいのです。

そのため、「テストの実行にあまり時間をかけすぎない」「複雑な手順を踏まずにテストができる」
というのは、開発効率を上げるためにはとても重要なのです。実際の開発現場では「GitHubのよ
うなレポジトリにコードをpushするたびにgo testコマンドによるテストが自動で走る」「もし
テストにFAILするようならば、マージできないようにする」といったCI/CDの仕組みを導入す
ることで、テストによる品質担保が自然とできるような体制を整えているところが多いです。

*/

func TestSelectArticleList(t *testing.T) {
	//テスト関数実行
	expectedNum := 3

	got, err := repositories.SelectArticleList(testDB, 1)

	if err != nil {
		t.Fatal(err)
	}

	if num := len(got); num != expectedNum {
		t.Errorf("wanted %d but got %d articles\n", expectedNum, num)
	}
}

func TestUpdateNiceNum(t *testing.T) {
	id := 1

	before, err := repositories.SelectArticleDetail(testDB, id)
	if err != nil {
		t.Fatal("fail to get before data")
	}

	err = repositories.UpdateNiceNum(testDB, id)
	if err != nil {
		t.Error(err)
	}

	after, err := repositories.SelectArticleDetail(testDB, id)
	if err != nil {
		t.Fatal("fail to get after data")
	}

	if after.NiceNum-before.NiceNum != 1 {
		t.Error("fail to update nice num")
	}

	t.Cleanup(func() {
		const sqlStr = `UPDATE articles SET nice=? WHERE article_id= ? ;`

		testDB.Exec(sqlStr, before.NiceNum, id)
	})

}

func TestInsertArticle(t *testing.T) {
	article := models.Article{
		Title:    "insertTest",
		Contents: "testest",
		UserName: "saki",
	}

	expectedArticleNum := 7
	newArticle, err := repositories.InsertArticle(testDB, article)
	if err != nil {
		t.Error(err)
	}

	if newArticle.ID != expectedArticleNum {
		t.Errorf("new article id is expected %d but got %d\n", expectedArticleNum, newArticle.ID)
	}
	//cleanup 各テストケース固有の後処理
	//インサートしたデータを消してDBを元の状態に戻す
	t.Cleanup(func() {
		const sqlStr = `delete from articles where title = ? and contents = ? and username = ?;`

		testDB.Exec(sqlStr, article.Title, article.Contents, article.UserName)
	})

}

/*t.Parallelメソッドによるテストの並行実行というのは、最初からやろうと思ってやるというよりかは、
ユニットテストの数が多くなってきてテストに時間がかかるなとなった段階で後から追加されることが多いポイントです。
その時に追加で余計な作業が生じることがないように、最初からt.Cleanupメソッドによる後処理にしておくのが無難でしょう。*/
