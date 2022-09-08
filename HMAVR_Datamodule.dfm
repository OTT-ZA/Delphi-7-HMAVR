object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 453
  Top = 258
  Height = 329
  Width = 407
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Dynamass\DB\ITCM' +
      'S.mdb;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 38
    Top = 22
  end
  object GenSQL: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 124
    Top = 20
  end
  object qryAlerts: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'SiteID'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end
      item
        Name = 'AlertTime'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '2012-06-25'
      end>
    SQL.Strings = (
      'SELECT * FROM Alerts'
      'WHERE Site_ID=:SiteID'
      'AND Alert_Time>:AlertTime')
    Left = 124
    Top = 78
    object qryAlertsAlert_ID: TAutoIncField
      FieldName = 'Alert_ID'
      ReadOnly = True
    end
    object qryAlertsSite_ID: TIntegerField
      FieldName = 'Site_ID'
    end
    object qryAlertsSeq_No: TIntegerField
      FieldName = 'Seq_No'
    end
    object qryAlertsAlert_Time: TDateTimeField
      FieldName = 'Alert_Time'
    end
    object qryAlertsDirection: TWideStringField
      FieldName = 'Direction'
      Size = 8
    end
    object qryAlertsVehicle_Idx: TIntegerField
      FieldName = 'Vehicle_Idx'
    end
    object qryAlertsWagon_No: TWideStringField
      FieldName = 'Wagon_No'
      Size = 10
    end
    object qryAlertsAlarm_Type: TWordField
      FieldName = 'Alarm_Type'
    end
    object qryAlertsOverload_Value: TSmallintField
      FieldName = 'Overload_Value'
    end
    object qryAlertsUnderload_Value: TSmallintField
      FieldName = 'Underload_Value'
    end
    object qryAlertsAxle_Value: TSmallintField
      FieldName = 'Axle_Value'
    end
    object qryAlertsSkew_Value_Bogie: TSmallintField
      FieldName = 'Skew_Value_Bogie'
    end
    object qryAlertsSkew_Value_Lateral: TSmallintField
      FieldName = 'Skew_Value_Lateral'
    end
    object qryAlertsAxle_Number: TWordField
      FieldName = 'Axle_Number'
    end
    object qryAlertsLoaded_End: TWideStringField
      FieldName = 'Loaded_End'
      Size = 1
    end
    object qryAlertsLoaded_Side: TWideStringField
      FieldName = 'Loaded_Side'
      Size = 1
    end
    object qryAlertsPhoto: TBlobField
      FieldName = 'Photo'
    end
  end
  object qrySites: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT Site_ID, Site_Name FROM Sites'
      'ORDER BY Site_Name ASC')
    Left = 194
    Top = 78
    object qrySitesSite_ID: TAutoIncField
      FieldName = 'Site_ID'
      ReadOnly = True
    end
    object qrySitesSite_Name: TWideStringField
      FieldName = 'Site_Name'
      Size = 50
    end
  end
  object dsSites: TDataSource
    DataSet = qrySites
    Left = 244
    Top = 80
  end
end
