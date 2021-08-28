USE [Group_16]
GO
/****** Object:  UserDefinedFunction [dbo].[generateUserName]    Script Date: 2020/8/11 18:26:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[generateUserName](@id int, @firstname varchar(30), @lastname varchar(30)) RETURNS varchar(30) AS
BEGIN
    RETURN left(@firstname, 4) + left(@lastname, 1) + format(@id, N'd4')
END
GO
/****** Object:  UserDefinedFunction [dbo].[getAge]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getAge](@dob DATE) RETURNS int AS
BEGIN
    -- 112 yyyymmdd
    DECLARE @age int =
        CONVERT(int, (CONVERT(INT, CONVERT(CHAR(8), GETDATE(), 112))
            - CONVERT(CHAR(8), @dob, 112)) / 10000);
    RETURN @age
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAmountOfDrugOrItem]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAmountOfDrugOrItem](@Prescription INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @TotalAmount MONEY
    IF EXISTS(SELECT DrugID FROM dbo.MedicalTreatment WHERE PrescriptionID = @Prescription)
        BEGIN
            SELECT @TotalAmount = (mt.Quantity * d.SellingPrice)
            FROM Group_16.dbo.Prescription p
                     INNER JOIN Group_16.dbo.MedicalTreatment mt
                                ON p.PrescriptionID = mt.PrescriptionID
                     INNER JOIN Group_16.dbo.Drug d
                                ON mt.DrugID = d.DrugID
            WHERE @Prescription = mt.PrescriptionID
        END
    IF EXISTS(SELECT ItemID FROM dbo.MedicalTreatment WHERE PrescriptionID = @Prescription)
        BEGIN
            SELECT @TotalAmount = (mt.Quantity * ci.SellingPrice)
            FROM Group_16.dbo.Prescription p
                     INNER JOIN Group_16.dbo.MedicalTreatment mt
                                ON p.PrescriptionID = mt.PrescriptionID
                     INNER JOIN Group_16.dbo.ConsumableItem ci
                                ON mt.ItemID = ci.ItemID
            WHERE @Prescription = mt.PrescriptionID
        END
    RETURN @TotalAmount
END
GO
/****** Object:  UserDefinedFunction [dbo].[isAllDigits]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[isAllDigits](@str VARCHAR(max)) RETURNS bit AS
BEGIN
    if @str NOT like '%[^0-9]%'
    Return 1
    RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[isExistingAuthority]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[isExistingAuthority](@authority VARCHAR(30)) RETURNS bit AS
BEGIN
    if exists(SELECT * from dbo.AuthorityType a where @authority like a.Authority)
    return 1;
    return 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[isExistingStatus]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[isExistingStatus](@Status VARCHAR(30)) RETURNS bit AS
BEGIN
    if exists(SELECT * from dbo.StatusType s where @Status like s.StatusType)
    return 1;
    return 0;
END
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[EmployeeID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HospitalEmployee]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HospitalEmployee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[MiddleName] [varchar](30) NULL,
	[LastName] [varchar](30) NOT NULL,
	[Gender] [varchar](30) NULL,
	[Sex] [bit] NOT NULL,
	[DateofBirth] [date] NOT NULL,
	[Status] [varchar](30) NOT NULL,
	[Age]  AS ([dbo].[getAge]([DateofBirth])),
	[UserName]  AS ([dbo].[generateUserName]([EmployeeID],[FirstName],[LastName])),
	[PassWord] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[DoctorOnWork]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[DoctorOnWork] as
	select h.EmployeeID, FirstName, LastName, Status from dbo.Doctor INNER JOIN dbo.HospitalEmployee h on Doctor.EmployeeID = h.EmployeeID
    AND Status LIKE 'ONWORK'
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](30) NOT NULL,
	[MiddleName] [varchar](30) NULL,
	[LastName] [varchar](30) NOT NULL,
	[Gender] [varchar](30) NULL,
	[Sex] [bit] NOT NULL,
	[DateofBirth] [date] NULL,
	[age]  AS ([dbo].[getAge]([DateofBirth])),
PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SensitiveSource]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SensitiveSource](
	[SensitiveSourceID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[Type] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PaitientSensitiveSource]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[PaitientSensitiveSource] as
	select p.PatientID, FirstName, LastName, STUFF(
	    (SELECT ' / ' + ss0.Type from dbo.SensitiveSource ss0 WHERE ss0.PatientID = ss.PatientID FOR XML PATH (''))
            ,1,3,''
        ) as [SensitiveSource] from dbo.SensitiveSource ss INNER JOIN dbo.Patient p ON ss.PatientID = p.PatientID
GO
/****** Object:  Table [dbo].[Drug]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drug](
	[DrugID] [int] IDENTITY(1,1) NOT NULL,
	[DrugName] [varchar](30) NOT NULL,
	[DrugType] [varchar](30) NULL,
	[DrugQuantity] [int] NOT NULL,
	[PurchasingPrice] [money] NOT NULL,
	[SellingPrice] [money] NOT NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DrugID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[InventoryWarningOfDrug]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[InventoryWarningOfDrug] as
	select d.DrugID, d.DrugName, d.DrugQuantity from dbo.Drug d where d.DrugQuantity <= 500
GO
/****** Object:  Table [dbo].[ConsumableItem]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumableItem](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [varchar](30) NOT NULL,
	[ItemType] [varchar](30) NULL,
	[ItemQuantity] [int] NOT NULL,
	[PurchasingPrice] [money] NOT NULL,
	[SellingPrice] [money] NOT NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[InventoryWarningOfConsumableItem]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[InventoryWarningOfConsumableItem] as
	select ci.itemid, itemname, itemquantity from dbo.ConsumableItem ci where ci.ItemQuantity <= 500
GO
/****** Object:  Table [dbo].[Address]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AdressID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[State] [varchar](30) NOT NULL,
	[City] [varchar](30) NOT NULL,
	[Street] [varchar](30) NOT NULL,
	[ZIPCode] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AdressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Authority]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authority](
	[AuthorityID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[AuthorityType] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthorityType]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthorityType](
	[AuthorityTypeID] [int] NOT NULL,
	[Authority] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [varchar](30) NOT NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Finance]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Finance](
	[FinanceID] [int] IDENTITY(1,1) NOT NULL,
	[Expenditure] [money] NULL,
	[Income] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[FinanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FinancialEvent]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinancialEvent](
	[FinancialEventID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[MoneyAccountID] [int] NOT NULL,
	[Purpose] [varchar](max) NULL,
	[TransactionFlow] [money] NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FinancialEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HospitalEmployeeContactInformation]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HospitalEmployeeContactInformation](
	[ContactInformationID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[PhoneNumber] [varchar](30) NOT NULL,
	[Description] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactInformationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Manager]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manager](
	[EmployeeID] [int] NOT NULL,
	[Superior] [int] NULL,
	[Position] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalTreatment]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalTreatment](
	[MedicalTreatmentID] [int] IDENTITY(1,1) NOT NULL,
	[PrescriptionID] [int] NULL,
	[DrugID] [int] NULL,
	[ItemID] [int] NULL,
	[Quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MedicalTreatmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MoneyAccount]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MoneyAccount](
	[MoneyAccountID] [int] IDENTITY(1,1) NOT NULL,
	[FinanceID] [int] NOT NULL,
	[MoneyAccountNumber] [varchar](30) NOT NULL,
	[Describtion] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[MoneyAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OfficeHour]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfficeHour](
	[OfficeHourID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[Week] [int] NOT NULL,
	[WorkTime] [time](7) NOT NULL,
	[OffWorkTime] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OfficeHourID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientContactInformation]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientContactInformation](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[PhoneNumber] [varchar](30) NULL,
	[PatientID] [int] NOT NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[PrescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[EmployeeID] [int] NULL,
	[Content] [varchar](max) NULL,
	[DateTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Procurement]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Procurement](
	[procurementID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ItemID] [int] NULL,
	[DrugID] [int] NULL,
	[Quantity] [int] NULL,
	[DateTime] [datetime] NULL,
	[Description] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[procurementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receipt]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipt](
	[PrescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[DateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusType]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusType](
	[StatusTypeID] [int] NOT NULL,
	[StatusType] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportCrew]    Script Date: 2020/8/11 18:26:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportCrew](
	[EmployeeID] [int] NOT NULL,
	[Position] [varchar](30) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Address] ON 

INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (1, 11, N'MA', N'Boston', N'109 Saint Stephen St', N'02115')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (2, 12, N'MA', N'Boston', N'11 Hedge Rd, Brookline', N'02445')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (3, 13, N'NY', N'NewYork', N'100 Jerusalem Ave, Hempstead', N'11550')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (4, 14, N'NY', N'NewYork', N'1715 Motor Pkwy, Hauppauge', N'11788')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (5, 15, N'MA', N'Boston', N'131 Milford St', N'02118')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (6, 16, N'MA', N'Boston', N'38 Lyme St, Malden', N'02148')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (12, 18, N'MA', N'Boston', N'3-11 Green St, Woburn ', N'01801')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (15, 19, N'MA', N'Boston', N'14-8 Jackson St, Quincy', N'02169')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (16, 20, N'MA', N'Boston', N'16-2 Mildred Rd,Burlingtonn', N'01803')
INSERT [dbo].[Address] ([AdressID], [EmployeeID], [State], [City], [Street], [ZIPCode]) VALUES (17, 21, N'MA', N'Boston', N'113-137 Intervale St, Quincy', N'02169')
SET IDENTITY_INSERT [dbo].[Address] OFF
GO
SET IDENTITY_INSERT [dbo].[Authority] ON 

INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (15, 11, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (16, 11, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (65, 11, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (17, 12, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (18, 12, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (66, 12, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (19, 13, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (20, 13, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (67, 13, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (21, 14, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (22, 14, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (68, 14, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (23, 15, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (24, 15, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (69, 15, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (25, 16, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (26, 16, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (70, 16, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (27, 18, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (28, 18, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (71, 18, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (29, 19, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (30, 19, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (72, 19, N'PROCUREMENT')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (31, 20, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (32, 20, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (33, 21, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (34, 21, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (35, 22, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (36, 22, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (55, 22, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (37, 23, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (38, 23, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (56, 23, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (39, 24, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (40, 24, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (57, 24, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (41, 25, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (42, 25, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (58, 25, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (43, 26, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (44, 26, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (59, 26, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (45, 27, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (46, 27, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (60, 27, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (47, 28, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (48, 28, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (61, 28, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (49, 29, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (50, 29, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (62, 29, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (51, 30, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (52, 30, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (63, 30, N'PRESCRIBE')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (53, 31, N'ACCESS')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (54, 31, N'LOGIN')
INSERT [dbo].[Authority] ([AuthorityID], [EmployeeID], [AuthorityType]) VALUES (64, 31, N'PRESCRIBE')
SET IDENTITY_INSERT [dbo].[Authority] OFF
GO
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (1, N'ACCESS')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (8, N'FINANCE')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (2, N'LOGIN')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (3, N'PRESCRIBE')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (4, N'PROCUREMENT')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (5, N'FINANCE')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (6, N'RECRUIT')
INSERT [dbo].[AuthorityType] ([AuthorityTypeID], [Authority]) VALUES (7, N'EXPEL')
GO
SET IDENTITY_INSERT [dbo].[ConsumableItem] ON 

INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (1, N'AA', NULL, 2757, 1.0000, 2.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (2, N'BB', NULL, 2792, 2.0000, 3.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (3, N'CC', NULL, 442, 2.0000, 3.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (4, N'DD', NULL, 2817, 4.0000, 5.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (5, N'EE', NULL, 1000, 5.0000, 6.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (6, N'FF', NULL, 1475, 6.0000, 7.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (7, N'GG', NULL, 2847, 12.0000, 15.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (8, N'HH', NULL, 2857, 4.0000, 5.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (9, N'II', NULL, 411, 6.0000, 7.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (10, N'JJ', NULL, 1123, 7.0000, 8.0000, NULL)
INSERT [dbo].[ConsumableItem] ([ItemID], [ItemName], [ItemType], [ItemQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (11, N'KK', NULL, 2214, 8.0000, 9.0000, NULL)
SET IDENTITY_INSERT [dbo].[ConsumableItem] OFF
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (1, N'Center', N'zhongxin')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (3, N'Department of surgery', N'waike')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (4, N'Department of pediatrics', N'erke')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (6, N'Department of neurology', N'yan')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (7, N'Department of ophtalmology', N'yan')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (8, N'Department of stomatology', N'kouqiang')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (9, N'Department of orthopedic', N'gu')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (10, N'Department of urology', N'miniao')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (11, N'Department of dermatology', N'pifu')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (12, N'Department of cardiac surgery', N'xinzang')
INSERT [dbo].[Department] ([DepartmentID], [DepartmentName], [Description]) VALUES (14, N'Pharmacy dispensary', N'yaofang')
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (22, 1)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (23, 1)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (24, 3)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (25, 4)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (26, 14)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (27, 6)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (28, 8)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (29, 9)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (30, 10)
INSERT [dbo].[Doctor] ([EmployeeID], [DepartmentID]) VALUES (31, 11)
GO
SET IDENTITY_INSERT [dbo].[Drug] ON 

INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (1, N'A', NULL, 2787, 1.0000, 2.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (2, N'B', NULL, 413, 2.0000, 3.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (8, N'C', NULL, 2807, 3.0000, 4.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (9, N'D', NULL, 2817, 4.0000, 5.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (10, N'E', NULL, 2817, 5.0000, 6.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (11, N'F', NULL, 412, 6.0000, 9.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (12, N'G', NULL, 2847, 7.0000, 8.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (13, N'H', NULL, 2857, 8.0000, 9.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (14, N'I', NULL, 2867, 9.0000, 10.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (15, N'J', NULL, 555, 10.0000, 12.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (17, N'K', NULL, 651, 11.0000, 15.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (18, N'L', NULL, 2897, 12.0000, 13.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (19, N'M', NULL, 2907, 13.0000, 16.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (20, N'N', NULL, 2917, 14.0000, 15.0000, NULL)
INSERT [dbo].[Drug] ([DrugID], [DrugName], [DrugType], [DrugQuantity], [PurchasingPrice], [SellingPrice], [Description]) VALUES (21, N'O', NULL, 1000, 15.0000, 16.0000, NULL)
SET IDENTITY_INSERT [dbo].[Drug] OFF
GO
SET IDENTITY_INSERT [dbo].[Finance] ON 

INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (1, 600.0000, 500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (2, 700.0000, 2500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (3, 800.0000, 3500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (4, 900.0000, 4500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (5, 300.0000, 5500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (6, 400.0000, 6500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (7, 5600.0000, 7500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (8, 6100.0000, 8500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (9, 6200.0000, 9500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (10, 6300.0000, 8500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (11, 6500.0000, 7500.0000)
INSERT [dbo].[Finance] ([FinanceID], [Expenditure], [Income]) VALUES (12, 6600.0000, 6500.0000)
SET IDENTITY_INSERT [dbo].[Finance] OFF
GO
SET IDENTITY_INSERT [dbo].[FinancialEvent] ON 

INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (1, 11, 1, N'Purchase', 10000.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (3, 12, 1, N'Purchase', 10000.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (4, 11, 1, N'Purchase', 100.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (5, 12, 2, N'Purchase', 200.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (6, 13, 3, N'Purchase', 300.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (10, 12, 7, N'Purchase', 700.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (14, 13, 1, N'prescribtion', 400.0000, N'income')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (17, 14, 1, N'Purchase', 10000.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (18, 15, 2, N'prescribtion', 400.0000, N'income')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (19, 16, 3, N'Purchase', 200.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (20, 18, 4, N'Activity', 4000.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (21, 19, 5, N'Activity', 2000.0000, N'expendense')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (28, 12, 1, N'Procurement of Item', 0.0000, NULL)
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (29, 11, 2, N'Procurement of Item', 0.0000, NULL)
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (30, 12, 1, N'Purchase', 160.0000, NULL)
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (31, 11, 2, N'Purchase', 40.0000, N'expendense of drug')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (32, 12, 1, N'Purchase', 20.0000, N'expendense of item')
INSERT [dbo].[FinancialEvent] ([FinancialEventID], [EmployeeID], [MoneyAccountID], [Purpose], [TransactionFlow], [Description]) VALUES (33, 11, 2, N'Purchase', 30.0000, N'expendense of drug')
SET IDENTITY_INSERT [dbo].[FinancialEvent] OFF
GO
SET IDENTITY_INSERT [dbo].[HospitalEmployee] ON 

INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (11, N'Art', NULL, N'The', NULL, 1, CAST(N'1999-08-01' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   ∫=úñ?ô«t)·¢—>d*ÁLVèè5¨H€Z¸')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (12, N'Bojack', NULL, N'Horseman', NULL, 1, CAST(N'1997-06-01' AS Date), N'LEAVE', N' àz Æ“OH≠Yp«<‡a   ã°d¥˝∆§˝Ò›¥ya\Œ)K˛ÉÎgæ¢Ä§•˝d˜z◊: ∑‚3o⁄3a∆¢™3')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (13, N'Car', NULL, N'Cat', NULL, 1, CAST(N'1978-01-09' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   ¨Ò ?íßl1·t∆c¿+n®˛–#åÖU◊}‡òﬂs÷íÃ÷p◊{búÑ‰ÅN∆;¯')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (14, N'Dog', NULL, N'Dad', NULL, 1, CAST(N'2001-01-09' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   ˙k∑Îª‰c»zí@Ã_åi~zCmfa¨†Ÿ-âJß')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (15, N'Egg', NULL, N'Eat', NULL, 1, CAST(N'2000-01-06' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   „·à60“xGÅA÷»∑qôv7ˆÈÇa÷≈∏)hUëª¥mE¿≠Kµ7…ÿ')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (16, N'Flower', NULL, N'Fly', NULL, 0, CAST(N'1987-05-02' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   J≠í8Fïv˙∏ﬁ W‘ø›Y(lßµ:∑ä¨óÁÎî’€˜CZ≠l9˙ŒiÆB®Ú^')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (18, N'GiGi', NULL, N'Kal', NULL, 0, CAST(N'1991-08-01' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   clÍ“‚nt£89∞_Û“∂’dó·∫ê3H∆aøç ¥Ts$π√8‚∂ûâ£')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (19, N'Heat', NULL, N'Hot', NULL, 0, CAST(N'1994-03-01' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   ‰˛lÉ`X4™9øñ◊¿¿fV%Haö⁄ƒaónC¡n‹©V(lC˝n∏3õ''Iº')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (20, N'Ideal', NULL, N'Idol', NULL, 1, CAST(N'1990-06-01' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   ã°d¥˝∆§˝Ò›¥ya\Œ)K˛ÉÎgæ¢Ä§•˝d˜z◊: ∑‚3o⁄3a∆¢™3')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (21, N'Old', NULL, N'Jack', NULL, 1, CAST(N'1949-02-28' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   iÀÔAÁU?\^7záùèOøNã√ŒIÉ1¸|—ù˙_4{Ç—ß;3ı
µ”')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (22, N'Rick', NULL, N'Sanchez', NULL, 1, CAST(N'1952-04-08' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   ˙È{îtëN˘À:}›ﬁ—ÔÚ–+ˆqÚ©è≈Y®s•ÒáV„dﬂÊ≈.Ü æ¥s')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (23, N'Morty', NULL, N'Smith', NULL, 1, CAST(N'1996-04-08' AS Date), N'LEAVE', N' àz Æ“OH≠Yp«<‡a   ªûTu¬E≥Îf¯ü…qf§Ú ÔtÌ¯wF—ä1#´K‘ìNæˆd˚¿π‰jÕÃ')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (24, N'Jerry', NULL, N'Smith', NULL, 1, CAST(N'1968-05-09' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   |d 	VÒP}´Ö(VòC…Á™ïJ ßG≈⁄–…TpMô®Ôó=äÖ“)8®§')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (25, N'Beth', NULL, N'Smith', NULL, 0, CAST(N'1969-07-11' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   ±|àÂ°ö{· ôØ{°jÆ*]Ãﬁ®˚KÏ&õÕ7¢¯M¿“Ûcs˙ôˆÇÚá]')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (26, N'Summer', NULL, N'Smith', NULL, 0, CAST(N'1993-01-09' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   Ÿ‡Ùt“»“jQP4\•Ÿ¶pVDÓµñ»°¿ò≤*ö2…#$ReJ@}•Ôû&‘ÑÂ')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (27, N'Todd', NULL, N'Chavez', NULL, 1, CAST(N'1988-03-22' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   Dúa∫¡Bì?8õ¢ßQõ(± ä¶À].ª˛PöÛ√ø;sSfÊ¬µ$vàòøô¡"O')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (28, N'Princess', NULL, N'Carolyn', NULL, 0, CAST(N'1971-05-21' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   t>ÿ^5^:p;+Ä¥º≥&ø‰"üòJEòK''p¢"M‘#Q ^;¯åÏ©~‘2')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (29, N'Diane', NULL, N'Nguyen', NULL, 0, CAST(N'1982-11-15' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   ˆ¯HO¬A˝&ü4:¶ëgoaÙö}◊u,ÄÓ;∏oqáÅ
≠≥9ê˜ßﬁîΩK∏dn}')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (30, N'Pinky', NULL, N'Penguin', NULL, 1, CAST(N'1956-09-21' AS Date), N'ONWORK', N' àz Æ“OH≠Yp«<‡a   \tEéy√cö[⁄ÆëŸôíŸˆÁâ~~Ú‡ÕnˆñÅ‡>5ûΩÇS∫Q>	Ñ;')
INSERT [dbo].[HospitalEmployee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth], [Status], [PassWord]) VALUES (31, N'Herb', NULL, N'Kazzaz', NULL, 1, CAST(N'1985-03-29' AS Date), N'OFFWORK', N' àz Æ“OH≠Yp«<‡a   Ë#.£ëÖFwkµÙì|y#ÉãèSÜAÙÙya¡˙YqRR ¨ùâÁÜ_%·C4Q')
SET IDENTITY_INSERT [dbo].[HospitalEmployee] OFF
GO
SET IDENTITY_INSERT [dbo].[HospitalEmployeeContactInformation] ON 

INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (3, 11, N'6172343456', N'a')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (4, 12, N'6172342345', N'b')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (5, 13, N'6176659867', N'c')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (6, 14, N'6175464535', N'd')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (7, 15, N'6173333456', N'e')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (8, 16, N'6176756753', N'f')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (9, 21, N'6177865446', N'g')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (10, 18, N'6175363553', N'h')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (11, 19, N'6174626713', N'i')
INSERT [dbo].[HospitalEmployeeContactInformation] ([ContactInformationID], [EmployeeID], [PhoneNumber], [Description]) VALUES (12, 20, N'6179876534', N'j')
SET IDENTITY_INSERT [dbo].[HospitalEmployeeContactInformation] OFF
GO
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (11, NULL, N'director')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (12, 11, N'general manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (13, 11, N'district manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (14, NULL, N'gerneral manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (15, 11, N'training manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (27, 28, N'general manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (28, NULL, N'senior manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (29, 28, N'senior manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (30, 31, N'senior manager')
INSERT [dbo].[Manager] ([EmployeeID], [Superior], [Position]) VALUES (31, 11, N'senior manager')
GO
SET IDENTITY_INSERT [dbo].[MedicalTreatment] ON 

INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (33, 10, 2, NULL, 20)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (64, 5, 1, NULL, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (71, 5, 1, NULL, 30)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (82, 12, 8, NULL, 100)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (110, 22, NULL, 2, 40)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (111, 12, 15, NULL, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (119, 10, NULL, 3, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (120, 5, NULL, 4, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (122, 17, NULL, 4, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (124, 18, 1, NULL, 10)
INSERT [dbo].[MedicalTreatment] ([MedicalTreatmentID], [PrescriptionID], [DrugID], [ItemID], [Quantity]) VALUES (127, 15, 10, NULL, 10)
SET IDENTITY_INSERT [dbo].[MedicalTreatment] OFF
GO
SET IDENTITY_INSERT [dbo].[MoneyAccount] ON 

INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (1, 1, N'123456789', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (2, 1, N'987654321', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (3, 2, N'112223345', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (4, 3, N'741258963', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (5, 4, N'159874632', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (6, 5, N'123654789', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (7, 6, N'852146973', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (8, 7, N'987456321', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (9, 8, N'963258741', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (10, 9, N'654789321', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (11, 10, N'147896325', NULL)
INSERT [dbo].[MoneyAccount] ([MoneyAccountID], [FinanceID], [MoneyAccountNumber], [Describtion]) VALUES (12, 11, N'523698741', NULL)
SET IDENTITY_INSERT [dbo].[MoneyAccount] OFF
GO
SET IDENTITY_INSERT [dbo].[OfficeHour] ON 

INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (1, 11, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (2, 12, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (4, 12, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (5, 13, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (6, 14, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (7, 15, 1, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (8, 16, 2, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (9, 18, 4, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (10, 19, 7, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (11, 20, 2, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
INSERT [dbo].[OfficeHour] ([OfficeHourID], [EmployeeID], [Week], [WorkTime], [OffWorkTime]) VALUES (12, 21, 4, CAST(N'08:00:00' AS Time), CAST(N'18:00:00' AS Time))
SET IDENTITY_INSERT [dbo].[OfficeHour] OFF
GO
SET IDENTITY_INSERT [dbo].[Patient] ON 

INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (1, N'asd', N'asd', N'asd', NULL, 1, CAST(N'1997-01-09' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (2, N'ccaa', NULL, N'ssss', NULL, 1, CAST(N'2000-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (3, N'jj', NULL, N'tt', NULL, 0, CAST(N'2004-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (4, N'aa', NULL, N'kk', NULL, 0, CAST(N'1995-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (5, N'bb', NULL, N'll', NULL, 1, CAST(N'1996-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (6, N'cc', NULL, N'mm', NULL, 1, CAST(N'1997-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (7, N'dd', NULL, N'nn', NULL, 1, CAST(N'1998-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (8, N'ee', NULL, N'oo', NULL, 0, CAST(N'1999-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (9, N'ff', NULL, N'pp', NULL, 0, CAST(N'2000-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (10, N'gg', NULL, N'qq', NULL, 0, CAST(N'2001-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (11, N'hh', NULL, N'rr', NULL, 1, CAST(N'2002-01-01' AS Date))
INSERT [dbo].[Patient] ([PatientID], [FirstName], [MiddleName], [LastName], [Gender], [Sex], [DateofBirth]) VALUES (12, N'ii', NULL, N'ss', NULL, 1, CAST(N'2003-01-01' AS Date))
SET IDENTITY_INSERT [dbo].[Patient] OFF
GO
SET IDENTITY_INSERT [dbo].[PatientContactInformation] ON 

INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (1, N'123456789', 1, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (2, N'987654321', 2, N'VIP')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (3, N'123456789', 3, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (4, N'987654321', 4, N'VIP')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (5, N'123456789', 5, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (6, N'987654321', 6, N'VIP')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (7, N'123456789', 7, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (8, N'987654321', 8, N'VIP')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (9, N'123456789', 9, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (10, N'987654321', 10, N'VIP')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (11, N'123456789', 11, N'General')
INSERT [dbo].[PatientContactInformation] ([ContactID], [PhoneNumber], [PatientID], [Description]) VALUES (12, N'987654321', 12, N'VIP')
SET IDENTITY_INSERT [dbo].[PatientContactInformation] OFF
GO
SET IDENTITY_INSERT [dbo].[Prescription] ON 

INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (5, 1, 22, N'Medicine', CAST(N'2020-08-10T19:02:18.397' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (10, 2, 22, N'Aspirin', CAST(N'2020-08-10T19:56:57.170' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (12, 2, 22, N'Aspirin', CAST(N'2020-08-10T19:57:23.690' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (15, 2, 23, N'Aspirin', CAST(N'2020-08-10T19:59:03.817' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (16, 3, 24, N'Aspirin', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (17, 4, 25, N'Acupuncture', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (18, 5, 26, N'Herb', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (19, 6, 27, N'Aspirin', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (20, 7, 28, N'Acupuncture', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (21, 8, 29, N'Herb', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (22, 9, 30, N'Herb', CAST(N'2020-08-10T22:22:52.127' AS DateTime))
INSERT [dbo].[Prescription] ([PrescriptionID], [PatientID], [EmployeeID], [Content], [DateTime]) VALUES (25, 1, 22, N'Herb', CAST(N'2020-08-11T15:03:50.573' AS DateTime))
SET IDENTITY_INSERT [dbo].[Prescription] OFF
GO
SET IDENTITY_INSERT [dbo].[Procurement] ON 

INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (3, 11, NULL, 1, 30, CAST(N'2020-08-10T20:36:06.210' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (70, 12, NULL, 2, 10, CAST(N'2020-08-10T22:34:35.997' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (71, 13, NULL, 10, 30, CAST(N'2020-08-10T22:35:05.417' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (81, 11, 1, NULL, 20, CAST(N'2020-08-10T22:39:05.040' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (82, 11, NULL, 2, 20, CAST(N'2020-08-10T22:40:56.860' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (83, 11, NULL, 2, 20, CAST(N'2020-08-10T22:41:48.280' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (91, 12, 1, NULL, 20, CAST(N'2020-08-10T23:24:37.810' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (92, 11, NULL, 2, 20, CAST(N'2020-08-10T23:24:52.943' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (93, 12, 1, NULL, 20, CAST(N'2020-08-10T23:33:22.840' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (94, 11, NULL, 2, 20, CAST(N'2020-08-10T23:40:36.210' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (95, 12, 1, NULL, 20, CAST(N'2020-08-10T23:40:51.597' AS DateTime), NULL)
INSERT [dbo].[Procurement] ([procurementID], [EmployeeID], [ItemID], [DrugID], [Quantity], [DateTime], [Description]) VALUES (97, 11, NULL, 1, 30, CAST(N'2020-08-11T15:09:57.840' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Procurement] OFF
GO
SET IDENTITY_INSERT [dbo].[Receipt] ON 

INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (2, 1, 123.0000, CAST(N'2020-08-10T22:19:06.757' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (3, 2, 234.0000, CAST(N'2020-08-10T22:19:36.240' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (4, 3, 345.0000, CAST(N'2020-08-10T22:19:36.240' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (5, 4, 456.0000, CAST(N'2020-08-10T22:19:36.240' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (6, 5, 567.0000, CAST(N'2020-08-10T22:19:36.240' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (7, 6, 547.0000, CAST(N'2020-08-10T22:19:36.240' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (8, 7, 433.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (9, 8, 766.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (10, 9, 345.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (11, 10, 344.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (12, 11, 567.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
INSERT [dbo].[Receipt] ([PrescriptionID], [PatientID], [Amount], [DateTime]) VALUES (13, 12, 354.0000, CAST(N'2020-08-10T22:19:36.253' AS DateTime))
SET IDENTITY_INSERT [dbo].[Receipt] OFF
GO
SET IDENTITY_INSERT [dbo].[SensitiveSource] ON 

INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (1, 1, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (2, 2, N'pollen')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (3, 3, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (4, 4, N'pollen')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (5, 5, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (6, 6, N'pollen')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (7, 7, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (8, 8, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (9, 9, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (10, 10, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (11, 11, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (12, 12, N'penicillin')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (14, 1, N'pollen')
INSERT [dbo].[SensitiveSource] ([SensitiveSourceID], [PatientID], [Type]) VALUES (15, 4, N'penicillin')
SET IDENTITY_INSERT [dbo].[SensitiveSource] OFF
GO
INSERT [dbo].[StatusType] ([StatusTypeID], [StatusType]) VALUES (1, N'OFFWORK')
INSERT [dbo].[StatusType] ([StatusTypeID], [StatusType]) VALUES (2, N'ONWORK')
INSERT [dbo].[StatusType] ([StatusTypeID], [StatusType]) VALUES (3, N'LEAVE')
INSERT [dbo].[StatusType] ([StatusTypeID], [StatusType]) VALUES (4, N'OTHER')
GO
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (11, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (12, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (13, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (14, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (15, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (16, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (18, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (19, N'Purchasingstaff')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (20, N'Security')
INSERT [dbo].[SupportCrew] ([EmployeeID], [Position]) VALUES (21, N'Security')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [noDuplicatedAuthority]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[Authority] ADD  CONSTRAINT [noDuplicatedAuthority] UNIQUE NONCLUSTERED 
(
	[EmployeeID] ASC,
	[AuthorityType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AuthorityType_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[AuthorityType] ADD  CONSTRAINT [AuthorityType_pk] PRIMARY KEY NONCLUSTERED 
(
	[AuthorityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Doctor_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[Doctor] ADD  CONSTRAINT [Doctor_pk] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Manager_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[Manager] ADD  CONSTRAINT [Manager_pk] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SensitiveSource_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[SensitiveSource] ADD  CONSTRAINT [SensitiveSource_pk] PRIMARY KEY NONCLUSTERED 
(
	[SensitiveSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [StatusType_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[StatusType] ADD  CONSTRAINT [StatusType_pk] PRIMARY KEY NONCLUSTERED 
(
	[StatusTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [SupportCrew_pk]    Script Date: 2020/8/11 18:26:23 ******/
