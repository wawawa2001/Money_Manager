# MONEY_MANAGER セットアップ手順

## 手順
1. `/etc/postfix/sasl_passwd` に自身のGmailのアドレスとアプリパスワードを設定
2. コマンド `sudo postmap /etc/postfix/sasl_passwd` でDBを更新（作成）
3. コマンド `sudo postfix start` を実行
4. XAMPPでMySQLを起動（またはコマンドで起動）
5. コマンド `mysql -u root -p` を実行し、パスワードを入力して対話型シェルに入る  
   **注意**: `mysql -u root -p` が動かない場合、以下を試してください:  
   `/Applications/XAMPP/xamppfiles/bin/mysql -u root -p`
6. `source /***/***/init/money_manager.sql` を実行  
   **注意**: `MONEY_MANAGER` より前のパスは自身の環境に合わせて編集してください。またエラー時は再度実行してください。
7. `setting.py` の `FROM` を `/etc/postfix/sasl_passwd` と同じメールアドレスに設定  
   **確認方法**: `cat /etc/postfix/sasl_passwd` を使用
8. `python3 -m venv venv` で仮想環境を作成
9. `source venv/bin/activate` で仮想環境に入る
10. `pip install -r requirements.txt` で必要なライブラリをインストール
11. `MONEY_MANAGER` のフォルダに入る
12. `python3 main.py` で実行  
    **注意**: ポート80を使用しているため、別アプリが動いている場合は停止してください。

## 補足
- 使用方法に関しては `README_1.png` と `README_2.png` に記載されています。
- ある程度レスポンシブ対応しています。

# MoneyManager
# MoneyManager
# Money_Manager
