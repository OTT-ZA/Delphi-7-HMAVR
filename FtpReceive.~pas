unit FtpReceive;

interface

uses
  Windows,HMAVR_Var,HMAVR_Main, FC_Common,Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdUserAccounts, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, IdCmdTCPServer,
  IdExplicitTLSClientServerBase, IdFTPServer,
  IdGlobal, IdSocketHandle,
 IdUDPServer,
 IdTrivialFTPServer, IdUDPBase, IdUDPClient,
 IdEchoUDP, IdContext, IdServerIOHandler,
 IdServerIOHandlerSocket, IdServerIOHandlerStack, IdReply;

const
  DATA_ID = $95;
  STX = $02;
  EOT = $04;
  FTP_TIMEOUT = 3000;

type
  TPortArray = Array[0..1] of Word;
  //TResponseStatus = (rspSuccess,rspPending,rspFailure);

  TForm1 = class(TForm)
    Panel1: TPanel;
    IdFTPServer1: TIdFTPServer;
    IdUserManager1: TIdUserManager;
    procedure FormCreate(Sender: TObject);
    procedure IdFTPServer1AfterCommandHandler(ASender: TIdCmdTCPServer;
      AContext: TIdContext);
    procedure IdFTPServer1AfterUserLogin(ASender: TIdFTPServerContext);
    procedure IdFTPServer1BeforeCommandHandler(ASender: TIdCmdTCPServer;
      var AData: String; AContext: TIdContext);
    procedure IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: String);
    procedure IdFTPServer1ClientID(ASender: TIdFTPServerContext;
      const AID: String);
    procedure IdFTPServer1Connect(AContext: TIdContext);
    procedure IdFTPServer1Disconnect(AContext: TIdContext);
    procedure IdFTPServer1Exception(AContext: TIdContext;
      AException: Exception);
    procedure IdFTPServer1FileExistCheck(ASender: TIdFTPServerContext;
      const APathName: String; var VExist: Boolean);
    procedure IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
      const AFilename: String; var VFileSize: Int64);
    procedure IdFTPServer1ListenException(AThread: TIdListenerThread;
      AException: Exception);
    procedure IdFTPServer1LoginFailureBanner(ASender: TIdFTPServerContext;
      AGreeting: TIdReply);
    procedure IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: String);
    procedure IdFTPServer1RenameFile(ASender: TIdFTPServerContext;
      const ARenameFromFile, ARenameToFile: String);
    procedure IdFTPServer1SetATTRIB(ASender: TIdFTPServerContext;
      var VAttr: Cardinal; const AFileName: String; var VAUth: Boolean);
    procedure IdFTPServer1SiteCHGRP(ASender: TIdFTPServerContext;
      var AGroup: String; const AFileName: String; var VAUth: Boolean);
    procedure IdFTPServer1SiteCHMOD(ASender: TIdFTPServerContext;
      var APermissions: Integer; const AFileName: String;
      var VAUth: Boolean);
    procedure IdFTPServer1Stat(ASender: TIdFTPServerContext;
      AStatusInfo: TStrings);
    procedure IdFTPServer1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: String);
    procedure IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
      const AFileName: String; AAppend: Boolean; var VStream: TStream);
    procedure IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
      const AUsername, APassword: String; var AAuthenticated: Boolean);
  private
    { Private declarations }
    DownloadStatus: TResponseStatus;
    Download_Filename: string;
    Closing: Boolean;
    //QueryType : TBridgeQueryType;
    //Status : TCommsState;
    //ResponseStatus : TResponseStatus;
    TX_Packet_Eth : Array[0..1023] of AnsiChar;
    gFTPTime : Cardinal;
    function InsertMAC(var TxtStr : Array of AnsiChar; TargetMAC : AnsiString; Offset,Len : integer) : Boolean;
    function IPCommLogFile : string;

  public
    { Public declarations }
    function DownloadBridgeData_Internal(TargetIP, TargetMAC : AnsiString; Filename : string; zPorts : TPortArray): Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

function TForm1.DownloadBridgeData_Internal(TargetIP,
  TargetMAC: AnsiString; Filename: string; zPorts: TPortArray): Boolean;
var
  native_len,
  tot_len : integer;
  CRC : Word;
  StartTime : Cardinal;

