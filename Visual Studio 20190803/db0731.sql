USE [master]
GO
/****** Object:  Database [WiseMachine]    Script Date: 2019/7/31 上午 11:14:48 ******/
CREATE DATABASE [WiseMachine]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WiseMachine', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\WiseMachine.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WiseMachine_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\WiseMachine_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [WiseMachine] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WiseMachine].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WiseMachine] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WiseMachine] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WiseMachine] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WiseMachine] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WiseMachine] SET ARITHABORT OFF 
GO
ALTER DATABASE [WiseMachine] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WiseMachine] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WiseMachine] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WiseMachine] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WiseMachine] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WiseMachine] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WiseMachine] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WiseMachine] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WiseMachine] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WiseMachine] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WiseMachine] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WiseMachine] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WiseMachine] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WiseMachine] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WiseMachine] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WiseMachine] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WiseMachine] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WiseMachine] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WiseMachine] SET  MULTI_USER 
GO
ALTER DATABASE [WiseMachine] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WiseMachine] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WiseMachine] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WiseMachine] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WiseMachine] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WiseMachine] SET QUERY_STORE = OFF
GO
USE [WiseMachine]
GO
/****** Object:  Table [dbo].[ItemDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemDb](
	[ItemId] [int] NOT NULL,
	[ItemImg] [nvarchar](200) NULL,
	[ItemName] [nvarchar](50) NULL,
	[ItemUnitPrice] [int] NULL,
	[Class] [nvarchar](10) NULL,
	[Calorles] [nvarchar](50) NULL,
	[Protein] [nvarchar](50) NULL,
	[Carbohydrate] [nvarchar](50) NULL,
	[Fat] [nvarchar](50) NULL,
	[Sugars] [nvarchar](50) NULL,
	[Sodium] [nvarchar](50) NULL,
	[Capacity] [nvarchar](5) NULL,
	[Slogan1] [nvarchar](10) NULL,
	[Slogan2] [nvarchar](10) NULL,
	[PayUrl] [nvarchar](200) NULL,
	[ImgUrl] [nvarchar](50) NULL,
 CONSTRAINT [PK_ItemDb] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalesStatisticsDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesStatisticsDb](
	[SerialNumber] [int] IDENTITY(1,1) NOT NULL,
	[MachineId] [varchar](50) NULL,
	[ItemId] [int] NULL,
	[UpdateTime] [varchar](50) NULL,
	[TransactionID] [varchar](100) NULL,
 CONSTRAINT [PK_SalesStatisticsDb] PRIMARY KEY CLUSTERED 
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[salesstatus]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[salesstatus] as
select MachineId '機臺編號', i.ItemName '商品名稱' , count(s.ItemId) '數量'
from SalesStatisticsDb s
join(select * from ItemDb)as i on i.ItemId = s.ItemId
group by i.ItemName,MachineId
GO
/****** Object:  Table [dbo].[MachineStorageDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MachineStorageDb](
	[SerialNumber] [int] IDENTITY(1,1) NOT NULL,
	[MachineId] [varchar](50) NULL,
	[EmployeeId] [varchar](50) NULL,
	[ItemId] [int] NULL,
	[Rack] [varchar](50) NULL,
	[Amount] [varchar](50) NULL,
	[UpdateTime] [varchar](50) NULL,
 CONSTRAINT [PK_MacInvDb] PRIMARY KEY CLUSTERED 
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpDb](
	[Account] [varchar](50) NOT NULL,
	[PassWord] [nvarchar](50) NULL,
	[EmployeeID] [varchar](50) NOT NULL,
	[EmployeeName] [nvarchar](50) NULL,
	[PhoneNum] [nchar](15) NULL,
	[Sex] [char](4) NULL,
	[Email] [varchar](200) NULL,
	[Address] [nvarchar](200) NULL,
	[Birthday] [nvarchar](20) NULL,
	[AddDate] [nvarchar](20) NULL,
	[UpdateTime] [nvarchar](20) NULL,
	[Assignment] [int] NULL,
	[MachineId] [varchar](50) NULL,
	[Permission] [int] NULL,
 CONSTRAINT [PK_EmpDb] PRIMARY KEY CLUSTERED 
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MachineStorageView]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[MachineStorageView] as
SELECT ISNULL(CAST((row_number() OVER (ORDER BY cast(ms.rack as int))) AS int), 0) AS ID, ms.MachineId, right('0'+ms.Rack,2) 'Rack', i.ItemName, ms.Amount, e.EmployeeName, ms.UpdateTime
FROM dbo.EmpDb AS e RIGHT OUTER JOIN dbo.MachineStorageDb AS ms ON e.EmployeeID = ms.EmployeeId LEFT OUTER JOIN
dbo.ItemDb AS i ON i.ItemId = ms.ItemId
GO
/****** Object:  Table [dbo].[WareHouseStorageDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WareHouseStorageDb](
	[SerialNumber] [int] IDENTITY(1,1) NOT NULL,
	[WareHouseId] [varchar](50) NULL,
	[EmployeeId] [varchar](50) NULL,
	[ItemId] [int] NULL,
	[Rack] [varchar](50) NULL,
	[Amount] [varchar](50) NULL,
	[UpdateTime] [varchar](50) NULL,
 CONSTRAINT [PK_WareHouseStorageDb] PRIMARY KEY CLUSTERED 
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WareHouseStorageView]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[WareHouseStorageView] as
select ISNULL(CAST((row_number() OVER (ORDER BY cast(w.rack AS int))) AS int), 0) AS ID, w.WareHouseId, w.Rack, i.ItemName, w.Amount
	, e.EmployeeName, w.UpdateTime
from ItemDb i right join WareHouseStorageDb w on i.ItemId = w.ItemId left join
	 EmpDb e on w.EmployeeId = e.EmployeeID
GO
/****** Object:  View [dbo].[api2019]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[api2019] as
SELECT  ppp,
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='01'),0) as 'JAN',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='02'),0) as 'FEB',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='03'),0) as 'MAR',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='04'),0) as 'APR',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='05'),0) as 'MAY',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='06'),0) as 'JUN',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='07'),0) as 'JUL',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='08'),0) as 'AUG',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='09'),0) as 'SEP',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='10'),0) as 'OCT',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE itemid = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='11'),0) as 'NOV',
ISNULL((SELECT count(itemid) FROM SalesStatisticsDb WHERE ItemId = itemid AND ppp=SUBSTRING(UpdateTime,0,5) AND substring(updatetime,6,2)='12'),0) as 'DEC'
FROM (
SELECT  SUBSTRING(UpdateTime,0,5) AS ppp FROM SalesStatisticsDb
GROUP BY SUBSTRING(UpdateTime,0,5)) x
GO
/****** Object:  View [dbo].[yymmapi]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[yymmapi] as

SELECT           ISNULL(NULL, 1) AS ID, CID = ROW_NUMBER() OVER (ORDER BY ItemName
                             DESC), dbo.ItemDb.ItemName, COUNT(dbo.ItemDb.ItemName) AS quantitu
FROM              dbo.ItemDb RIGHT OUTER JOIN
                            dbo.SalesStatisticsDb ON dbo.ItemDb.ItemId = dbo.SalesStatisticsDb.ItemId
WHERE          substring(updatetime, 6, 2) = '07'
GROUP BY   dbo.ItemDb.ItemName
GO
/****** Object:  View [dbo].[sevenapi]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[sevenapi] as

SELECT          ISNULL(NULL, 1) AS ID, CID = ROW_NUMBER() OVER (ORDER BY ItemName
                             DESC), dbo.ItemDb.ItemName, COUNT(dbo.ItemDb.ItemName) AS quantitu
FROM              dbo.ItemDb RIGHT OUTER JOIN
                            dbo.SalesStatisticsDb ON dbo.ItemDb.ItemId = dbo.SalesStatisticsDb.ItemId
WHERE          substring(updatetime, 6, 2) = '07' AND DATEDIFF(dd, CONVERT(date, trim(UpdateTime), 121), getdatE()) <= 7
GROUP BY   dbo.ItemDb.ItemName
GO
/****** Object:  Table [dbo].[MachineDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MachineDb](
	[MachineId] [varchar](50) NOT NULL,
	[Location] [nvarchar](200) NULL,
	[AddDate] [varchar](50) NULL,
 CONSTRAINT [PK_MachineDb] PRIMARY KEY CLUSTERED 
(
	[MachineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WareHouseDb]    Script Date: 2019/7/31 上午 11:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WareHouseDb](
	[WareHouseId] [int] NOT NULL,
	[Location] [nvarchar](200) NULL,
	[AddDate] [varchar](50) NULL,
 CONSTRAINT [PK_WarehouseDb] PRIMARY KEY CLUSTERED 
(
	[WareHouseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[EmpDb] ([Account], [PassWord], [EmployeeID], [EmployeeName], [PhoneNum], [Sex], [Email], [Address], [Birthday], [AddDate], [UpdateTime], [Assignment], [MachineId], [Permission]) VALUES (N'asd', N'123', N'3', N'金小子', N'0912312311     ', N'M   ', N'222@aaaa.xxx', N'台中市梧棲區', N'2019/08/14', N'2019/07/29', N'2019/07/31', 1, N'0', 0)
INSERT [dbo].[EmpDb] ([Account], [PassWord], [EmployeeID], [EmployeeName], [PhoneNum], [Sex], [Email], [Address], [Birthday], [AddDate], [UpdateTime], [Assignment], [MachineId], [Permission]) VALUES (N'qwe', N'123', N'2', N'王小明', N'0921111111     ', N'M   ', N'5555@aaa.aaa', N'台中沙鹿區', N'1822/02/25', N'2019/07/11', N'2019/07/31', 1, N'1', 0)
INSERT [dbo].[EmpDb] ([Account], [PassWord], [EmployeeID], [EmployeeName], [PhoneNum], [Sex], [Email], [Address], [Birthday], [AddDate], [UpdateTime], [Assignment], [MachineId], [Permission]) VALUES (N'qwer', N'1234', N'4', N'李阿明', N'232345         ', N'F   ', N'asd@sad.23', N'台北市信義區', N'2019/08/14', N'2019/07/29', N'2019/07/31', 0, N'0', 0)
INSERT [dbo].[EmpDb] ([Account], [PassWord], [EmployeeID], [EmployeeName], [PhoneNum], [Sex], [Email], [Address], [Birthday], [AddDate], [UpdateTime], [Assignment], [MachineId], [Permission]) VALUES (N'test', N'1234', N'1', N'陳韋達', N'0973771412     ', N'M   ', N'12312@yahoo.com.tw', N'台中北屯區', N'1984/01/11', N'2018/07/10', N'2019/07/28', 0, N'0', 1)
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (1, N'item5.png', N'測試飲料A', 25, N'飲料', N'1', N'1', N'1', N'1', N'1', N'1', N'1', N'熱賣商品', N'TOP1', NULL, N'https://thumbs2.imgbox.com/df/96/VanJRiVe_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (2, N'item6.png', N'測試飲料B', 25, N'飲料', N'2', N'2', N'2', N'2', N'2', N'2', N'2', N'熱賣商品', N'TOP4', NULL, N'https://thumbs2.imgbox.com/0d/14/rGIBsSqi_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (3, N'item7.png', N'測試飲料C', 25, N'飲料', N'3', N'3', N'3', N'3', N'3', N'3', N'3', N'季節限定', N'6/15~8/1', NULL, N'https://thumbs2.imgbox.com/76/51/PpZSu6s5_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (4, N'item8.png', N'測試飲料D', 25, N'飲料', N'4', N'4', N'4', N'4', N'4', N'4', N'4', N'新品上市', N'快來嘗鮮', NULL, N'https://thumbs2.imgbox.com/8b/2c/FvLXvYXy_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (5, N'item9.png', N'測試飲料E', 25, N'飲料', N'5', N'5', N'5', N'5', N'5', N'5', N'5', N'新品上市', N'快來嘗鮮', NULL, N'https://thumbs2.imgbox.com/a4/8e/HijlfuBl_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (6, N'item10.png', N'測試飲料F', 25, N'飲料', N'6', N'6', N'6', N'6', N'6', N'6', N'6', N'季節限定', N'6/15~8/1', NULL, N'https://thumbs2.imgbox.com/a4/8e/HijlfuBl_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (7, N'item11.png', N'測試飲料G', 25, N'飲料', N'7', N'7', N'7', N'7', N'7', N'7', N'7', N'新品上市', N'快來嘗鮮', NULL, N'https://thumbs2.imgbox.com/da/4a/SnTSrOhN_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (8, N'item12.png', N'測試飲料H', 25, N'飲料', N'8', N'8', N'8', N'8', N'8', N'8', N'8', N'季節限定', N'6/15~8/1', NULL, N'https://thumbs2.imgbox.com/97/09/OHszaKqL_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (9, N'item1.png', N'測試餅乾A', 25, N'餅乾', N'9', N'9', N'9', N'9', N'9', N'9', N'9', N'季節限定', N'6/15~8/1', NULL, N'https://thumbs2.imgbox.com/96/68/qHcPMtjs_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (10, N'item2.png', N'測試餅乾B', 25, N'餅乾', N'10', N'10', N'10', N'10', N'10', N'10', N'10', N'熱賣商品', N'TOP2', NULL, N'https://thumbs2.imgbox.com/0c/94/8U9YA3Hk_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (11, N'item3.png', N'測試餅乾C', 25, N'餅乾', N'11', N'11', N'11', N'11', N'11', N'11', N'11', N'新品上市', N'快來嘗鮮', NULL, N'https://thumbs2.imgbox.com/90/b3/KFRIb8Xa_t.jpg')
INSERT [dbo].[ItemDb] ([ItemId], [ItemImg], [ItemName], [ItemUnitPrice], [Class], [Calorles], [Protein], [Carbohydrate], [Fat], [Sugars], [Sodium], [Capacity], [Slogan1], [Slogan2], [PayUrl], [ImgUrl]) VALUES (12, N'item4.png', N'測試餅乾D', 25, N'餅乾', N'12', N'12', N'12', N'12', N'12', N'12', N'12', N'熱賣商品', N'TOP3', NULL, N'https://thumbs2.imgbox.com/10/50/7mdl2Gdi_t.jpg')
INSERT [dbo].[MachineDb] ([MachineId], [Location], [AddDate]) VALUES (N'1', N'測試地點', N'2019-07-10')
INSERT [dbo].[MachineDb] ([MachineId], [Location], [AddDate]) VALUES (N'2', N'測試地點2', N'2019-07-10')
SET IDENTITY_INSERT [dbo].[MachineStorageDb] ON 

INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (1, N'1', N'2', 1, N'1', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (2, N'1', N'1', 2, N'2', N'4', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (3, N'1', N'1', 3, N'3', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (4, N'1', N'1', 5, N'4', N'2', N'2019/07/31')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (5, N'1', N'2', 7, N'5', N'4', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (6, N'1', N'1', 4, N'6', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (7, N'1', N'1', 8, N'7', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (8, N'1', N'1', 9, N'8', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (9, N'1', N'1', 10, N'9', N'5', N'2019/07/29')
INSERT [dbo].[MachineStorageDb] ([SerialNumber], [MachineId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (10, N'1', N'1', 6, N'10', N'5', N'2019/07/29')
SET IDENTITY_INSERT [dbo].[MachineStorageDb] OFF
SET IDENTITY_INSERT [dbo].[SalesStatisticsDb] ON 

INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1, N'1', 1, N'2019/07/10', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (2, N'1', 3, N'2019/07/11', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (3, N'1', 4, N'2019/07/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (4, N'1', 1, N'2019/07/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (5, N'1', 9, N'2019/7/30', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (6, N'1', 9, N'2019/7/30', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (7, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (8, N'1', 16, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (9, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (10, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (11, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (12, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (13, N'1', 14, N'2019/07/28 ', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (14, N'1', 8, N'2019/07/14', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (15, N'1', 9, N'2019/07/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (16, N'1', 9, N'2019/07/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (17, N'1', 9, N'2019/07/14', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (18, N'1', 9, N'2019/07/15', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (19, N'1', 8, N'2019/07/16', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (20, N'1', 7, N'2019/07/27', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (21, N'1', 7, N'2019/07/26', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (22, N'1', 7, N'2019/07/25', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (23, N'1', 6, N'2019/07/22', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (24, N'1', 6, N'2019/07/14', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (25, N'1', 6, N'2019/07/09', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (26, N'1', 6, N'2019/07/01', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (27, N'1', 4, N'2019/07/01', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (28, N'1', 4, N'2019/07/03', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (29, N'1', 5, N'2019/07/05', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (30, N'1', 5, N'2019/07/02', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (31, N'1', 5, N'2019/07/02', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (32, N'1', 15, N'2019/07/08', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (33, N'1', 13, N'2019/07/07', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (34, N'1', 12, N'2019/07/07', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (35, N'1', 4, N'2019/06/04', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (36, N'1', 1, N'2019/06/19', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (37, N'1', 4, N'2019/06/23', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (38, N'1', 4, N'2019/06/28', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (39, N'1', 9, N'2019/06/24', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (40, N'1', 9, N'2019/06/24', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (41, N'1', 9, N'2019/06/25', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (42, N'1', 7, N'2019/06/26', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (43, N'1', 8, N'2019/06/28', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (44, N'1', 4, N'2019/06/04', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (45, N'1', 5, N'2019/06/06', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (46, N'1', 5, N'2019/06/08', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (47, N'1', 4, N'2019/06/09', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (48, N'1', 7, N'2019/06/07', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1001, N'1', 7, N'2019/01/25', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1002, N'1', 15, N'2019/01/23', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1003, N'1', 8, N'2019/01/04', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1004, N'1', 9, N'2019/01/14', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1005, N'1', 9, N'2019/02/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1006, N'1', 9, N'2019/02/14', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1007, N'1', 9, N'2019/02/03', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1008, N'1', 9, N'2019/03/16', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1009, N'1', 9, N'2019/03/19', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1010, N'1', 9, N'2019/03/17', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1011, N'1', 9, N'2019/04/05', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1012, N'1', 9, N'2019/04/13', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1013, N'1', 9, N'2019/04/22', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1014, N'1', 9, N'2019/05/16', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1015, N'1', 9, N'2019/05/17', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1016, N'1', 9, N'2019/06/29', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1017, N'1', 9, N'2019/06/07', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1018, N'1', 9, N'2019/06/02', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1019, N'1', 9, N'2019/08/08', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1020, N'1', 9, N'2019/08/16', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1021, N'1', 9, N'2019/08/01', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1022, N'1', 9, N'2019/08/16', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1023, N'1', 14, N'2019/09/05', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1024, N'1', 14, N'2019/09/04', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1025, N'1', 14, N'2019/09/08', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1026, N'1', 14, N'2019/09/07', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1027, N'1', 14, N'2019/10/17', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1028, N'1', 14, N'2019/10/17', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1029, N'1', 14, N'2019/10/10', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1030, N'1', 14, N'2019/11/01', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1031, N'1', 14, N'2019/11/06', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1032, N'1', 14, N'2019/11/18', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1033, N'1', 14, N'2019/12/30', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1034, N'1', 14, N'2019/12/05', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1035, N'1', 14, N'2019/12/06', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1036, N'1', 14, N'2019/12/18', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1037, N'1', 14, N'2019/07/23', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1038, N'1', 3, N'2019/7/31 上午 11:03:04', NULL)
INSERT [dbo].[SalesStatisticsDb] ([SerialNumber], [MachineId], [ItemId], [UpdateTime], [TransactionID]) VALUES (1039, N'1', 9, N'2019/7/31 上午 11:12:44', NULL)
SET IDENTITY_INSERT [dbo].[SalesStatisticsDb] OFF
INSERT [dbo].[WareHouseDb] ([WareHouseId], [Location], [AddDate]) VALUES (1, N'台中市清水區', N'2019/07/31')
SET IDENTITY_INSERT [dbo].[WareHouseStorageDb] ON 

INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (1, N'1', N'1', 1, N'1', N'6', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (2, N'1', N'1', 2, N'2', N'6', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (3, N'1', N'1', 3, N'3', N'6', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (4, N'1', N'2', 4, N'4', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (5, N'1', N'2', 5, N'5', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (6, N'1', N'2', 6, N'6', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (7, N'1', N'2', 7, N'7', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (8, N'1', N'2', 8, N'8', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (9, N'1', N'2', 9, N'9', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (10, N'1', N'2', 10, N'10', N'7', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (11, N'1', N'2', 11, N'11', N'5', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (12, N'1', N'1', 12, N'12', N'7', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (13, N'1', N'3', 13, N'13', N'7', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (14, N'1', N'1', 14, N'14', N'8', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (15, N'1', N'1', 15, N'15', N'6', N'2019/07/29')
INSERT [dbo].[WareHouseStorageDb] ([SerialNumber], [WareHouseId], [EmployeeId], [ItemId], [Rack], [Amount], [UpdateTime]) VALUES (16, N'1', N'5', 16, N'16', N'5', N'2019/07/30')
SET IDENTITY_INSERT [dbo].[WareHouseStorageDb] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工帳號 唯一值' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Account'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工編號 遞增' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'EmployeeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'EmployeeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工手機號碼(格式：0900000000)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'PhoneNum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'男M /女F' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Sex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'出生日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Birthday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'資料建立日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'AddDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'資料更新日期時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'UpdateTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'權限' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EmpDb', @level2type=N'COLUMN',@level2name=N'Permission'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品序號 遞增' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'ItemId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品圖片位置' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'ItemImg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'ItemName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品單價' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'ItemUnitPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品類別' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Class'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g卡路里 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Calorles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g蛋白質' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Protein'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g碳水化合物' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Carbohydrate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g脂肪' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Fat'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g糖份' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Sugars'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'每100g鈉' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemDb', @level2type=N'COLUMN',@level2name=N'Sodium'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'機台編號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineDb', @level2type=N'COLUMN',@level2name=N'MachineId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'機台位置 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineDb', @level2type=N'COLUMN',@level2name=N'Location'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'資料建立日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineDb', @level2type=N'COLUMN',@level2name=N'AddDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'資料編號 遞增' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineStorageDb', @level2type=N'COLUMN',@level2name=N'SerialNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'機台編號 from MachineDb' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineStorageDb', @level2type=N'COLUMN',@level2name=N'MachineId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'員工帳號 from EmpDb' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineStorageDb', @level2type=N'COLUMN',@level2name=N'EmployeeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品序號 from WarehouseDb' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineStorageDb', @level2type=N'COLUMN',@level2name=N'ItemId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'目前庫存量，不與總庫連動' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MachineStorageDb', @level2type=N'COLUMN',@level2name=N'Amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品序號 from itemDb' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WareHouseDb', @level2type=N'COLUMN',@level2name=N'WareHouseId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'庫存數量' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WareHouseDb', @level2type=N'COLUMN',@level2name=N'Location'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'資料更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WareHouseDb', @level2type=N'COLUMN',@level2name=N'AddDate'
GO
USE [master]
GO
ALTER DATABASE [WiseMachine] SET  READ_WRITE 
GO
