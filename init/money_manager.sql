-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- ホスト: localhost
-- 生成日時: 2024 年 7 月 22 日 11:19
-- サーバのバージョン： 10.4.28-MariaDB
-- PHP のバージョン: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- データベース: `money_manager`
--

-- --------------------------------------------------------

--
-- テーブルの構造 `Assets`
--

CREATE DATABASE money_manager;

USE money_manager;

CREATE TABLE `Assets` (
  `ID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `Categories`
--

CREATE TABLE `Categories` (
  `CategoryID` int(11) NOT NULL,
  `CategoryName` varchar(100) NOT NULL,
  `CategoryType` enum('Income','Expense') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- テーブルのデータのダンプ `Categories`
--

INSERT INTO `Categories` (`CategoryID`, `CategoryName`, `CategoryType`) VALUES
(1, '給与', 'Income'),
(2, '副収入', 'Income'),
(3, 'その他収入', 'Income'),
(4, '家賃・住宅', 'Expense'),
(5, '公共料金', 'Expense'),
(6, '食費', 'Expense'),
(7, '交通費', 'Expense'),
(8, '医療費', 'Expense'),
(9, '保険', 'Expense'),
(10, '娯楽', 'Expense'),
(11, 'その他支出', 'Expense'),
(12, '学費', 'Expense'),
(13, '定期支払い', 'Expense'),
(14, 'クレジット系', 'Expense'),
(15, '返済', 'Expense');

-- --------------------------------------------------------

--
-- テーブルの構造 `Provisional_Users`
--

CREATE TABLE `Provisional_Users` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `PasswordHash` varchar(255) NOT NULL,
  `Token` varchar(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `Sessions`
--

CREATE TABLE `Sessions` (
  `SessionID` varchar(255) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `SessionKey` varchar(255) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `Transaction`
--

CREATE TABLE `Transaction` (
  `EntryID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Amount` int(10) NOT NULL,
  `Date` date NOT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `EntryType` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `Users`
--

CREATE TABLE `Users` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `CreatedDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `MemberStatus` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- ダンプしたテーブルのインデックス
--

--
-- テーブルのインデックス `Assets`
--
ALTER TABLE `Assets`
  ADD PRIMARY KEY (`ID`);

--
-- テーブルのインデックス `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`CategoryID`);

--
-- テーブルのインデックス `Provisional_Users`
--
ALTER TABLE `Provisional_Users`
  ADD PRIMARY KEY (`UserID`);

--
-- テーブルのインデックス `Sessions`
--
ALTER TABLE `Sessions`
  ADD PRIMARY KEY (`SessionID`),
  ADD KEY `UserID` (`UserID`);

--
-- テーブルのインデックス `Transaction`
--
ALTER TABLE `Transaction`
  ADD PRIMARY KEY (`EntryID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- テーブルのインデックス `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `UserName` (`UserName`);

--
-- ダンプしたテーブルの AUTO_INCREMENT
--

--
-- テーブルの AUTO_INCREMENT `Assets`
--
ALTER TABLE `Assets`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- テーブルの AUTO_INCREMENT `Categories`
--
ALTER TABLE `Categories`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- テーブルの AUTO_INCREMENT `Provisional_Users`
--
ALTER TABLE `Provisional_Users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT;

--
-- テーブルの AUTO_INCREMENT `Transaction`
--
ALTER TABLE `Transaction`
  MODIFY `EntryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- テーブルの AUTO_INCREMENT `Users`
--
ALTER TABLE `Users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT;

--
-- ダンプしたテーブルの制約
--

--
-- テーブルの制約 `Sessions`
--
ALTER TABLE `Sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`);

--
-- テーブルの制約 `Transaction`
--
ALTER TABLE `Transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`),
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

CREATE USER 'money_manager_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON money_manager.* TO 'money_manager_user'@'localhost';
FLUSH PRIVILEGES;

/* テストデータ */

INSERT INTO `Users` (`UserID`, `UserName`, `Email`, `PasswordHash`) VALUES(999, 'TestUser999', 'TestUser999@example.com', '$2b$12$Hz66nIUc5.B18.jEnFwGdubxKJ9.dfjq2.ntGWc8LwhcokuMFtaQe');

