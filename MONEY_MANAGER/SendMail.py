import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from settings import FROM

class SendMail:
    def __init__(self, smtp_server='localhost'):
        self.smtp_server = smtp_server
        self.sender_email = FROM
    
    def send_email(self, receiver_email, subject, body):
        # MIME形式のメッセージを作成
        msg = MIMEMultipart()
        msg['From'] = self.sender_email
        msg['To'] = receiver_email
        msg['Subject'] = subject

        # メール本文を添付
        msg.attach(MIMEText(body, 'plain'))

        # SMTPサーバーに接続してメールを送信
        try:
            server = smtplib.SMTP(self.smtp_server)  # POSTFIXはローカルホストで動作しているはず
            server.sendmail(self.sender_email, receiver_email, msg.as_string())
            print("Email sent successfully!")
        except Exception as e:
            print(f"Failed to send email: {e}")
        finally:
            server.quit()