begin
  if frmMain.Status <> steIdle then Exit;
  try
    Result := false;
    Closing := false;
    DownloadStatus := rspFailure;
    Download_Filename := Filename;
    native_len := 7;//7 for MAC
    //Ctrl chars + CRC
    tot_len := 4 + 2 + native_len;

    TX_Packet_Eth[0] := AnsiChar(STX);
    TX_Packet_Eth[1] := AnsiChar(DATA_ID);
    TX_Packet_Eth[2] := #0;//Len
    InsertMAC(TX_Packet_Eth,TargetMAC,3,6);
    TX_Packet_Eth[10] := AnsiChar(0);//CRC16_1
    TX_Packet_Eth[11] := AnsiChar(0);//CRC16_2
    TX_Packet_Eth[12] := AnsiChar(EOT);

    CRC := CalcCrc16(TX_Packet_Eth[3],native_len);
    Move(CRC,TX_Packet_Eth[tot_len-3],2);
    TX_Packet_Eth[tot_len-1] := AnsiChar(EOT);
    //TextMessages_Eth := '';

    try
      IdFTPServer1.Active := true
    except
      AppendToLogWithDate(IPCommLogFile,'Error opening FTP for data receiving');
    end;

    //Uncomment: use your UDP response function
    //SendCommand('',qryData,tot_len,TargetIP,zPorts);
    frmMain.ResponseStatus := rspSuccess;
    if frmMain.ResponseStatus = rspSuccess then
    begin
      try
        try
          frmMain.memInfo.Lines.add('Downloading data ...');
          DownloadStatus := rspPending;
          Application.ProcessMessages;
          StartTime := GetTickCount;
          repeat
            Application.ProcessMessages;
            if Closing then Break;
            Sleep(1);
          until(((GetTickCount-StartTime)>30000) or (DownloadStatus <> rspPending));

          if DownloadStatus = rspPending then
          begin
            frmMain.memInfo.Lines.add('Error downloading data');
          end
          else if DownloadStatus = rspSuccess then
                 frmMain.memInfo.Lines.add('Data downloaded');
          Result := DownloadStatus = rspSuccess;
        except
          MessageDlg('Error in transfer!',mtError,[mbOK],0);
        end;
      finally
        frmMain.Status := steIdle;
        //IdTrivialFTPServer1.Active := false;
        //IdFTPServer1.Active := false;
      end;
    end;
  finally
    IdFTPServer1.Active := false;
    frmMain.Status := steIdle;
    frmMain.QueryType := qryNone;
    TX_Packet_Eth := '';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Closing := false;
end;

function TForm1.InsertMAC(var TxtStr: array of AnsiChar;
  TargetMAC: AnsiString; Offset, Len: integer): Boolean;
var
  i : integer;
begin
  i := 0;
  while i < Length(TargetMAC) do
  begin
    if i > Len then Break;
    TX_Packet_Eth[Offset+i] := TargetMAC[i+1];
    Inc(i);
  end;
  TX_Packet_Eth[Offset+i] := #0;
end;

function TForm1.IPCommLogFile: string;
begin
  Result := IncludeTrailingPathDelimiter(LOG_PATH_DEF) + 'IPComm_' + FormatDateTime('yyyy_mm_dd',Now) + '.log';
end;

