# MONEY_MANAGER セットアップ手順

## 手順
1. `/etc/postfix/sasl_passwd` に自身のGmailのアドレスとアプリパスワードを設定
2. コマンド `sudo postmap /etc/postfix/sasl_passwd` でDBを更新（作成）
3. コマンド `sudo postfix start` を実行
4. MySQLを起動（コマンドやアプリ等で起動）
   LINUX: `sudo service mysql start`など
6. コマンド `mysql -u root -p` を実行し、パスワードを入力して対話型シェルに入る  
7. `source /***/***/init/money_manager.sql` を実行  
   **注意**: `MONEY_MANAGER` より前のパスは自身の環境に合わせて編集してください。またエラー時は再度実行してください。
8. `setting.py` の `FROM` を `/etc/postfix/sasl_passwd` と同じメールアドレスに設定  
   **確認方法**: `cat /etc/postfix/sasl_passwd` を使用
9. `python3 -m venv venv` で仮想環境を作成
10. `source venv/bin/activate` で仮想環境に入る
11. initフォルダに移動し、`pip install -r requirements.txt` で必要なライブラリをインストール
####**Linuxでのmysqlclientインストール中に、MySQLクライアントの開発ファイルが見つからないことでエラーが起きる場合は、`sudo apt-get install python3-dev default-libmysqlclient-dev build-essential`を実行。**
13. `MONEY_MANAGER` のフォルダに入る
14. `python3 main.py` で実行  
    **注意**: ポート80を使用しているため、別アプリが動いている場合は停止してください。

## 補足
- 使用方法に関しては `README_1.png` と `README_2.png` に記載されています。
- ある程度レスポンシブ対応しています。

