MONEY_MANAGERは、PythonとMySQLを使用した資産管理システムです。Flaskを利用して構築います。

## 主な機能

- **ユーザー認証**:
  - 新規登録、ログイン、ログアウト
  - 仮登録後に確認メールを送信
  - 無効なリンクに対するエラーメッセージ表示
- **データ管理**:
  - 収支情報の登録、変更、削除
  - 資産情報の追加、編集、削除
- **視覚化**:
  - Chart.jsを用いた動的グラフ表示

---

# MONEY_MANAGER セットアップ手順

## 手順

1. **Gmailのアドレスとアプリパスワードの設定**  
   `/etc/postfix/sasl_passwd` に自身のGmailアドレスとアプリパスワードを設定します。

2. **PostfixのDBを更新**  
   以下のコマンドを実行してDBを更新（または作成）します：
   ```bash
   sudo postmap /etc/postfix/sasl_passwd
   ```

3. **Postfixの起動**  
   以下のコマンドでPostfixを起動します：
   ```bash
   sudo postfix start
   ```

4. **MySQLを起動**  
   Linuxの場合、以下のコマンドなどでMySQLを起動します：
   ```bash
   sudo service mysql start
   ```

5. **MySQL対話型シェルに入る**  
   以下のコマンドを実行し、パスワードを入力します：
   ```bash
   mysql -u root -p
   ```

6. **SQLファイルを実行**  
   以下のコマンドで初期設定用SQLファイルを実行します：
   ```sql
   source /***/***/init/money_manager.sql
   ```
   - **注意**: `money_manager.sql` より前のパスは自身の環境に合わせて編集してください。
   - **エラー発生時**: 再度実行してください。

7. **`setting.py` のメールアドレス設定**  
   `setting.py` の `FROM` を `/etc/postfix/sasl_passwd` に記載したメールアドレスと同じに設定します。
   - **確認方法**: 以下のコマンドを実行します。
     ```bash
     cat /etc/postfix/sasl_passwd
     ```

8. **仮想環境を作成・起動**  
   以下のコマンドで仮想環境を作成して起動します：
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

9. **必要なライブラリをインストール**  
   `init` フォルダに移動し、以下のコマンドを実行します：
   ```bash
   pip install -r requirements.txt
   ```
   - **Linuxで`mysqlclient`インストール中のエラー対策**: 以下のコマンドを実行します。
     ```bash
     sudo apt-get install python3-dev default-libmysqlclient-dev build-essential
     ```

10. **`MONEY_MANAGER` フォルダに移動**  
    フォルダに移動して以下のコマンドを実行します：
    ```bash
    python3 main.py
    ```
    - **注意**: ポート80を使用しているため、別アプリが動作している場合は停止するか、別のポートに変更してください。

## 注意事項

- Linux環境で動かす場合、以下の原因により動作しない可能性があります：
  - Postfixの設定ミス
  - ポート未開放
  - OP25Bによる制限
  - 上記の問題が発生した場合、それぞれ対応を行ってください。

### 使用イメージ

#### ユーザ登録画面  
<img width="569" alt="ユーザ登録画面" src="https://github.com/user-attachments/assets/dd840251-9433-4408-90a6-011472a92ca0" />

#### ログイン画面  
<img width="569" alt="ログイン画面" src="https://github.com/user-attachments/assets/ba5e53d8-c381-4762-8e49-718fde87bd3c" />

#### ユーザ登録エラー画面  
<img width="300" alt="ユーザ登録エラー画面" src="https://github.com/user-attachments/assets/09a2af1a-d651-4139-8b9f-5b3ff43629be" />

#### 仮登録メール  
<img width="300" alt="仮登録メール" src="https://github.com/user-attachments/assets/a0386e67-e2b4-44b3-a246-64e27fa3f438" />

#### 登録完了  
<img width="300" alt="登録完了" src="https://github.com/user-attachments/assets/dbefb07e-5d8f-49ee-918d-6aab4b9c00f1" />

#### 登録不可  
<img width="300" alt="登録不可" src="https://github.com/user-attachments/assets/93c0571f-f2c2-4829-babd-c7b80d5ee2b1" />

#### 簡易表示  
<img width="569" alt="簡易表示" src="https://github.com/user-attachments/assets/f6244e16-24ea-4477-9c16-dfacf7dbdf63" />

#### 収支一覧  
<img width="569" alt="収支一覧" src="https://github.com/user-attachments/assets/d54b3e83-45c4-4b8d-9cec-65fa34e52d63" />

#### 資産管理画面  
<img width="569" alt="資産管理画面1" src="https://github.com/user-attachments/assets/e787e780-0501-4819-92d0-86c9ce26ecda" />  

#### データがないときのメッセージ  
<img width="300" alt="資産管理画面2" src="https://github.com/user-attachments/assets/c77b47c2-8f66-4404-9a4c-0e52f6f7a6a1" />



- 本アプリはある程度レスポンシブ対応しています。

---

## 使用技術

- **Python 3.9**
- **Flask 3.0.3**
- **MySQL**
- **Chart.js**
- **bcrypt 4.1.3**

## 動作確認環境

- **PC**: MacBook Air M1 (2020)
- **OS**: macOS Sonoma (v14.5)
- **CPU**: Apple M1 Chip
- **メモリ**: 16GB
- **Pythonバージョン**: 3.9.19

---

## 改善の余地

- 2要素認証の実装
- 資産データの予測機能
- より高度なデータ可視化機能

---
