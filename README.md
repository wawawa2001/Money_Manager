# MONEY_MANAGER

MONEY_MANAGERは、PythonとMySQLを使用した資産管理システムです。Flaskを利用して構築されており、簡単かつ直感的に資産や収支を管理できます。

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
- **セッション管理**:
  - 安全なログインセッションを提供

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

## 使用イメージ

- 使用方法に関しては以下の画像をご参照ください：
  - `README_1.png`
  - `README_2.png`
- 本アプリはある程度レスポンシブ対応しています。

---

## 使用技術

- **Python 3.9**: 高水準のプログラミング言語
- **Flask 3.0.3**: 軽量なウェブフレームワーク
- **MySQL**: データベース管理システム
- **Chart.js**: インタラクティブなチャート描画ライブラリ
- **bcrypt 4.1.3**: セキュアなパスワードハッシュ化ライブラリ

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
- セッションの有効期限管理

---
