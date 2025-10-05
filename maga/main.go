package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"

	"github.com/yourname/reponame/handlers"
	/*gorilla/muxパッケージのHTTPルーティングAPIを使う

	このコードを別の場所でも同様に動かすためには、当然依存パッケージであるgorilla/muxも同じものをダウンロー
	ドしてくる必要があります。「確実に同じ依存パッケージを使っているのか」ということを担保するためにチェック
	サムの情報が必要で、これにより「どこで動かしても、同じ動きをさせることができる」ビルド再現性が実現でき
	ます。*/)

func main() {

	r := mux.NewRouter()

	//ログイン処理
	r.HandleFunc("/login", handlers.LoginHandler).Methods(http.MethodPost)

	//ホーム画面での処理
	r.HandleFunc("/index", handlers.IndexHandler).Methods(http.MethodPost)           //ユーザ情報取得
	r.HandleFunc("/index/reserve", handlers.ReserveHundler).Methods(http.MethodPost) //予約情報取得

	//カリキュラム画面での処理
	r.HandleFunc("/skillcheck", handlers.SkillCheckHundler).Methods(http.MethodPost)         //習熟度情報取得
	r.HandleFunc("/skillcheck/update", handlers.SkillUpdateHundler).Methods(http.MethodPost) //習熟度更新

	//ログ出力
	log.Println("server start at port 8080")

	//ListenAndServe=サーバー起動(第一引数はネットワークアドレス)
	//log.Fatal(http.ListenAndServe(":8080", nil))
	log.Fatal(http.ListenAndServe(":8080", r))

}
