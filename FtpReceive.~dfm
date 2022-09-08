object Form1: TForm1
  Left = 1246
  Top = 23
  Width = 577
  Height = 313
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 286
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
  end
  object IdFTPServer1: TIdFTPServer
    OnStatus = IdFTPServer1Status
    Bindings = <>
    DefaultPort = 21
    OnConnect = IdFTPServer1Connect
    OnDisconnect = IdFTPServer1Disconnect
    OnException = IdFTPServer1Exception
    OnListenException = IdFTPServer1ListenException
    CommandHandlers = <>
    ExceptionReply.Code = '500'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Greeting.Code = '220'
    Greeting.Text.Strings = (
      'OTT FTP Server ready.')
    MaxConnectionReply.Code = '300'
    MaxConnectionReply.Text.Strings = (
      'Too many connections. Try again later.')
    ReplyTexts = <>
    ReplyUnknownCommand.Code = '500'
    ReplyUnknownCommand.Text.Strings = (
      'Unknown Command')
    OnAfterCommandHandler = IdFTPServer1AfterCommandHandler
    OnBeforeCommandHandler = IdFTPServer1BeforeCommandHandler
    AnonymousAccounts.Strings = (
      'anonymous'
      'ftp'
      'guest')
    UserAccounts = IdUserManager1
    SystemType = 'WIN32'
    OnLoginFailureBanner = IdFTPServer1LoginFailureBanner
    OnAfterUserLogin = IdFTPServer1AfterUserLogin
    OnChangeDirectory = IdFTPServer1ChangeDirectory
    OnGetFileSize = IdFTPServer1GetFileSize
    OnUserLogin = IdFTPServer1UserLogin
    OnRenameFile = IdFTPServer1RenameFile
    OnStoreFile = IdFTPServer1StoreFile
    OnMakeDirectory = IdFTPServer1MakeDirectory
    OnStat = IdFTPServer1Stat
    OnFileExistCheck = IdFTPServer1FileExistCheck
    OnSetATTRIB = IdFTPServer1SetATTRIB
    OnSiteCHMOD = IdFTPServer1SiteCHMOD
    OnSiteCHGRP = IdFTPServer1SiteCHGRP
    SITECommands = <>
    MLSDFacts = []
    OnClientID = IdFTPServer1ClientID
    ReplyUnknownSITCommand.Code = '500'
    ReplyUnknownSITCommand.Text.Strings = (
      'Invalid SITE command.')
    Left = 202
    Top = 48
  end
  object IdUserManager1: TIdUserManager
    Accounts = <
      item
        UserName = 'dmt_ott'
        Password = 'DMT_OTT'
        RealName = 'DM-T Login'
      end>
    Options = [umoCaseSensitiveUsername, umoCaseSensitivePassword]
    Left = 236
    Top = 48
  end
end