INSERT INTO `Assets` (`UserID`, `Name`, `Value`) VALUES (999, '銀行', 100000), (999, '手持ち', 15000), (999, 'PayPay', 5000);

INSERT INTO `Transaction` (`EntryID`, `UserID`, `Amount`, `Date`, `CategoryID`, `Description`, `EntryType`) VALUES
(1, 999, 15000, '2024-08-15', 15, 'ローン返済', 1),
(2, 999, 5000, '2024-08-16', 8, '病院費用', 1),
(3, 999, 10000, '2024-08-21', 5, '電気代', 1),
(4, 999, 9000, '2024-08-22', 5, '電気代', 1),
(5, 999, 4000, '2024-08-26', 10, '映画代', 1),
(6, 999, 9000, '2024-08-29', 4, '家賃', 1),
(7, 999, 9000, '2024-09-03', 7, '交通費', 1),
(8, 999, 5000, '2024-09-07', 10, '映画代', 1),
(9, 999, 4000, '2024-09-11', 8, '病院費用', 1),
(10, 999, 276000, '2024-09-13', 1, '給与', 0),
(11, 999, 5000, '2024-09-18', 13, 'サブスクリプション', 1),
(12, 999, 4000, '2024-09-23', 11, '雑費', 1),
(13, 999, 31000, '2024-09-24', 6, '食料品', 1),
(14, 999, 52000, '2024-09-26', 2, '副収入', 0),
(15, 999, 4000, '2024-09-27', 13, 'サブスクリプション', 1),
(16, 999, 15000, '2024-10-02', 15, 'ローン返済', 1),
(17, 999, 51000, '2024-10-03', 3, 'その他収入', 0),
(18, 999, 5000, '2024-10-06', 11, '雑費', 1),
(19, 999, 9000, '2024-10-09', 5, '電気代', 1),
(20, 999, 4000, '2024-10-13', 10, '映画代', 1),
(21, 999, 5000, '2024-10-17', 10, '映画代', 1),
(22, 999, 29000, '2024-10-21', 12, '授業料', 1),
(23, 999, 10000, '2024-10-22', 5, '電気代', 1),
(24, 999, 5000, '2024-10-24', 11, '雑費', 1),
(25, 999, 14000, '2024-10-28', 15, 'ローン返済', 1),
(26, 999, 6000, '2024-10-29', 9, '保険料', 1),
(27, 999, 27000, '2024-10-31', 6, '食料品', 1),
(28, 999, 50000, '2024-11-05', 3, 'その他収入', 0),
(29, 999, 322000, '2024-11-08', 1, '給与', 0),
(30, 999, 9000, '2024-11-10', 5, '電気代', 1),
(31, 999, 5000, '2024-11-15', 10, '映画代', 1),
(32, 999, 48000, '2024-11-18', 3, 'その他収入', 0),
(33, 999, 288000, '2024-11-22', 1, '給与', 0),
(34, 999, 6000, '2024-11-27', 9, '保険料', 1),
(35, 999, 9000, '2024-12-02', 4, '家賃', 1),
(36, 999, 51000, '2024-12-04', 3, 'その他収入', 0),
(37, 999, 32000, '2024-12-06', 6, '食料品', 1),
(38, 999, 45000, '2024-12-10', 3, 'その他収入', 0),
(39, 999, 275000, '2024-12-14', 1, '給与', 0),
(40, 999, 14000, '2024-12-19', 15, 'ローン返済', 1),
(41, 999, 7000, '2024-12-20', 9, '保険料', 1),
(42, 999, 4000, '2024-12-25', 13, 'サブスクリプション', 1),
(43, 999, 30000, '2024-12-28', 12, '授業料', 1),
(44, 999, 10000, '2025-01-01', 4, '家賃', 1),
(45, 999, 5000, '2025-01-05', 13, 'サブスクリプション', 1),
(46, 999, 9000, '2025-01-10', 5, '電気代', 1),
(47, 999, 20000, '2025-01-14', 14, 'クレジット支払い', 1),
(48, 999, 4000, '2025-01-16', 8, '病院費用', 1),
(49, 999, 14000, '2025-01-18', 15, 'ローン返済', 1),
(50, 999, 45000, '2025-01-20', 3, 'その他収入', 0),
(51, 999, 5000, '2025-01-22', 10, '映画代', 1),
(52, 999, 4000, '2025-01-23', 8, '病院費用', 1),
(53, 999, 27000, '2025-01-24', 6, '食料品', 1),
(54, 999, 5000, '2025-01-27', 8, '病院費用', 1),
(55, 999, 7000, '2025-01-30', 9, '保険料', 1),
(56, 999, 326000, '2025-01-31', 1, '給与', 0),
(57, 999, 5000, '2025-02-03', 11, '雑費', 1),
(58, 999, 10000, '2025-02-05', 7, '交通費', 1),
(59, 999, 9000, '2025-02-08', 4, '家賃', 1),
(60, 999, 5000, '2025-02-10', 11, '雑費', 1),
(61, 999, 6000, '2025-02-11', 9, '保険料', 1),
(62, 999, 5000, '2025-02-14', 13, 'サブスクリプション', 1),
(63, 999, 30000, '2025-02-18', 12, '授業料', 1),
(64, 999, 10000, '2025-02-20', 5, '電気代', 1),
(65, 999, 21000, '2025-02-22', 14, 'クレジット支払い', 1),
(66, 999, 18000, '2025-02-23', 14, 'クレジット支払い', 1),
(67, 999, 13000, '2025-02-24', 15, 'ローン返済', 1),
(68, 999, 32000, '2025-02-27', 12, '授業料', 1),
(69, 999, 300000, '2025-02-28', 1, '給与', 0),
(70, 999, 9000, '2025-03-03', 5, '電気代', 1),
(71, 999, 30000, '2025-03-08', 12, '授業料', 1),
(72, 999, 4000, '2025-03-11', 8, '病院費用', 1),
(73, 999, 51000, '2025-03-14', 3, 'その他収入', 0),
(74, 999, 19000, '2025-03-16', 14, 'クレジット支払い', 1),
(75, 999, 21000, '2025-03-21', 14, 'クレジット支払い', 1),
(76, 999, 14000, '2025-03-22', 15, 'ローン返済', 1),
(77, 999, 7000, '2025-03-27', 9, '保険料', 1),
(78, 999, 48000, '2025-03-28', 2, '副収入', 0),
(79, 999, 28000, '2025-03-31', 12, '授業料', 1),
(80, 999, 9000, '2025-04-01', 4, '家賃', 1),
(81, 999, 9000, '2025-04-05', 7, '交通費', 1),
(82, 999, 27000, '2025-04-08', 6, '食料品', 1),
(83, 999, 9000, '2025-04-10', 4, '家賃', 1),
(84, 999, 10000, '2025-04-13', 7, '交通費', 1),
(85, 999, 29000, '2025-04-14', 12, '授業料', 1),
(86, 999, 50000, '2025-04-17', 2, '副収入', 0),
(87, 999, 5000, '2025-04-19', 11, '雑費', 1),
(88, 999, 13000, '2025-04-20', 15, 'ローン返済', 1),
(89, 999, 10000, '2025-04-21', 4, '家賃', 1),
(90, 999, 13000, '2025-04-22', 15, 'ローン返済', 1),
(91, 999, 7000, '2025-04-24', 9, '保険料', 1),
(92, 999, 10000, '2025-04-29', 5, '電気代', 1),
(93, 999, 4000, '2025-05-04', 10, '映画代', 1),
(94, 999, 4000, '2025-05-06', 8, '病院費用', 1),
(95, 999, 5000, '2025-05-07', 11, '雑費', 1),
(96, 999, 5000, '2025-05-10', 13, 'サブスクリプション', 1),
(97, 999, 5000, '2025-05-13', 11, '雑費', 1),
(98, 999, 9000, '2025-05-17', 7, '交通費', 1),
(99, 999, 5000, '2025-05-21', 10, '映画代', 1),
(100, 999, 30000, '2025-05-24', 12, '授業料', 1);