ALTER TABLE [dbo].[SupportCrew] ADD  CONSTRAINT [SupportCrew_pk] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConsumableItem] ADD  DEFAULT ((0)) FOR [ItemQuantity]
GO
ALTER TABLE [dbo].[Drug] ADD  DEFAULT ((0)) FOR [DrugQuantity]
GO
ALTER TABLE [dbo].[Finance] ADD  DEFAULT ((0)) FOR [Expenditure]
GO
ALTER TABLE [dbo].[Finance] ADD  DEFAULT ((0)) FOR [Income]
GO
ALTER TABLE [dbo].[FinancialEvent] ADD  DEFAULT ((0)) FOR [TransactionFlow]
GO
ALTER TABLE [dbo].[HospitalEmployee] ADD  DEFAULT ('OFFWORK') FOR [Status]
GO
ALTER TABLE [dbo].[HospitalEmployee] ADD  DEFAULT ('123456') FOR [PassWord]
GO
ALTER TABLE [dbo].[MedicalTreatment] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Prescription] ADD  CONSTRAINT [setCurrentTimeAsDefaultForPrescription]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[Procurement] ADD  CONSTRAINT [setCurrentTimeAsDefaultForProcurement]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[Receipt] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[Receipt] ADD  CONSTRAINT [setCurrentTimeAsDefaultForReceipt]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [Address_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Address_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Authority]  WITH CHECK ADD  CONSTRAINT [Authority_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Authority] CHECK CONSTRAINT [Authority_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [Doctor_Department_DepartmentID_fk] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [Doctor_Department_DepartmentID_fk]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [Doctor_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [Doctor_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[FinancialEvent]  WITH CHECK ADD  CONSTRAINT [FinancialEvent_MoneyAccount_MoneyAccountID_fk] FOREIGN KEY([MoneyAccountID])
REFERENCES [dbo].[MoneyAccount] ([MoneyAccountID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FinancialEvent] CHECK CONSTRAINT [FinancialEvent_MoneyAccount_MoneyAccountID_fk]
GO
ALTER TABLE [dbo].[FinancialEvent]  WITH CHECK ADD  CONSTRAINT [FinancialEvent_SupportCrew_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[SupportCrew] ([EmployeeID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FinancialEvent] CHECK CONSTRAINT [FinancialEvent_SupportCrew_EmployeeID_fk]
GO
ALTER TABLE [dbo].[HospitalEmployeeContactInformation]  WITH CHECK ADD  CONSTRAINT [HospitalEmployeeContactInformation_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HospitalEmployeeContactInformation] CHECK CONSTRAINT [HospitalEmployeeContactInformation_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Manager]  WITH CHECK ADD  CONSTRAINT [Manager_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Manager] CHECK CONSTRAINT [Manager_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[MedicalTreatment]  WITH CHECK ADD  CONSTRAINT [MedicalTreatment_ConsumableItem_ItemID_fk] FOREIGN KEY([ItemID])
REFERENCES [dbo].[ConsumableItem] ([ItemID])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[MedicalTreatment] CHECK CONSTRAINT [MedicalTreatment_ConsumableItem_ItemID_fk]
GO
ALTER TABLE [dbo].[MedicalTreatment]  WITH CHECK ADD  CONSTRAINT [MedicalTreatment_Drug_DrugID_fk] FOREIGN KEY([DrugID])
REFERENCES [dbo].[Drug] ([DrugID])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[MedicalTreatment] CHECK CONSTRAINT [MedicalTreatment_Drug_DrugID_fk]
GO
ALTER TABLE [dbo].[MedicalTreatment]  WITH CHECK ADD  CONSTRAINT [MedicalTreatment_Prescription_PrescriptionID_fk] FOREIGN KEY([PrescriptionID])
REFERENCES [dbo].[Prescription] ([PrescriptionID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MedicalTreatment] CHECK CONSTRAINT [MedicalTreatment_Prescription_PrescriptionID_fk]
GO
ALTER TABLE [dbo].[MoneyAccount]  WITH CHECK ADD  CONSTRAINT [MoneyAccount_Finance_FinanceID_fk] FOREIGN KEY([FinanceID])
REFERENCES [dbo].[Finance] ([FinanceID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MoneyAccount] CHECK CONSTRAINT [MoneyAccount_Finance_FinanceID_fk]
GO
ALTER TABLE [dbo].[OfficeHour]  WITH CHECK ADD  CONSTRAINT [OfficeHour_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OfficeHour] CHECK CONSTRAINT [OfficeHour_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[PatientContactInformation]  WITH CHECK ADD  CONSTRAINT [PatientContactInformation_Patient_PatientID_fk] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PatientContactInformation] CHECK CONSTRAINT [PatientContactInformation_Patient_PatientID_fk]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [Prescription_Doctor_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Doctor] ([EmployeeID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [Prescription_Doctor_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [Prescription_Patient_PatientID_fk] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [Prescription_Patient_PatientID_fk]
GO
ALTER TABLE [dbo].[Procurement]  WITH CHECK ADD  CONSTRAINT [Procurement_ConsumableItem_ItemID_fk] FOREIGN KEY([ItemID])
REFERENCES [dbo].[ConsumableItem] ([ItemID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Procurement] CHECK CONSTRAINT [Procurement_ConsumableItem_ItemID_fk]
GO
ALTER TABLE [dbo].[Procurement]  WITH CHECK ADD  CONSTRAINT [Procurement_Drug_DrugID_fk] FOREIGN KEY([DrugID])
REFERENCES [dbo].[Drug] ([DrugID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Procurement] CHECK CONSTRAINT [Procurement_Drug_DrugID_fk]
GO
ALTER TABLE [dbo].[Procurement]  WITH CHECK ADD  CONSTRAINT [Procurement_SupportCrew_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[SupportCrew] ([EmployeeID])
GO
ALTER TABLE [dbo].[Procurement] CHECK CONSTRAINT [Procurement_SupportCrew_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Receipt]  WITH CHECK ADD  CONSTRAINT [Receipt_Patient_PatientID_fk] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Receipt] CHECK CONSTRAINT [Receipt_Patient_PatientID_fk]
GO
ALTER TABLE [dbo].[SensitiveSource]  WITH CHECK ADD  CONSTRAINT [SensitiveSource_Patient_PatientID_fk] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SensitiveSource] CHECK CONSTRAINT [SensitiveSource_Patient_PatientID_fk]
GO
ALTER TABLE [dbo].[SupportCrew]  WITH CHECK ADD  CONSTRAINT [SupportCrew_HospitalEmployee_EmployeeID_fk] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[HospitalEmployee] ([EmployeeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SupportCrew] CHECK CONSTRAINT [SupportCrew_HospitalEmployee_EmployeeID_fk]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [isZipCodeAllDigits] CHECK  (([dbo].[isAllDigits]([ZIPCode])=(1)))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [isZipCodeAllDigits]
GO
ALTER TABLE [dbo].[Authority]  WITH CHECK ADD  CONSTRAINT [isExustungAuthority] CHECK  (([dbo].[isExistingAuthority]([AuthorityType])=(1)))
GO
ALTER TABLE [dbo].[Authority] CHECK CONSTRAINT [isExustungAuthority]
GO
ALTER TABLE [dbo].[ConsumableItem]  WITH CHECK ADD  CONSTRAINT [itemQuantityNoLessThanZero] CHECK  (([ItemQuantity]>=(0)))
GO
ALTER TABLE [dbo].[ConsumableItem] CHECK CONSTRAINT [itemQuantityNoLessThanZero]
GO
ALTER TABLE [dbo].[Drug]  WITH CHECK ADD  CONSTRAINT [drugQuantityNoLessThanZero] CHECK  (([DrugQuantity]>=(0)))
GO
ALTER TABLE [dbo].[Drug] CHECK CONSTRAINT [drugQuantityNoLessThanZero]
GO
ALTER TABLE [dbo].[HospitalEmployee]  WITH CHECK ADD  CONSTRAINT [DateofBirthNotNull] CHECK  (([DateofBirth] IS NOT NULL))
GO
ALTER TABLE [dbo].[HospitalEmployee] CHECK CONSTRAINT [DateofBirthNotNull]
GO
ALTER TABLE [dbo].[HospitalEmployee]  WITH CHECK ADD  CONSTRAINT [firstNameNotNull] CHECK  (([FirstName] IS NOT NULL))
GO
ALTER TABLE [dbo].[HospitalEmployee] CHECK CONSTRAINT [firstNameNotNull]
GO
ALTER TABLE [dbo].[HospitalEmployee]  WITH CHECK ADD  CONSTRAINT [isExistingStatusForEmployee] CHECK  (([dbo].[isExistingStatus]([Status])=(1)))
GO
ALTER TABLE [dbo].[HospitalEmployee] CHECK CONSTRAINT [isExistingStatusForEmployee]
GO
ALTER TABLE [dbo].[HospitalEmployee]  WITH CHECK ADD  CONSTRAINT [lastNameNotNull] CHECK  (([LastName] IS NOT NULL))
GO
ALTER TABLE [dbo].[HospitalEmployee] CHECK CONSTRAINT [lastNameNotNull]
GO
ALTER TABLE [dbo].[HospitalEmployeeContactInformation]  WITH CHECK ADD  CONSTRAINT [isHospitalEmployeePhoneNumberAllDigits] CHECK  (([dbo].[isAllDigits]([PhoneNumber])=(1)))
GO
ALTER TABLE [dbo].[HospitalEmployeeContactInformation] CHECK CONSTRAINT [isHospitalEmployeePhoneNumberAllDigits]
GO
ALTER TABLE [dbo].[PatientContactInformation]  WITH CHECK ADD  CONSTRAINT [isPatientPhoneNumberAllDigits] CHECK  (([dbo].[isAllDigits]([PhoneNumber])=(1)))
GO
ALTER TABLE [dbo].[PatientContactInformation] CHECK CONSTRAINT [isPatientPhoneNumberAllDigits]
GO
/****** Object:  Trigger [dbo].[preventUpdateAuthorityTpye]    Script Date: 2020/8/11 18:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[preventUpdateAuthorityTpye]
    ON [dbo].[Authority]
    AFTER UPDATE AS
BEGIN
    DECLARE @bes varchar(30);
    DECLARE @afs varchar(30) ;
    SELECT @bes = d.AuthorityType from deleted d
    SELECT @afs = i.AuthorityType from inserted i;
    IF update(AuthorityType) AND (@bes NOT LIKE @afs)
        BEGIN

            ROLLBACK;
            RAISERROR ('Can''t update Authority. Please drop first and then insert', 16, 1);
        END
END
GO
ALTER TABLE [dbo].[Authority] ENABLE TRIGGER [preventUpdateAuthorityTpye]
GO
/****** Object:  Trigger [dbo].[setAUthorityUpperCaseForInsert]    Script Date: 2020/8/11 18:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[setAUthorityUpperCaseForInsert]
    ON [dbo].[Authority]
    AFTER INSERT, UPDATE
    AS
BEGIN
    UPDATE dbo.Authority
    SET AuthorityType = UPPER(AuthorityType)
    WHERE AuthorityID IN (SELECT Authority.AuthorityID FROM inserted)
END
GO
ALTER TABLE [dbo].[Authority] ENABLE TRIGGER [setAUthorityUpperCaseForInsert]
GO
/****** Object:  Trigger [dbo].[generateDefaultAuthorityForNewEmployee]    Script Date: 2020/8/11 18:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[generateDefaultAuthorityForNewEmployee]
    ON [dbo].[HospitalEmployee]
    AFTER INSERT
    AS
BEGIN
    INSERT INTO dbo.Authority (employeeid, authoritytype)
    SELECT i.EmployeeID, (SELECT Authority from dbo.AuthorityType where AuthorityTypeID = 1)
    from inserted i;
     INSERT INTO dbo.Authority (employeeid, authoritytype)
    SELECT i.EmployeeID, (SELECT Authority from dbo.AuthorityType where AuthorityTypeID = 2)
    from inserted i;
END
GO
ALTER TABLE [dbo].[HospitalEmployee] ENABLE TRIGGER [generateDefaultAuthorityForNewEmployee]
GO
/****** Object:  Trigger [dbo].[setStatusUpperCaseInsteadOfInsertUpdate]    Script Date: 2020/8/11 18:26:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[setStatusUpperCaseInsteadOfInsertUpdate]
    ON [dbo].[HospitalEmployee]
    AFTER INSERT, UPDATE
    AS
BEGIN
    UPDATE dbo.HospitalEmployee SET Status = UPPER(Status)
    where EmployeeID in (SELECT HospitalEmployee.EmployeeID from inserted)
END
GO
ALTER TABLE [dbo].[HospitalEmployee] ENABLE TRIGGER [setStatusUpperCaseInsteadOfInsertUpdate]
GO
/****** Object:  Trigger [dbo].[notSellItemandDrugOnce]    Script Date: 2020/8/11 18:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notSellItemandDrugOnce]
    ON [dbo].[MedicalTreatment]
    AFTER INSERT, UPDATE
    AS
BEGIN
    if ( (SELECT ItemID from inserted i) is NOT NULL) AND ( (SELECT DrugID from inserted i) is NOT NULL)
    begin
        ROLLBACK ;
        RAISERROR ('Please put them into two different MedicalTreatment', 16, 1);
    END
END
GO
ALTER TABLE [dbo].[MedicalTreatment] ENABLE TRIGGER [notSellItemandDrugOnce]
GO
/****** Object:  Trigger [dbo].[SellDrugItemINStoreFromPrescription]    Script Date: 2020/8/11 18:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SellDrugItemINStoreFromPrescription]
    ON [dbo].[MedicalTreatment]
    AFTER INSERT 
    AS
BEGIN
    IF ((SELECT ItemID FROM inserted i) IS NOT NULL)
        BEGIN
            DECLARE @itemid int;
            SELECT @itemid = ItemID FROM inserted;
            DECLARE @qs int;
            SELECT @qs = inserted.Quantity FROM inserted;
            DECLARE @qleft int;
            SELECT @qleft = c.ItemQuantity
            FROM dbo.ConsumableItem c
                     INNER JOIN inserted i ON c.ItemID = i.ItemID;
            IF @qs > @qleft
                BEGIN
                    ROLLBACK;
                    RAISERROR ('Not Enough ConsumableItem', 10 ,1)
                END
            ELSE
                BEGIN
                    DECLARE @pricei money;
                    UPDATE dbo.ConsumableItem
                    SET ItemQuantity = ItemQuantity - @qs
                    WHERE ItemID = @itemid;
                END
        END
    ELSE
        IF ((SELECT DrugID FROM inserted i) IS NOT NULL)
            BEGIN
                DECLARE @Drugid int;
                SELECT @Drugid = DrugID FROM inserted;
                DECLARE @qsd int;
                SELECT @qsd = inserted.Quantity FROM inserted;
                DECLARE @qdleft int;
                SELECT @qdleft = d.DrugQuantity
                FROM dbo.Drug d
                         INNER JOIN inserted i ON i.DrugID = d.DrugID;
                IF @qsd > @qdleft
                    BEGIN
                        ROLLBACK;
                        RAISERROR ('Not Enough Drug', 10 ,1)
                    END
                ELSE
                    BEGIN
                        DECLARE @priced money;
                        UPDATE dbo.Drug
                        SET DrugQuantity = DrugQuantity - @qsd
                        WHERE DrugID = @Drugid;
                    END
            END
END
GO
ALTER TABLE [dbo].[MedicalTreatment] ENABLE TRIGGER [SellDrugItemINStoreFromPrescription]
GO
/****** Object:  Trigger [dbo].[SellDrugItemINStoreFromPrescriptionForDelete]    Script Date: 2020/8/11 18:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SellDrugItemINStoreFromPrescriptionForDelete]
    ON [dbo].[MedicalTreatment]
    AFTER DELETE
    AS
BEGIN
    IF ((SELECT ItemID FROM deleted) IS NOT NULL)
        BEGIN
            DECLARE @itemid int;
            SELECT @itemid = ItemID FROM deleted;
            DECLARE @qs int;
            SELECT @qs = deleted.Quantity FROM deleted;
            UPDATE dbo.ConsumableItem SET ItemQuantity = ItemQuantity + @qs;

        END
    ELSE
        IF ((SELECT DrugID FROM deleted) IS NOT NULL)
            BEGIN
                DECLARE @Drugid int;
                SELECT @Drugid = DrugID FROM deleted;
                DECLARE @qsd int;
                SELECT @qsd = deleted.Quantity FROM deleted;
                UPDATE dbo.Drug SET DrugQuantity = DrugQuantity + @qsd;
            END
END
GO
ALTER TABLE [dbo].[MedicalTreatment] ENABLE TRIGGER [SellDrugItemINStoreFromPrescriptionForDelete]
GO
/****** Object:  Trigger [dbo].[SellDrugItemINStoreFromPrescriptionForUpdate]    Script Date: 2020/8/11 18:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SellDrugItemINStoreFromPrescriptionForUpdate]
    ON [dbo].[MedicalTreatment]
    AFTER UPDATE
    AS
BEGIN
	IF (update(ItemID) OR update(DrugID))
        begin
            ROLLBACK;
            RAISERROR('You can''t change this', 10 ,1);
        END
    IF ((SELECT ItemID FROM inserted i) IS NOT NULL)
        BEGIN
            DECLARE @itemid int;
            SELECT @itemid = ItemID FROM inserted;
            DECLARE @qs int;
            SELECT @qs = inserted.Quantity FROM inserted;
            DECLARE @qleft int;
            SELECT @qleft = c.ItemQuantity
            FROM dbo.ConsumableItem c
                     INNER JOIN inserted i ON c.ItemID = i.ItemID;
            DECLARE @delitemq int = 0;
            SELECT @delitemq = d.Quantity
            FROM deleted d
                     INNER JOIN ConsumableItem c ON d.ItemID = c.ItemID;
            IF @qs - @delitemq > @qleft
                BEGIN
                    ROLLBACK;
                    RAISERROR ('Not Enough ConsumableItem', 10 ,1)
                END
            ELSE
                BEGIN

                    UPDATE dbo.ConsumableItem
                    SET ItemQuantity = ItemQuantity - @qs + @delitemq
                    WHERE ItemID = @itemid;
                END
        END
    ELSE
        IF ((SELECT DrugID FROM inserted i) IS NOT NULL)
            BEGIN
                DECLARE @Drugid int;
                SELECT @Drugid = DrugID FROM inserted;
                DECLARE @qsd int;
                SELECT @qsd = inserted.Quantity FROM inserted;
                DECLARE @qdleft int;
                SELECT @qdleft = d.DrugQuantity
                FROM dbo.Drug d
                         INNER JOIN inserted i ON i.DrugID = d.DrugID;
                DECLARE @deldrugq int = 0;
                SELECT @deldrugq = d.Quantity
                FROM deleted d
                         INNER JOIN Drug ON d.DrugID = Drug.DrugID
                IF @qsd - @deldrugq > @qdleft
                    BEGIN
                        ROLLBACK;
                        RAISERROR ('Not Enough Drug', 10 ,1)
                    END
                ELSE
                    BEGIN

                        UPDATE dbo.Drug
                        SET DrugQuantity = DrugQuantity - @qsd + @deldrugq
                        WHERE DrugID = @Drugid;
                    END
            END
END
GO
ALTER TABLE [dbo].[MedicalTreatment] ENABLE TRIGGER [SellDrugItemINStoreFromPrescriptionForUpdate]
GO
/****** Object:  Trigger [dbo].[hasAuthorityToPrescripe]    Script Date: 2020/8/11 18:26:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[hasAuthorityToPrescripe]
    ON [dbo].[Prescription]
    FOR INSERT
    AS
BEGIN
    IF NOT exists(SELECT * FROM dbo.Authority a INNER JOIN inserted i ON a.EmployeeID= i.EmployeeID
    WHERE AuthorityType LIKE 'PRESCRIBE')
    begin
        ROLLBACK;
        RAISERROR('Don''t have [PRESCRIBE] authority', 16, 1);
    END
END
GO
ALTER TABLE [dbo].[Prescription] ENABLE TRIGGER [hasAuthorityToPrescripe]
GO
/****** Object:  Trigger [dbo].[hasAuthorityOfProcurement]    Script Date: 2020/8/11 18:26:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[hasAuthorityOfProcurement]
    ON [dbo].[Procurement]
    FOR INSERT
    AS
BEGIN
    IF NOT EXISTS(SELECT *
                  FROM dbo.Authority a
                           INNER JOIN inserted i ON a.EmployeeID = i.EmployeeID
                  WHERE AuthorityType LIKE 'PROCUREMENT')
        BEGIN
            ROLLBACK;
            RAISERROR ('Don''t have authority of procurement', 16, 1)
        END
END
GO
ALTER TABLE [dbo].[Procurement] ENABLE TRIGGER [hasAuthorityOfProcurement]
GO
/****** Object:  Trigger [dbo].[notBuyItemandDrugOnce]    Script Date: 2020/8/11 18:26:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notBuyItemandDrugOnce]
    ON [dbo].[Procurement]
    AFTER INSERT, UPDATE
    AS
BEGIN
    if ( (SELECT ItemID from inserted i) is NOT NULL) AND ( (SELECT DrugID from inserted i) is NOT NULL)
    begin
        ROLLBACK ;
        RAISERROR ('Please put them into two different procurement', 10, 1);
    END
END
GO
ALTER TABLE [dbo].[Procurement] ENABLE TRIGGER [notBuyItemandDrugOnce]
GO
/****** Object:  Trigger [dbo].[SellDrugINstoreProcurement]    Script Date: 2020/8/11 18:26:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SellDrugINstoreProcurement]
ON [dbo].[Procurement]
AFTER INSERT
AS
BEGIN
	IF((SELECT ItemID FROM inserted i)IS NOT NULL)
	BEGIN 
		DECLARE @itemid int
		SELECT @itemid =ItemID FROM inserted
		DECLARE @afters int, @sleft int, @emp int, @money money
		SELECT @emp=inserted.EmployeeID FROM inserted
		SELECT @afters =inserted.Quantity FROM inserted
		SELECT @sleft= c.ItemQuantity
		FROM dbo.ConsumableItem c
				INNER JOIN inserted i 
				ON c.ItemID =i.ItemID
		PRINT ('Item has Added')
		UPDATE dbo.ConsumableItem SET ItemQuantity= @sleft + @afters
		WHERE ItemID =@itemid
		SELECT @money=PurchasingPrice FROM ConsumableItem WHERE ItemID = @itemid
		insert into FinancialEvent (EmployeeID, MoneyAccountID,Purpose,TransactionFlow, Description) values (@emp,1,'Purchase', @money * @afters, 'expendense of item')
	END
	ELSE
	IF ((SELECT DrugID FROM inserted i) IS NOT NULL)
		BEGIN 
			DECLARE @Drugid int
            SELECT @Drugid = DrugID FROM inserted
            DECLARE @qsd int, @emd int, @money1 money
            SELECT @qsd = inserted.Quantity FROM inserted
			SELECT @emd=inserted.EmployeeID FROM inserted
            DECLARE @qdleft int
            SELECT @qdleft = d.DrugQuantity
			FROM dbo.Drug d
            INNER JOIN inserted i ON i.DrugID = d.DrugID
			PRINT ('Drug has Added')
			UPDATE dbo.Drug SET DrugQuantity = @qdleft + @qsd
			WHERE DrugID =@Drugid
			SELECT @money1=PurchasingPrice FROM Drug WHERE DrugID = @Drugid
			insert into FinancialEvent (EmployeeID, MoneyAccountID,Purpose,TransactionFlow, Description) values (@emd,2,'Purchase', @money1 * @qsd, 'expendense of drug')
			END
END
GO
ALTER TABLE [dbo].[Procurement] ENABLE TRIGGER [SellDrugINstoreProcurement]
GO
/****** Object:  Trigger [dbo].[SellDrugINstoreProcurementUPDATE]    Script Date: 2020/8/11 18:26:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SellDrugINstoreProcurementUPDATE]
ON [dbo].[Procurement]
AFTER UPDATE
AS
BEGIN
 	IF (update(ItemID) OR update(DrugID))
        BEGIN
            ROLLBACK
            RAISERROR('You can''t change this', 10 ,1)
		END
	IF ((SELECT ItemID FROM inserted i) IS NOT NULL)
		BEGIN	
				DECLARE @itemid int
				SELECT @itemid =ItemID FROM inserted
				DECLARE @QS int, @qleft int
				SELECT @QS = inserted.Quantity FROM inserted
				SELECT @qleft = c.ItemQuantity
				FROM dbo.ConsumableItem c
                INNER JOIN inserted i ON c.ItemID = i.ItemID
				DECLARE @delitemq int = 0;
				SELECT @delitemq = d.Quantity
				FROM deleted d
                INNER JOIN ConsumableItem c ON d.ItemID = c.ItemID
				PRINT('Item Quantity has changed')
				Declare @itemq int
				DECLARE @money money
				SELECT @money=PurchasingPrice FROM ConsumableItem WHERE ItemID = @itemid
				UPDATE dbo.ConsumableItem
                SET ItemQuantity = ItemQuantity - @qs + @delitemq
                WHERE ItemID = @itemid

		END
	ELSE
	IF ((SELECT DrugID FROM inserted i) IS NOT NULL)
		BEGIN
				DECLARE @Drugid int;
				SELECT @Drugid = DrugID FROM inserted;
			    DECLARE @qsd int;
			    SELECT @qsd = inserted.Quantity FROM inserted;
				DECLARE @qdleft int;
				SELECT @qdleft = d.DrugQuantity
				FROM dbo.Drug d
                INNER JOIN inserted i ON i.DrugID = d.DrugID;
                DECLARE @deldrugq int = 0;
                SELECT @deldrugq = d.Quantity
                FROM deleted d
                INNER JOIN Drug ON d.DrugID = Drug.DrugID
				PRINT('Drug Quantity has changed')
				UPDATE dbo.Drug
                SET DrugQuantity = DrugQuantity - @qsd + @deldrugq
                WHERE DrugID = @Drugid
				DECLARE @money1 money
				SELECT @money1=PurchasingPrice FROM Drug WHERE DrugID = @Drugid
		END
END
GO
ALTER TABLE [dbo].[Procurement] ENABLE TRIGGER [SellDrugINstoreProcurementUPDATE]
GO