procedure TForm1.IdFTPServer1AfterCommandHandler(ASender: TIdCmdTCPServer;
  AContext: TIdContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP After CMD,');
end;

procedure TForm1.IdFTPServer1AfterUserLogin(ASender: TIdFTPServerContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP Logged On,' + ASender.Username + ',');
end;

procedure TForm1.IdFTPServer1BeforeCommandHandler(ASender: TIdCmdTCPServer;
  var AData: String; AContext: TIdContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP B4 CMD,' + AData + ',');
end;

procedure TForm1.IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: String);
var
  LogStr : string;
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  LogStr := 'FTP Change Dir,' + ASender.CurrentDir + ',' + VDirectory + ',';
  ASender.CurrentDir := ReplaceChars(VDirectory);
  VDirectory := ASender.CurrentDir;
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

procedure TForm1.IdFTPServer1ClientID(ASender: TIdFTPServerContext;
  const AID: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Client ID,' + AID + ',');
end;

procedure TForm1.IdFTPServer1Connect(AContext: TIdContext);
var
  LogStr : string;
begin
  //ShowMessage('Connected');
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  LogStr := 'FTP Connect,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

procedure TForm1.IdFTPServer1Disconnect(AContext: TIdContext);
var
  LogStr : string;
begin
  if CheckFileSize(Download_Filename) > 0 then
    DownloadStatus := rspSuccess
  else
    DownloadStatus := rspFailure;

  LogStr := 'FTP Disconnect,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  if DownloadStatus = rspSuccess then
    LogStr := LogStr + 'Transfer Success,'
  else
    LogStr := LogStr + 'Transfer Failure,';
  LogStr := LogStr + Download_Filename + ',';
  //AContext.Binding.DisplayName
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

procedure TForm1.IdFTPServer1Exception(AContext: TIdContext;
  AException: Exception);
var
  LogStr : string;
begin
  //AContext.Binding.
  LogStr := 'FTP Exception,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  LogStr := LogStr + AException.Message + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

procedure TForm1.IdFTPServer1FileExistCheck(ASender: TIdFTPServerContext;
  const APathName: String; var VExist: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP File Exists,' + APathName + ',');
end;

procedure TForm1.IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
  const AFilename: String; var VFileSize: Int64);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP File Size,' + AFilename + ',' + IntToStr(VFileSize) + ',');
end;

procedure TForm1.IdFTPServer1ListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Listen Exception,' + AException.Message + ',');
end;

procedure TForm1.IdFTPServer1LoginFailureBanner(
  ASender: TIdFTPServerContext; AGreeting: TIdReply);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Login Failure,' + ASender.Username);
end;

procedure TForm1.IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Make dir,' + VDirectory + ',');
end;

procedure TForm1.IdFTPServer1RenameFile(ASender: TIdFTPServerContext;
  const ARenameFromFile, ARenameToFile: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Rename file,' + ARenameFromFile + ',' + ARenameToFile + ',');
end;

procedure TForm1.IdFTPServer1SetATTRIB(ASender: TIdFTPServerContext;
  var VAttr: Cardinal; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Set ATTRIB,' + AFileName + ',');
end;

procedure TForm1.IdFTPServer1SiteCHGRP(ASender: TIdFTPServerContext;
  var AGroup: String; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP CHGRP,' + AFileName + ',');
end;

procedure TForm1.IdFTPServer1SiteCHMOD(ASender: TIdFTPServerContext;
  var APermissions: Integer; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP CHMOD,' + AFileName + ',');
end;

procedure TForm1.IdFTPServer1Stat(ASender: TIdFTPServerContext;
  AStatusInfo: TStrings);
var
  LogStr : string;
  i : integer;
begin
  LogStr := 'FTP Stat,';
  for i := 0 to AStatusInfo.Count-1 do
  begin
    LogStr := LogStr + AStatusInfo[i] + ',';
  end;
  AppendToLogWithDate(IPCommLogFile,'FTP Stat,' + LogStr);
end;

procedure TForm1.IdFTPServer1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Status,' + AStatusText + ',');
end;

procedure TForm1.IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
  const AFileName: String; AAppend: Boolean; var VStream: TStream);
var
  LogStr : string;
begin
  gFTPTime := GetTickCount + 10*FTP_TIMEOUT;
  LogStr := 'FTP Store File,' + ASender.CurrentDir + ',' + ASender.HomeDir + ',';
  if not Aappend then
  begin
    LogStr := LogStr + 'Create,';
    if Download_Filename = '' then
    begin
      Download_Filename := 'C:\Dynamass\In\' + FormatDateTime('yyyymmdd_HHnnsszzz', Now) + '.fle';
    end;
    VStream := TFileStream.Create(Download_Filename{ReplaceChars(AFilename)},fmCreate);
  end
  else
  begin
    LogStr := LogStr + 'Append,';
    VStream := TFileStream.Create(Download_Filename{ReplaceChars(AFilename)},fmOpenWrite);
  end;
  LogStr := LogStr + Download_Filename + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

procedure TForm1.IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
  const AUsername, APassword: String; var AAuthenticated: Boolean);
var
  LogStr : string;
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  LogStr := 'FTP Login,';
  if AAuthenticated then
    LogStr := LogStr + 'Authenticated,'
  else
    LogStr := LogStr + 'NOT Authenticated,';
  AppendToLogWithDate(IPCommLogFile,LogStr);
end;

end.
