import pandas as pd
import sys

sys.path.append("/usr/local/lib/python3.9/site-packages")
import mysql.connector

# CSVファイルの読み込み
csv_file = 'sql.csv'
df = pd.read_csv(csv_file)

# データベース接続情報
db_config = {
    'host': '',
    'user': 'money_manager',
    'password': '',
    'database': 'money_manager',
    'charset': 'utf8mb4',
    'port': '3306',
}
# データベース接続
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()


# データの挿入
insert_query = """
INSERT INTO Transaction (UserID, Amount, Date, CategoryID, Description, EntryType) 
VALUES (%s, %s, %s, %s, %s, %s)
"""

for index, row in df.iterrows():
    cursor.execute(insert_query, (row['ユーザID'], row['金額'], row['日付'], row['カテゴリーID'], row['詳細'], row['EntryType']))

# コミットして接続を閉じる
connection.commit()
cursor.close()
connection.close()

print("データが正常に挿入されました。")
