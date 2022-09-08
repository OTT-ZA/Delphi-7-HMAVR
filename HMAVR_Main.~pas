{Version History
        1.0.0.0 - 30/08/2019
                - First release.
                - Based on ITCMS Emulator, version 1.0.6.8.
        1.0.3.0 - 12/6/2020
                - Add PWM logic and configs
        1.0.4.0 - 01/11/2021
                - Align Interrogation buttons
                - Add confirmations to interrogation buttons
                - Copy 6 bytes for MAC and not just 4 bytes for prev. versions of unit FW
        1.0.5.0 - 10/01/2022 (v1050)
                - Add Reboot cmd + command struct
        1.0.6.0 - 04/05/2022 (v1060)
                - Import and Export of configs to .rax files
        1.0.7.0 - 07/09/2022 (v1070)
                - Add tab for adv settings
                - Add new radar config settings + cmd
}
unit HMAVR_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OoMisc, AdPort, StdCtrls, Spin, jpeg, IdBaseComponent,
  IdComponent, IdUDPBase, IdGlobal, Buttons,
  FC_Common, iNetVar, IdUDPClient, IdEchoUDP, UEditIPAddr, HMAVR_Var,
  Grids_ts, TSGrid, frxpngimage,
  IdSocketHandle,
 IdUDPServer, IdTCPServer,
 IdTrivialFTPServer, IdUserAccounts, IdCustomTCPServer,
 IdExplicitTLSClientServerBase, IdFTPServer,
 IdContext, IdServerIOHandler,
 IdServerIOHandlerSocket, IdServerIOHandlerStack, IdReply,
 IdCmdTCPServer, ComCtrls, ActnList;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    ApdComPort1: TApdComPort;
    TimeoutTimer: TTimer;
    IdUDPServer1: TIdUDPServer;
    IdEchoUDP1: TIdEchoUDP;
    IdUDPServer2: TIdUDPServer;
    tmrClear: TTimer;
    tmrRequestSpeed: TTimer;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    IdUserManager1: TIdUserManager;
    IdFTPServer1: TIdFTPServer;
    ActionList1: TActionList;
    atnShowHidden: TAction;
    StatusBar1: TStatusBar;
    IdUDPServer3: TIdUDPServer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    rgComms: TRadioGroup;
    gpbxSerial: TGroupBox;
    Label1: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    btnRefreshComPorts: TSpeedButton;
    btnCommOpen: TButton;
    btnCommClose: TButton;
    cbxCurrentBaud: TComboBox;
    cbxSerialPort: TComboBox;
    GroupBox1: TGroupBox;
    btnDiscover: TBitBtn;
    gpbxIP: TGroupBox;
    Label2: TLabel;
    lblPCIPAddress: TLabel;
    lblBridgeIPAddress: TLabel;
    cedtIPAddress: CEditIPAddr;
    edtMACAddress: TLabeledEdit;
    btnSetPcIPAsServer: TButton;
    grdDiscovery: TtsGrid;
    grdStatus: TtsGrid;
    Panel2: TPanel;
    Image1: TImage;
    imgDynamass: TImage;
    GroupBox2: TGroupBox;
    lblSpeed: TLabel;
    cbEnableMonitor: TCheckBox;
    gpbxInterrogation: TGroupBox;
    btnConfigure: TBitBtn;
    btnSetRTC: TBitBtn;
    btnStatus: TBitBtn;
    btnGetData: TBitBtn;
    btnViewOld: TBitBtn;
    cbBroadcast: TCheckBox;
    cbOldConfig: TCheckBox;
    btnReboot: TBitBtn;
    GroupBox3: TGroupBox;
    cbForceSpeed: TCheckBox;
    tmrForceSpeed: TTimer;
    btnImport: TBitBtn;
    btnExport: TBitBtn;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    tbAdvanced: TTabSheet;
    gpbxEmulation: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label6: TLabel;
    ceditMyIP: CEditIPAddr;
    ceditGatewayIP: CEditIPAddr;
    ceditServerIP: CEditIPAddr;
    ceditSubIP: CEditIPAddr;
    rbRdr1Inbound: TRadioButton;
    rbRdr2Inbound: TRadioButton;
    GroupBox4: TGroupBox;
    grpPWM: TGroupBox;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label17: TLabel;
    Label14: TLabel;
    seMin: TSpinEdit;
    seStatic: TSpinEdit;
    seMax: TSpinEdit;
    seMinSpeed: TSpinEdit;
    seMaxSpeed: TSpinEdit;
    cbDyn: TCheckBox;
    sePwmInterval: TSpinEdit;
    seOffset: TSpinEdit;
    Label5: TLabel;
    seTrendMS: TSpinEdit;
    Label3: TLabel;
    seAvgMS: TSpinEdit;
    GroupBox5: TGroupBox;
    Label15: TLabel;
    seLoSpeed: TSpinEdit;
    Label16: TLabel;
    seHiSPeed: TSpinEdit;
    rdgTarget: TRadioGroup;
    Label18: TLabel;
    seDetcSens: TSpinEdit;
    Label19: TLabel;
    cbUnits: TComboBox;
    Label20: TLabel;
    seDecDig: TSpinEdit;
    btnHWConfig: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnRefreshComPortsClick(Sender: TObject);
    procedure btnCommOpenClick(Sender: TObject);
    procedure btnCommCloseClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure TimeoutTimerTimer(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure edtMACAddressKeyPress(Sender: TObject; var Key: Char);
    procedure btnSetRTCClick(Sender: TObject);
    procedure IdUDPServer2UDPRead(AThread: TIdUDPListenerThread;
      AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure rgCommsClick(Sender: TObject);
    procedure tmrClearTimer(Sender: TObject);
    procedure tmrRequestSpeedTimer(Sender: TObject);
    procedure btnDataViewClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
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
    procedure btnGetDataClick(Sender: TObject);
    procedure atnShowHiddenExecute(Sender: TObject);
    procedure btnSetPcIPAsServerClick(Sender: TObject);
    procedure btnDiscoverClick(Sender: TObject);
    procedure grdDiscoveryDblClickCell(Sender: TObject; DataCol,
      DataRow: Integer; Pos: TtsClickPosition);
    procedure cbEnableMonitorClick(Sender: TObject);
    procedure cbDynClick(Sender: TObject);
    procedure btnRebootClick(Sender: TObject);
    procedure tmrForceSpeedTimer(Sender: TObject);
    procedure cbForceSpeedClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnHWConfigClick(Sender: TObject);
  private
    { Private declarations }
    Closing : Boolean;
    TextMessages_Eth,
    TextMessages,
    gTargetIP : AnsiString;
    almSequence,
    vehSequence,
    msgSequence,
    dedSequence,
    wmoSequence : Word;
    gFTPTime : Cardinal;
    Download_Filename: string;
    discovery_Cnt : Word;
    
    function OpenSerial(zDisp : Boolean) : Boolean;
    function CloseSerial : Boolean;
    function OpenUDP : Boolean;
    function CloseUDP : Boolean;
    function SendIPCommand(Command: AnsiString; MsgQueryType: TBridgeQueryType;
                           Len: integer; TargetIP: AnsiString): Boolean;
    function SendSerialCommand(Command : AnsiString;MsgQueryType : TBridgeQueryType;
                         cLen : integer): Boolean;
    function CollectInfo : Boolean;
    function PrepareCommand(zCmd, zLen: Byte; zQueryType: TBridgeQueryType; zCmdData, zTargetIP : AnsiString) : Boolean;
    function PrepareResponse(zCmd, zLen: Byte; zQueryType: TBridgeQueryType; zCmdData : AnsiString) : Boolean;
    function ProcessInterrogator(zCmd : Byte; zSerial : Boolean; zPort : Word) : Boolean;
    procedure DisplayStatusResponse(zRadar_Status : TRadar_Status);
    procedure SaveTrainReport(zRadar_Status : TRadar_Status);
    function Check_CRC(TxtMsgs: AnsiString): Boolean;
    function InsertMAC(var TxtStr : Array of AnsiChar; TargetMAC : AnsiString; Offset,Len : integer) : Boolean;
    function IPCommLogFile : string;
    procedure PlotTrace(traceFile: TFilename);
    function ReadConfigFromFile(Datafile: string):Boolean;
    function SaveConfigToFile(Datafile: string):Boolean;
  public
    { Public declarations }
    Status : TCommsState;
    ResponseStatus : TResponseStatus;
    QueryType : TBridgeQueryType;
    function DownloadBridgeData_Internal(TargetIP, TargetMAC : AnsiString): Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  {$ifdef DB_Version}
    HMAVR_Datamodule,
    HMAVR_DataView,
  {$endif}
  HMAVR_About, DateUtils,
  BWL_Trace,Registry;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Closing := false;
  Status := steIdle;
  ResponseStatus := rspSuccess;
  almSequence := 100;
  vehSequence := 0;
  msgSequence := 0;
  dedSequence := 0;
  wmoSequence := 0;
  {$ifdef DB_Version}
    btnDataView.Enabled := true;
  {$endif}
  PageControl1.ActivePageIndex := 0;
  PageControl1.Pages[1].TabVisible := False;
end;


procedure GreyOutGB(GroupBox : TGroupBox);
var IsEnabled : boolean;
Index : integer;
begin
  Isenabled := GroupBox.Enabled;
  for Index := 0 to Groupbox.Controlcount-1 do
    GroupBox.controls[Index].Enabled := Isenabled;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  Host,
  IPAdd,
  Err : AnsiString;
begin

  try
    EnumComPorts(cbxSerialPort.Items);
    cbxSerialPort.ItemIndex := MatchStringListEntry(cbxSerialPort.Items,'COM' + IntToStr(Settings.ComPort),true);
  except
  end;
  case Settings.Baud of
    9600: cbxCurrentBaud.ItemIndex := 0;
    19200: cbxCurrentBaud.ItemIndex := 1;
    38400: cbxCurrentBaud.ItemIndex := 2;
    57600: cbxCurrentBaud.ItemIndex := 3;
    else cbxCurrentBaud.ItemIndex := 3;
  end;
  ApdComPort1.ComNumber := Settings.ComPort;
  ApdComPort1.Baud := Settings.Baud;

  //rgMode.ItemIndex := Settings.Mode;
  //if Settings.IPMode then rgComms.ItemIndex := 0
  //else rgComms.ItemIndex := 1;
  rgCommsClick(Sender);
  //rgModeClick(Sender);
  cedtIPAddress.Text := LongToIPString(Settings.IPAddress);
  edtMACAddress.Text := Trim(UpperCase(Settings.MACAddress));

  //CheckUDPPortRange(Settings.ConfigPorts[0],UDP_DMT_DEF[0]);
  CheckUDPPortRange(Settings.ConfigPorts[1],UDP_SVR_DEF[0]);
  //CheckUDPPortRange(Settings.DataPorts[0],UDP_DMT_DEF[1]);
  CheckUDPPortRange(Settings.DataPorts[1],UDP_SVR_DEF[1]);

  if Settings.Radar1Inbound then
    rbRdr1Inbound.Checked := true
  else
    rbRdr2Inbound.Checked := true;

  if GetIPFromHost(Host,IPAdd,Err) = false then
  begin
    IPAdd := '';
  end;
  if IPAdd <> '' then
  begin
    lblPCIPAddress.Caption := IPAdd;
  end;
  //if Settings.IPMode then
  //  OpenUDP
  //else
  //  OpenSerial(true);
  //{$ifdef DB_Version}
  //  if Settings.Mode = 0 then
  //    tmrPhotoScan.Enabled := true;
  //{$endif}

  lblSpeed.Caption := 'N/A';
  //grpPWM.Enabled := False;
  //GreyOutGB(grpPWM);

end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  //
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Closing := true;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettingstoRegistry;
  Closing := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CloseSerial;
  CloseUDP;
end;

function TfrmMain.OpenSerial(zDisp : Boolean): Boolean;
var
  TmpStr : string;
  TmpPort : integer;
begin
  Result := false;
  if ApdComPort1.Open = true then
  begin
    ApdComPort1.Open := false;
    Sleep(1000);
  end;

  if cbxSerialPort.ItemIndex < 0 then
  begin
    MessageDlg('Please select a Serial Port!',mtError,[mbOK],0);
    Exit;
  end;
  try
    TmpStr := Copy(cbxSerialPort.Text,4,Length(cbxSerialPort.Text)-4+1);
    TmpPort := StrToInt(TmpStr);
  except
    MessageDlg('An error occurred retrieving the Serial Port!',mtError,[mbOK],0);
    Exit;
  end;
  if cbxCurrentBaud.ItemIndex < 0 then
  begin
    MessageDlg('Please select a Baud Rate!',mtError,[mbOK],0);
    Exit;
  end;

  if (Settings.ComPort <> TmpPort) or (StrToInt(cbxCurrentBaud.Text) <> ApdComPort1.Baud) then
  begin
    Settings.ComPort := TmpPort;
    Settings.Baud := StrToInt(cbxCurrentBaud.Text);
    SaveSettingstoRegistry;
  end;

  ApdComPort1.ComNumber := Settings.ComPort;
  ApdComPort1.Baud := Settings.Baud;
  try
    ApdComPort1.Open := true;
    Result := true;
    if zDisp then
//      memInfo.Lines.Add('*** Serial port opened');
  except
//    memInfo.Lines.Add('*** Error opening serial port');
  end;
end;

function TfrmMain.CloseSerial: Boolean;
begin
  Result := false;
  try
    ApdComPort1.Open := false;
    Result := true;
    //memInfo.Lines.Add('*** Serial port closed');
  except
//    memInfo.Lines.Add('*** Error closing serial port');
  end;
end;

function TfrmMain.OpenUDP: Boolean;
var
  //lPort : Word;
  lUDP1, lUDP2 : TIdUDPServer;
  i : integer;
begin
  Result := false;
  IdUDPServer1.Active := false;
  IdUDPServer2.Active := false;
//  IdUDPServer3.Active := false;
//  IdUDPServer4.Active := false;

  //if Settings.Mode = 0 then
  //begin
    IdUDPServer1.DefaultPort := Settings.ConfigPorts[1];
    IdUDPServer2.DefaultPort := Settings.DataPorts[1];
    //lUDP1 := IdUDPServer1; //Config Server
    //lUDP2 := IdUDPServer2; //Data Server
  //end
  //else
  //begin
  //  IdUDPServer3.DefaultPort := Settings.ConfigPorts[0];
  //  IdUDPServer4.DefaultPort := Settings.DataPorts[0];
  //  lUDP1 := IdUDPServer3; //Config Receiver
  //  lUDP2 := IdUDPServer4; //Data ACK Receiver
  //end;

  try


    //if Settings.Mode = 0 then lPort := 22001
    //else lPort := 22000;
    //IdUDPServer1.DefaultPort := lPort;
    //IdUDPServer1.Active := true;
    //for i := 0 to lUDP1.Bindings.Count-1 do lUDP1.Bindings[i].Port := lUDP1.DefaultPort;

    for i := 0 to IdUDPServer1.Bindings.Count-1 do IdUDPServer1.Bindings[i].Port := IdUDPServer1.DefaultPort;

    //test work on dev
    //IdUDPServer1.Binding.Port := Settings.ConfigPorts[1];
    IdUDPServer1.Active := true;
    Result := true;
    //memInfo.Lines.Add('*** UDP port ' + IntToStr(lUDP1.DefaultPort) + ' opened');
  except
//    memInfo.Lines.Add('*** Error opening UDP port ' + IntToStr(lUDP1.DefaultPort));
  end;

  try
    //if Settings.Mode = 0 then lPort := 22006
    //else lPort := 22005;
    //IdUDPServer2.DefaultPort := lPort;


    //test
    //IdUDPServer2.Binding.Port := Settings.DataPorts[1];;
     for i := 0 to IdUDPServer2.Bindings.Count-1 do IdUDPServer2.Bindings[i].Port := IdUDPServer2.DefaultPort;
    IdUDPServer2.Active := true;
    //for i := 0 to lUDP2.Bindings.Count-1 do lUDP2.Bindings[i].Port := lUDP2.DefaultPort;
    //lUDP2.Active := true;
    Result := true;
    //memInfo.Lines.Add('*** UDP port ' + IntToStr(lUDP2.DefaultPort) + ' opened');
  except
//    memInfo.Lines.Add('*** Error opening UDP port ' + IntToStr(lUDP2.DefaultPort));
  end;
end;

function TfrmMain.CloseUDP: Boolean;
begin
  Result := false;
  try
    IdUDPServer1.Active := false;
    //Result := true;memInfo.Lines.Add('*** UDP port ' + IntToStr(IdUDPServer1.DefaultPort) + ' closed');
  except
//    memInfo.Lines.Add('*** Error closing UDP port 22000');
  end;
  try
    IdUDPServer2.Active := false;
    //Result := true;memInfo.Lines.Add('*** UDP port ' + IntToStr(IdUDPServer2.DefaultPort) + ' closed');
  except
//    memInfo.Lines.Add('*** Error closing UDP port 22001');
  end;
end;

procedure TfrmMain.btnRefreshComPortsClick(Sender: TObject);
begin
  EnumComPorts(cbxSerialPort.Items);
  cbxSerialPort.ItemIndex := MatchStringListEntry(cbxSerialPort.Items,'COM' + IntToStr(Settings.ComPort),true);
end;

procedure TfrmMain.btnCommOpenClick(Sender: TObject);
begin
  OpenSerial(true);
end;

procedure TfrmMain.btnCommCloseClick(Sender: TObject);
begin
  CloseSerial;
end;

procedure TfrmMain.Image1Click(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(Self);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TfrmMain.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
var
  i,
  CmdVal : integer;
begin
  TextMessages_Eth := '';
  //STX CMD LEN (LEN2) DATA[1]...DATA[LEN] CRC1 CRC2 EOT
  for i := 1 to Length(AData) do
    TextMessages_Eth := TextMessages_Eth + AnsiChar(AData[i-1]);

  tmrClear.Enabled := false;
  tmrClear.Enabled := true;

  if Length(Adata) > 1 then
    CmdVal := Byte(TextMessages_Eth[2])
  else
    CmdVal := 0;

  try
      ProcessInterrogator(cmdVal,false,ABinding.Port)
  finally
  end;
end;

procedure TfrmMain.IdUDPServer2UDPRead(AThread: TIdUDPListenerThread;
  AData: TIdBytes; ABinding: TIdSocketHandle);
var
  i,
  CmdVal : integer;
  //cLen : integer;
  //CRC, CRC_Calc : Word;
  //TmpStr : AnsiString;

  
begin
  TextMessages_Eth := '';
  //STX CMD LEN (LEN2) DATA[1]...DATA[LEN] CRC1 CRC2 EOT
  for i := 1 to Length(AData) do
    TextMessages_Eth := TextMessages_Eth + AnsiChar(AData[i-1]);

  gTargetIP := ABinding.PeerIP;

  tmrClear.Enabled := false;
  tmrClear.Enabled := true;

  if Length(Adata) > 1 then
    CmdVal := Byte(TextMessages_Eth[2])
  else
    CmdVal := 0;



  try
    //memInfo.Lines.Add(FormatDateTime('HH:nn:ss - ',Now) + ABinding.PeerIP + ': ' + IntToStr(Length(AData)) + ' bytes received (UDP '
    //                  + IntToStr(ABinding.Port) + ')');
      ProcessInterrogator(CmdVal,false,ABinding.Port)
  finally
  end;
end;

{
-Check response to DMT
-Check TFR status request
}

procedure TfrmMain.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
var
  i : integer;
  ch : AnsiChar;
  CmdVal : Byte;
begin
  for i := 1 to Count do
  begin
    ch := (CP as TApdComPort).GetChar;
    TextMessages := TextMessages + ch;
  end;
  tmrClear.Enabled := false;
  tmrClear.Enabled := true;
  //if Length(TextMessages) > 12 then
  //begin
  //  TextMessages := '';
  //  Exit;
  //end;
  if Length(TextMessages) > 1 then
    CmdVal := Byte(TextMessages[2])
  else
    CmdVal := 0;

  if Settings.Mode = 0 then
  begin
    ProcessInterrogator(CmdVal,true,0);
  end
  else
  begin
    //ProcessEmulator(CmdVal,true,'',0);
  end;
end;

function TfrmMain.SendIPCommand(Command: AnsiString;
      MsgQueryType: TBridgeQueryType; Len : integer;
      TargetIP: AnsiString): Boolean;
var
  i : integer;
  SendString,
  //LogStr,
  LogCmd : AnsiString;
  IPPort : integer;
begin
  Result := false;
  if Status <> steIdle then Exit;
  TimeoutTimer.Enabled := false;
  ResponseStatus := rspPending;
  //if not ConnectByPort(Baud_Rate) then Exit;
  TextMessages_Eth := '';
  Status := steBusy;
  //if IdUDPServer1.Active = false then
  //  IdUDPServer1.Active := true;

  TimeoutTimer.Interval := 3000;

  if len > 1 then
    LogCmd := IntToHex(Byte(TX_Packet[1]),2)
  else
    LogCmd := 'null';

  if (TargetIP = '255.255.255.255') or (TargetIP = '') then
  begin
    gTargetIP := ''
  end
  else
  begin
    if HostToIP(TargetIP,gTargetIP) = false then
      gTargetIP := '';
  end;

  //if Settings.Mode = 0 then
  //begin //Interrogation: Default 22000
    IPPort := Settings.ConfigPorts[0];
  //end
  //else
  //begin //Emulation
  //  if MsgQueryType in [qryBLDS_Alert,qryBLDS_Train,qryDED_Alert,qryDMT_Vehicle,qryWIMWIM_Alert] then //Default 22006
  //    IPPort := Settings.DataPorts[1]
  //  else //Default 22001
  //    IPPort := Settings.ConfigPorts[1];
  //end;

  TimeoutTimer.Enabled := true;
  QueryType := MsgQueryType;
  ResponseStatus := rspPending;

  SendString := '';
  //test
  //StatusBar1.SimpleText := IntToStr(len);
  for i := 0 to len-1 do
  begin
    SendString := SendString + TX_Packet[i];

  //  StatusBar1.SimpleText := StatusBar1.SimpleText + '['+ IntToStr(Byte(TX_Packet[i]))+']'
    //memInfo.Lines.Add('['+ IntToStr(Byte(TX_Packet[i]))+']');
  end;

  if (TargetIP = '255.255.255.255') or (TargetIP = '') then
  begin

    IdEchoUDP1.Broadcast(SendString,IPPort);
  end
  else
  begin
//    if Settings.Mode = 0 then
      IdUDPServer1.Send(TargetIP,IPPort,SendString);
//    else
//      IdUDPServer3.Send(TargetIP,IPPort,SendString);
  end;

  while Status <> steIdle do
  begin
    Application.ProcessMessages;
    if Closing then Break;
    if MsgQueryType in [qryDiscover] then
    begin
      ResponseStatus := rspSuccess;
      Status := steIdle;
      Break;
    end;
  end;
  TimeoutTimer.Enabled := false;
  Result := ResponseStatus = rspSuccess;
end;

function TfrmMain.SendSerialCommand(Command : AnsiString;MsgQueryType : TBridgeQueryType;
                               cLen : integer): Boolean;
var
  i: integer;
  //lPortIdx : integer;
begin
  Result := false;
  if Status <> steIdle then Exit;
  //if not DetermineComIdx(cPort,lPortIdx) then Exit;
  TimeoutTimer.Enabled := false;
  ResponseStatus := rspPending;
  //if not ConnectByPort(cPort,cBaud_Rate) then Exit;
  if not OpenSerial(false) then Exit;
  TextMessages := '';
  Status := steBusy;
  ApdComPort1.FlushInBuffer;
  ApdComPort1.FlushOutBuffer;
  TimeoutTimer.Interval := 4000; 
  
  try
    TimeoutTimer.Enabled := true;
    QueryType := MsgQueryType;
    ResponseStatus := rspPending;
    for i := 0 to cLen-1 do
      ApdComPort1.PutChar(AnsiChar(TX_Packet[i]));
    
    while Status <> steIdle do
    begin
      Application.ProcessMessages;
      if Closing then Break;
    end;
  finally
    TimeoutTimer.Enabled := false;
    Result := ResponseStatus = rspSuccess;
  end;
end;

procedure TfrmMain.TimeoutTimerTimer(Sender: TObject);
begin
  TimeoutTimer.Enabled := false;
  Status := steIdle;
  ResponseStatus := rspFailure;
  QueryType := qryNone;
  if Closing then Exit;
end;

procedure TfrmMain.rgModeClick(Sender: TObject);
begin
  //gpbxInterrogation.Enabled := rgMode.ItemIndex = 0;
  //gpbxEmulation.Enabled := rgMode.ItemIndex = 1;
  //EnabledAsParent(gpbxInterrogation);
  //EnabledAsParent(gpbxEmulation);
  //Settings.Mode := rgMode.ItemIndex;
  Settings.IPMode := rgComms.ItemIndex = 0;
  if Settings.IPMode then
  begin
    CloseSerial;
    OpenUDP;
  end
  else
  begin
    CloseUDP;
    OpenSerial(true);
  end;
end;

function TfrmMain.CollectInfo: Boolean;
var
  i,j : integer;
begin
  Result := false;
  //Settings.Mode := rgMode.ItemIndex;
  //if Settings.Mode = 1 then
  begin
    Settings.IPMode := rgComms.ItemIndex = 0;
    if Settings.IPMode then
    begin
      Settings.IPAddress := IPStringToLong(cedtIPAddress.Text);
      Settings.MACAddress := Trim(UpperCase(edtMACAddress.Text));

    end;
  end;
  if Settings.IPMode then
  begin
    if ((IdUDPServer1.Active = false) or (IdUDPServer2.Active = false)) then //or
       //((IdUDPServer3.Active = false) or (IdUDPServer4.Active = false)) then
    begin
      CloseSerial;
      OpenUDP;
    end;
  end
  else if ApdComPort1.Open = false then
       begin
         CloseUDP;
         OpenSerial(true);
       end;

  Settings.Radar1Inbound := rbRdr1Inbound.Checked;
  //1.0.3.0 -cannot configure if IP os 0.0.0.0
  if( (ceditMyIP.Text = '0.0.0.0') or (ceditGatewayIP.Text = '0.0.0.0') or (ceditServerIP.Text = '0.0.0.0')or (ceditSubIP.Text = '0.0.0.0') ) or
     ( (ceditMyIP.Text = '') or (ceditGatewayIP.Text = '') or (ceditServerIP.Text = '')or (ceditSubIP.Text = '') ) then
  begin
    MessageDlg('Please enter valid IP settings !',mtError,mbOKCancel,0);
    Exit;
  end;

  SaveSettingstoRegistry;
  Result := true;
end;

procedure TfrmMain.edtMACAddressKeyPress(Sender: TObject; var Key: Char);
begin
  Key := CheckHexKey(Key);
end;

function TfrmMain.PrepareCommand(zCmd, zLen: Byte; zQueryType: TBridgeQueryType;
                                 zCmdData, zTargetIP : AnsiString): Boolean;
var
  idx,i,
  cLen : integer;
  CRC : Word;
begin
  Result := false;
  TX_Packet[0] := AnsiChar(STX);
  TX_Packet[1] := AnsiChar(zCmd);
  TX_Packet[2] := AnsiChar(zLen);
  idx := 3;

  // if Settings.Mode = 0 then
  //begin
    //Populate MAC in the case of IP
    if (Settings.IPMode) then
    begin
      for i := 1 to Length(Settings.MACAddress) do
      begin
        TX_Packet[idx] := AnsiChar(Settings.MACAddress[i]);
        Inc(idx);
      end;
      TX_Packet[idx] := #0;
      Inc(idx);
      cLen := 7 + zlen;
    end
    else
    begin
      cLen := zlen;
    end;

    //test
    //StatusBar1.SimpleText := '';
   //for i := 0 to cLen-1 do
  //begin
  //  StatusBar1.SimpleText := StatusBar1.SimpleText + '['+ IntToStr(Byte(TX_Packet[i]))+']'

  //end;


  //end
  //else
  //begin
  //  if not (zQueryType in [qryBLDS_Setting,qryDED_Alert,qryStatusRadar,qryWIMWIM_Alert]) then
  //  begin
  //    Move(msgSequence,TX_Packet[idx],2);
  //    cLen := 2 + zlen;
  //    idx := 5;
  //  end
  //  else
  //  begin
  //    cLen := zLen;
  //  end;
  //end;

  //Populate Command Data
  if zLen > 0 then
  begin
    for i := 1 to Length(zCmdData) do
    begin
      TX_Packet[idx] := zCmdData[i];
      Inc(idx);
    end;
  end;

  Move(TX_Packet[3],gCheckData,cLen);
  CRC := 0;
  if cLen > 0 then
    CRC := CalcCrc(gCheckData,cLen);
  Move(CRC,TX_Packet[idx],2);
  Inc(idx,2);
  TX_Packet[idx] := AnsiChar(EOT);
  cLen := cLen + 6; //Control chars, CRC, etc.
  if Settings.IPMode then
  begin
    if zTargetIP = '' then
    begin
      if cbBroadcast.Checked then
        zTargetIP := '255.255.255.255'
      else
        zTargetIP := LongToIPString(Settings.IPAddress);
    end;
    Result := SendIPCommand('',zQueryType,cLen,zTargetIP);
  end
  else
  begin
    Result := SendSerialCommand('',zQueryType,cLen);
  end;
end;

function TfrmMain.PrepareResponse(zCmd, zLen: Byte; zQueryType: TBridgeQueryType; zCmdData : AnsiString): Boolean;
var
  idx,i,
  cLen : integer;
  CRC : Word;
begin
  Result := false;
  TX_Packet[0] := AnsiChar(STX);
  TX_Packet[1] := AnsiChar(zCmd);
  TX_Packet[2] := AnsiChar(zLen);
  idx := 3;
  cLen := zlen;

  if Settings.Mode = 0 then
  begin
    //Populate MAC in the case of IP
    if Settings.IPMode then
    begin
      for i := 1 to Length(Settings.MACAddress) do
      begin
        TX_Packet[idx] := AnsiChar(Settings.MACAddress[i]);
        Inc(idx);
      end;
      TX_Packet[idx] := #0;
      Inc(idx);
      cLen := 7 + zlen;
    end
    else
    begin
      cLen := zlen;
    end;
  end
  else
  begin
    Move(msgSequence,TX_Packet[idx],2);
    cLen := 2 + zlen;
    idx := 5;
  end;

  //Populate Command Data
  if zLen > 0 then
  begin
    for i := 1 to Length(zCmdData) do
    begin
      TX_Packet[idx] := zCmdData[i];
      Inc(idx);
    end;
  end;

  Move(TX_Packet[3],gCheckData,cLen);
  CRC := 0;
  if cLen > 0 then
    CRC := CalcCrc(gCheckData,cLen);
  Move(CRC,TX_Packet[idx],2);
  Inc(idx,2);
  TX_Packet[idx] := AnsiChar(EOT);
  cLen := cLen + 6; //Control chars, CRC, etc.
  if Settings.IPMode then
  begin
    SendIPCommand('',zQueryType,cLen,LongToIPString(Settings.IPAddress));
  end
  else
  begin
    SendSerialCommand('',zQueryType,cLen);
  end;
end;

procedure TfrmMain.btnStatusClick(Sender: TObject);
begin
  try
    if MessageDlg('Request Status?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
    if not CollectInfo then Exit;
    StatusBar1.SimpleText := 'Requesting Status...' ;
    btnStatus.Enabled := false;
    if PrepareCommand(RADAR_STATUS,0,qryStatusRadar,'','') then
      StatusBar1.SimpleText := 'Status Request Successful'
    else
      StatusBar1.SimpleText := 'Status Request Failed !!';
  finally
    btnStatus.Enabled := true;
  end;
end;

procedure TfrmMain.btnSetRTCClick(Sender: TObject);
var
  RTC : Array[0..6] of Word;
  cCmdData : AnsiString;
  i : integer;
begin
  if MessageDlg('Set Time?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  if not CollectInfo then Exit;
  cCmdData := '';
  DecodeDateTime(Now,RTC[0],RTC[1],RTC[2],RTC[3],RTC[4],RTC[5],RTC[6]);//y,m,d,h,n,s,z
  if RTC[0] > 2000 then RTC[0] := RTC[0] - 2000;
  for i := 0 to 5 do
    cCmdData := cCmdData + AnsiChar(Byte(RTC[i]));
  try
    StatusBar1.SimpleText := 'Setting Device Clock...' ;
    btnSetRTC.Enabled := false;
    if PrepareCommand(SET_RTC,6,qryTimeSet,cCmdData,'') then
      StatusBar1.SimpleText := 'Clock Set Successful'
    else
      StatusBar1.SimpleText := 'Clock Set Failed !!';
    

  finally
    btnSetRTC.Enabled := true;
  end;
end;

function TfrmMain.ProcessInterrogator(zCmd: Byte; zSerial : Boolean; zPort : Word): Boolean;
var
  TmpStr : AnsiString;
  Res : integer;
  i, cLen : integer;
  lSeq, CRC : Word;
  //cRadar_Status : TRadar_Status;
  Char_Buffer : Array[0..31] of byte;
  //lCmd : Byte;
begin
  Result := false;
  Res := 0;
  if zSerial = false then TextMessages := TextMessages_Eth;
  TmpStr := TmpStr + FormatDateTime('HH:nn:ss - ',Now) + IntToStr(Length(TextMessages)) + ' bytes received ';
  if zSerial then TmpStr := TmpStr + '(serial)'
  else TmpStr := TmpStr + '(UDP ' + IntToStr(zPort) + ')';
//  memInfo.Lines.Add(TmpStr);
  if zSerial then
  begin
    if Length(TextMessages) < 6 then Exit;
  end
  else
  begin
    TextMessages := TextMessages_Eth;
    if Length(TextMessages) < 6 then Exit;
  end;
  try
    if Settings.Mode = 0 then
    begin
      case zCmd of
        SPEED:
          begin
            if Length(TextMessages) <> 8 then
            begin
              Exit;
            end;

            if Check_CRC(TextMessages) then
            begin
              Move(TextMessages[4],Speed_Reading,sizeof(Speed_Reading));

              lblSpeed.Caption := FloatToStr(Speed_Reading.CurrentSpeed/100)+ ' km/h';

              ResponseStatus := rspSuccess;
              Res := 0;
              tmrClear.Enabled := false;
            end;
            Status := steIdle;
            TextMessages := '';
          end;
        SPEED_SET:
          begin
            if Length(TextMessages) <> 7 then
            begin
              Exit;
            end;

            if Check_CRC(TextMessages) then
            begin
              if TextMessages[4] = #1 then
                ResponseStatus := rspSuccess
              else
                ResponseStatus := rspFailure;
              Res := 0;
              tmrClear.Enabled := false;
            end;
            Status := steIdle;
            TextMessages := '';
          end;
        SET_RTC:
          begin
            if Length(TextMessages) <> 7 then
            begin
              Exit;
            end;

            if Check_CRC(TextMessages) then
            begin
              if TextMessages[4] = #1 then
                ResponseStatus := rspSuccess
              else
                ResponseStatus := rspFailure;
              Res := 0;
              tmrClear.Enabled := false;
            end;
            Status := steIdle;
            TextMessages := '';
          end;
        RADAR_STATUS:
          begin
            if Length(TextMessages) <> 66 then
            begin
              Exit;
            end;

            if Check_CRC(TextMessages) then
            begin
              Res := 0;
              tmrClear.Enabled := false;
              Move(TextMessages[4],RadarStatus,sizeof(RadarStatus));
              grdStatus.Cell[ 2,1] := DateTimeToStr(Now);
              grdStatus.Cell[ 2,2] := DateTimeToStr(UnixToDateTime(RadarStatus.last_train));
              grdStatus.Cell[ 2,3] := DateTimeToStr(UnixToDateTime(RadarStatus.last_train_on));
//              grdStatus.Cell[ 2,1] := FormatDateTime('yyyy/mm/dd HH:nn:ss',Now);
//              grdStatus.Cell[ 2,2] := FormatDateTime('yyyy/mm/dd HH:nn:ss',UnixToDateTime(RadarStatus.last_train));
//              grdStatus.Cell[ 2,3] := FormatDateTime('yyyy/mm/dd HH:nn:ss',UnixToDateTime(RadarStatus.last_train_on));
              if RadarStatus.train_pres = 0 then
                grdStatus.Cell[ 2,4] :=  'OFF'
              else
                grdStatus.Cell[ 2,4] :=  'ON';
              grdStatus.Cell[ 2,5] := RadarStatus.train_count;
              if RadarStatus.Config_OK = 0 then
                grdStatus.Cell[ 2,6] := 'CHECK'
              else
                grdStatus.Cell[ 2,6] := 'OK';
              if RadarStatus.Radar_OK = 0 then
                grdStatus.Cell[ 2,7] := 'CHECK'
              else
                grdStatus.Cell[ 2,7] := 'OK';
              grdStatus.Cell[ 2,8] := ''+RadarStatus.firmware;
              if RadarStatus.RCM_type = 0 then
                grdStatus.Cell[ 2,9] := 'RCM4000A'
              else if RadarStatus.RCM_type = 1 then
                grdStatus.Cell[ 2,9] := 'RCM4100'
              else if RadarStatus.RCM_type = 2 then
                grdStatus.Cell[ 2,9] := 'RCM4200'
              else if RadarStatus.RCM_type = 3 then
                grdStatus.Cell[ 2,9] := 'RCM4210'
              else
                grdStatus.Cell[ 2,9] := 'UNKNOWN';
              grdStatus.Cell[ 2,10] := RadarStatus.options;

              ResponseStatus := rspSuccess;
            end;
            Delete(TextMessages,1,66);

            Status := steIdle;
          end;
        DISCOVER:
          begin
            if Check_CRC(TextMessages) then
            begin
              if Length(TextMessages) = 35 then //disc.settings is returend as disc settings //35 then
              begin
                //copy inc. string to old struct
                Move(TextMessages[4],Discovery_Settings_Group.units[discovery_Cnt],sizeof(Discovery_Settings));

                //move data from old struct(Discovery_Settings_Group) to new struct (Discovery_Settings_Config_Group)
                Discovery_Settings_Config_Group.units[discovery_Cnt].My_IP := Discovery_Settings_Group.units[discovery_Cnt].My_IP;
                Discovery_Settings_Config_Group.units[discovery_Cnt].My_GTW := Discovery_Settings_Group.units[discovery_Cnt].My_GTW;
                Discovery_Settings_Config_Group.units[discovery_Cnt].My_SNM := Discovery_Settings_Group.units[discovery_Cnt].My_SNM;
                Discovery_Settings_Config_Group.units[discovery_Cnt].My_ServerIP := Discovery_Settings_Group.units[discovery_Cnt].My_ServerIP;
                Discovery_Settings_Config_Group.units[discovery_Cnt].A_is_IN := Discovery_Settings_Group.units[discovery_Cnt].A_is_IN;
                //Discovery_Settings_Config_Group.units[discovery_Cnt].CRC16 := Discovery_Settings_Group.units[discovery_Cnt].CRC16;

                //Discovery_Settings_Config_Group.units[discovery_Cnt].Version[0] := Discovery_Settings_Group.units[discovery_Cnt].Version[0];
                Move(Discovery_Settings_Group.units[discovery_Cnt].Version[0],Discovery_Settings_Config_Group.units[discovery_Cnt].Version[0],4);

                //Discovery_Settings_Config_Group.units[discovery_Cnt].MAC_Add := Discovery_Settings_Group.units[discovery_Cnt].MAC_Add;
                Move(Discovery_Settings_Group.units[discovery_Cnt].MAC_Add[0],Discovery_Settings_Config_Group.units[discovery_Cnt].MAC_Add[0],6);

                Inc(discovery_Cnt);
                grdDiscovery.Cell[2,discovery_Cnt] := LongToIPString(Discovery_Settings_Config_Group.units[discovery_Cnt-1].My_IP);
                grdDiscovery.Cell[3,discovery_Cnt] := Trim(UpperCase(Discovery_Settings_Config_Group.units[discovery_Cnt-1].MAC_Add));
                Delete(TextMessages,1,34);
              end
              else //length is not original len, so must be new type, so check version to determine what to do
              begin
                TmpStr := Copy(TextMessages,40,4);

                if(TmpStr = '100D') then
                begin
                  Move(TextMessages[4],Discovery_Settings_Config_Group.units[discovery_Cnt],sizeof(TRadar_Config));

                  Inc(discovery_Cnt);
                  grdDiscovery.Cell[2,discovery_Cnt] := LongToIPString(Discovery_Settings_Config_Group.units[discovery_Cnt-1].My_IP);
                  grdDiscovery.Cell[3,discovery_Cnt] := Trim(UpperCase(Discovery_Settings_Config_Group.units[discovery_Cnt-1].MAC_Add));

                  Delete(TextMessages,1,sizeof(TextMessages)-1);
                end
                else //any other version// should not run unless new version e,f,g.....was not specified above
                begin
                  Move(TextMessages[4],Discovery_Settings_Config_Group.units[discovery_Cnt],sizeof(TRadar_Config));

                  Inc(discovery_Cnt);
                  grdDiscovery.Cell[2,discovery_Cnt] := LongToIPString(Discovery_Settings_Config_Group.units[discovery_Cnt-1].My_IP);
                  grdDiscovery.Cell[3,discovery_Cnt] := Trim(UpperCase(Discovery_Settings_Config_Group.units[discovery_Cnt-1].MAC_Add));

                  Delete(TextMessages,1,sizeof(TextMessages)-1);
                end;

              end;
            end;
            Status := steIdle;
          end;
        CONFIG:
          begin
//            memInfo.Lines.Add('   ' + IntToHex(zCmd,2) + 'h - Config Data');
            if zCmd <> CONFIG  then
            begin
              Exit;
            end;
            ResponseStatus := rspSuccess;
            Status := steIdle;
            TextMessages := '';
          end;
        HW_CONFIG: //V1070 Hardware config resp
          begin
            if zCmd <> HW_CONFIG  then
            begin
              Exit;
            end;
            ResponseStatus := rspSuccess;
            Status := steIdle;
            TextMessages := '';
          end;
        DATA_ID:
          begin
            if zCmd <> DATA_ID  then
            begin
              Exit;
            end;
            if TextMessages[4] = #1 then
            begin
              ResponseStatus := rspSuccess;
//              memInfo.Lines.Add(' Data Available ');

            end
            else
            begin
              ResponseStatus := rspFailure;
//              memInfo.Lines.Add(' No Data Available');

            end;
            Status := steIdle;

            TextMessages := '';
          end;
        COMMAND:
          begin
            if zCmd <> COMMAND  then
            begin
              Exit;
            end;
            ResponseStatus := rspSuccess;
            Status := steIdle;
            TextMessages := '';
          end;
        else
          begin
//            memInfo.Lines.Add('   ' + IntToHex(zCmd,2) + 'h - Unknown command');
            Status := steIdle;
            Exit;
          end;
      end;
    end
    else
    begin
      Res := 0;
    end;
  finally
    if Res = 1 then
    begin
      Move(lSeq,Char_Buffer[0],2);//Seq no
      Char_Buffer[2] := Res;
      CRC := CalcCrc(Char_Buffer,3);
      Char_Buffer[0] := 2;//STX
      Char_Buffer[1] := zCmd;//DATA_ID;
      Char_Buffer[2] := 3;//Length
      Move(lSeq,Char_Buffer[3],2);//Seq no
      Char_Buffer[5] := Res;
      Move(CRC,Char_Buffer[6],2);//CRC
      Char_Buffer[8] := 3;//EOT
      TmpStr := '';
      for i := 0 to 8 do
        TmpStr := TmpStr + AnsiChar(Char_Buffer[i]);
      if zSerial then
        ApdComPort1.PutString(TmpStr)
      else
      begin
        IdUDPServer2.Send(gTargetIP,Settings.DataPorts[0],TmpStr); //Default 22005
        //IdUDPServer2.Send(gTargetIP,Settings.DataPorts[0],TmpStr); //Default 22005
      end;
    end;

  end;
end;

procedure TfrmMain.DisplayStatusResponse(zRadar_Status: TRadar_Status);
var
  TmpStr : AnsiString;
  //i : integer;
  CRC : Word;
begin
//  memInfo.Lines.Add('    Status Contents:');
  Move(zRadar_Status,gCheckData,SizeOf(zRadar_Status)-2);
  CRC := CalcCrc(gCheckData,SizeOf(zRadar_Status)-2);
  if CRC = zRadar_Status.CRC16 then
  begin
    with zRadar_Status do
    begin
      TmpStr := TmpStr + ' (Status Report)';
//      memInfo.Lines.Add(TmpStr);
//      memInfo.Lines.Add('       Site: ' + AnsiString(SiteID));
      {TmpStr := FormatFloat('0000',Byte(rtc.tm_year) + 2000) + '/';
      TmpStr := TmpStr + FormatFloat('00',Byte(rtc.tm_mon)) + '/';
      TmpStr := TmpStr + FormatFloat('00',Byte(rtc.tm_mday)) + ' ';
      TmpStr := TmpStr + FormatFloat('00',Byte(rtc.tm_hour)) + ':';
      TmpStr := TmpStr + FormatFloat('00',Byte(rtc.tm_min)) + ':';
      TmpStr := TmpStr + FormatFloat('00',Byte(rtc.tm_sec)) + ' ';}
//      memInfo.Lines.Add('       RTC: ' + TmpStr);
      if train_count = 0 then
//        memInfo.Lines.Add('       Data in Mem:  No')
      else
//        memInfo.Lines.Add('       Data in Mem:  Yes');
//      memInfo.Lines.Add('       Vehicles: ' + IntToStr(train_count));
    end;
  end
//  else memInfo.Lines.Add('    Status CRC Error');
end;

procedure TfrmMain.SaveTrainReport(zRadar_Status : TRadar_Status);
var
  fs : TFileStream;
  fileName : AnsiString;
  theDate : TDateTime;
begin
//  theDate := EncodeDateTime(zRadar_Status.rtc.tm_year,zRadar_Status.rtc.tm_mon,zRadar_Status.rtc.tm_mday,
//                            zRadar_Status.rtc.tm_hour,zRadar_Status.rtc.tm_min,zRadar_Status.rtc.tm_sec,0);
  fileName := DATA_PATH_DEF + zRadar_Status.SiteID + '_';
  fileName := fileName + FormatDateTime('yymmdd_HHnnss',theDate) + '.bded';
  try
    fs := TFileStream.Create(fileName,fmCreate or fmShareDenyWrite);
    fs.WriteBuffer(zRadar_Status,SizeOf(zRadar_Status));
  finally
    fs.Free;
  end;
end;

function TfrmMain.Check_CRC(TxtMsgs : AnsiString) : Boolean;
var
  cLen: integer;
  //idx : integer;
  CRC,
  CRC_Calc : Word;
begin
  Result := false;
  cLen := Length(TxtMsgs);
  Move(TxtMsgs[4],gCheckData,cLen-3-3);//First 3 chars, 2 CRC chars and EOM
  CRC_Calc := CalcCrc(gCheckData,cLen-3-3);
  Move(TxtMsgs[cLen-2],CRC,SizeOf(CRC));
  if CRC = CRC_Calc then
  begin
    Result := true;
//    memInfo.Lines.Add('   CRC OK');
  end
  else
  begin
//    memInfo.Lines.Add('   CRC error');
  end;
end;


procedure TfrmMain.rgCommsClick(Sender: TObject);
begin
  gpbxIP.Enabled := rgComms.ItemIndex = 0;
  gpbxSerial.Enabled := rgComms.ItemIndex = 1;
  EnabledAsParent(gpbxIP);
  EnabledAsParent(gpbxSerial);
  //Settings.Mode := rgMode.ItemIndex;
  Settings.IPMode := rgComms.ItemIndex = 0;
  //if not CollectInfo then Exit;
  if Settings.IPMode then
  begin
    CloseSerial;
    OpenUDP;
  end
  else
  begin
    CloseUDP;
    OpenSerial(true);
  end;
end;

procedure TfrmMain.tmrClearTimer(Sender: TObject);
begin
  tmrClear.Enabled := false;
  TextMessages_Eth := '';
  TextMessages := '';
end;


procedure TfrmMain.tmrRequestSpeedTimer(Sender: TObject);
begin
  tmrRequestSpeed.Enabled := false;

  StatusBar1.SimpleText := 'Requesting Speed...' ;
  if PrepareCommand(SPEED,0,qryStatusRadar,'','') then
    StatusBar1.SimpleText := 'Successful'
  else
    StatusBar1.SimpleText := 'Speed Request Failed !!';

  tmrRequestSpeed.Enabled := cbEnableMonitor.Checked = true;
  if cbEnableMonitor.Checked = false then
    lblSpeed.Caption := 'N/A';
end;

procedure TfrmMain.btnDataViewClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := DATA_PATH_DEF;
  if not OpenDialog1.Execute then Exit;
  PlotTrace(OpenDialog1.FileName);
end;


procedure TfrmMain.btnConfigClick(Sender: TObject);
var
  TmpStr : AnsiString;
  radarConfig : TRadar_Config;
  radarConfig_V100 : TRadar_Config_V100;
  i : integer;
  //myDate : TDateTime;
  //myHour, myMin, mySec, myMilli : Word;
begin
  if MessageDlg('Send Configuration?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;

  if not CollectInfo then Exit;

  radarConfig.memPosiAdd := 0;
  radarConfig.memPosiStart := 0;
  radarConfig.TrainCount := 0;
  radarConfig.Baud_Rate := 9600;
  radarConfig.Save_time_offset := seAvgMS.Value;
  radarConfig.Trend_tim_offset := seTrendMS.Value;
  if rbRdr1Inbound.Checked then
    radarConfig.A_is_IN := 1
  else
    radarConfig.A_is_IN := 0;

  radarConfig.Config_OK := 0;//10 to reset trains
  radarConfig.UDP_Ports_Local[0] := Settings.ConfigPorts[0];
  radarConfig.UDP_Ports_Local[1] := Settings.DataPorts[0];
  radarConfig.UDP_Ports_Remote[0] := Settings.ConfigPorts[1];
  radarConfig.UDP_Ports_Remote[1] := Settings.DataPorts[1];
  radarConfig.targetIP := IPStringToLong(ceditServerIP.Text);
  radarConfig.Version[0] := '0';
  radarConfig.SiteID[0] := 'H';
  radarConfig.SiteID[1] := 'M';
  radarConfig.SiteID[2] := 'A';
  radarConfig.SiteID[3] := 'V';
  radarConfig.SiteID[4] := 'R';
  radarConfig.SiteID[5] := #0;

  radarConfig.acq_rate := 750;
  radarConfig.My_IP := IPStringToLong(ceditMyIP.Text);
  radarConfig.My_GTW := IPStringToLong(ceditGatewayIP.Text);
  radarConfig.My_SNM := IPStringToLong(ceditSubIP.Text);
  radarConfig.My_ServerIP := IPStringToLong(ceditServerIP.Text);
  radarConfig.last_train :=0;
  radarConfig.last_train_on :=0;
  radarConfig.power_time := 0;
  radarConfig.power_status := 0;
  radarConfig.power_db_pos := 0;
  radarConfig.power_db_cnt := 0;
  radarConfig.power_debounce := 0;
  //radarConfig.error_code := 5;
  radarConfig.tmzone := 2;

  //1.0.3.0 populate config with pwm values
  radarConfig.PWM_time_offset := sePwmInterval.Value;
  //ch1
  if(cbDyn.Checked) then
    radarConfig.PWM_Dynamic := 1
  else
    radarConfig.PWM_Dynamic := 0;

  radarConfig.PWM_I_min := seMin.Value*1000;
  radarConfig.PWM_S_static := seStatic.Value;
  radarConfig.PWM_I_max := seMax.Value*1000;
  radarConfig.PWM_S_min := seMinSpeed.Value*1000;
  radarConfig.PWM_S_max := seMaxSpeed.Value*1000;
  radarConfig.PWM_Offset := seOffset.Value;

  for i := 0 to (sizeof(radarConfig.dummy)-1) do
    radarConfig.dummy[i] := '0';



  radarConfig.CRC16 := calcCrc16(radarConfig,SizeOf(radarConfig)-2);


  TmpStr := '';
  Move(radarConfig,gCheckData,SizeOf(radarConfig));
  for i := 0 to SizeOf(radarConfig)-1 do
    TmpStr := TmpStr + AnsiChar(gCheckData[i]);

  StatusBar1.SimpleText := 'Sending Device Configuration...' ;
  btnConfigure.Enabled := False;
  if PrepareCommand(CONFIG,SizeOf(radarConfig),qryConfig,TmpStr,'') then
    StatusBar1.SimpleText := 'Configuration Successful'
  else
    StatusBar1.SimpleText := 'Configuration Failed !!';

  if cbOldConfig.Checked then
  begin
    if MessageDlg('Send Old Configuration?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
     radarConfig_V100.memPosiAdd := 0;
     radarConfig_V100.memPosiStart := 0;
     radarConfig_V100.TrainCount := 0;
     radarConfig_V100.Baud_Rate := 9600;
     radarConfig_V100.Save_time_offset := seAvgMS.Value;
     radarConfig_V100.Trend_tim_offset := seTrendMS.Value;
     if rbRdr1Inbound.Checked then
       radarConfig_V100.A_is_IN := 1
     else
       radarConfig_V100.A_is_IN := 0;

     radarConfig_V100.Config_OK := 0;//10 to reset trains
     radarConfig_V100.UDP_Ports_Local[0] := Settings.ConfigPorts[0];
     radarConfig_V100.UDP_Ports_Local[1] := Settings.DataPorts[0];
     radarConfig_V100.UDP_Ports_Remote[0] := Settings.ConfigPorts[1];
     radarConfig_V100.UDP_Ports_Remote[1] := Settings.DataPorts[1];
     radarConfig_V100.targetIP := IPStringToLong(ceditServerIP.Text);
     radarConfig_V100.Version[0] := '0';
     radarConfig_V100.SiteID[0] := 'H';
     radarConfig_V100.SiteID[1] := 'M';
     radarConfig_V100.SiteID[2] := 'A';
     radarConfig_V100.SiteID[3] := 'V';
     radarConfig_V100.SiteID[4] := 'R';
     radarConfig_V100.SiteID[5] := #0;

     radarConfig_V100.acq_rate := 750;
     radarConfig_V100.My_IP := IPStringToLong(ceditMyIP.Text);
     radarConfig_V100.My_GTW := IPStringToLong(ceditGatewayIP.Text);
     radarConfig_V100.My_SNM := IPStringToLong(ceditSubIP.Text);
     radarConfig_V100.My_ServerIP := IPStringToLong(ceditServerIP.Text);
     radarConfig_V100.last_train :=0;
     radarConfig_V100.last_train_on :=0;
     radarConfig_V100.power_time := 0;
     radarConfig_V100.power_status := 0;
     radarConfig_V100.power_db_pos := 0;
     radarConfig_V100.power_db_cnt := 0;
     radarConfig_V100.power_debounce := 0;
     radarConfig_V100.error_code := 5;
     radarConfig_V100.tmzone := 2;

     TmpStr := '';
     Move(radarConfig_V100,gCheckData,SizeOf(radarConfig_V100));
     for i := 0 to SizeOf(radarConfig_V100)-1 do
       TmpStr := TmpStr + AnsiChar(gCheckData[i]);

     StatusBar1.SimpleText := 'Sending OLD Device Configuration...' ;
     btnConfigure.Enabled := False;
     if PrepareCommand(CONFIG,SizeOf(radarConfig_V100),qryConfig,TmpStr,'') then
       StatusBar1.SimpleText := 'Configuration Successful'
     else
       StatusBar1.SimpleText := 'Configuration Failed !!';
    end;
  end;
  cbOldConfig.Checked := False;
  btnConfigure.Enabled := True;
end;

//////////////////////////////////////////
//////////////////  FTP///////////////////
function TfrmMain.InsertMAC(var TxtStr: array of AnsiChar;
  TargetMAC: AnsiString; Offset, Len: integer): Boolean;
var
  i : integer;
begin
  i := 0;
  while i < Length(TargetMAC) do
  begin
    if i > Len then Break;
    TX_Packet[Offset+i] := TargetMAC[i+1];
    Inc(i);
  end;
  TX_Packet[Offset+i] := #0;
end;

function TfrmMain.IPCommLogFile: string;
begin
  Result := IncludeTrailingPathDelimiter(LOG_PATH_DEF) + 'IPComm_' + FormatDateTime('yyyy_mm_dd',Now) + '.log';
end;

procedure TfrmMain.IdFTPServer1AfterCommandHandler(ASender: TIdCmdTCPServer;
  AContext: TIdContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP After CMD,');
  //memInfo.Lines.add( 'FTP After CMD,');
end;

procedure TfrmMain.IdFTPServer1AfterUserLogin(ASender: TIdFTPServerContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP Logged On,' + ASender.Username + ',');
  //memInfo.Lines.add('FTP Logged On,' + ASender.Username + ',');
end;

procedure TfrmMain.IdFTPServer1BeforeCommandHandler(ASender: TIdCmdTCPServer;
  var AData: String; AContext: TIdContext);
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  AppendToLogWithDate(IPCommLogFile,'FTP B4 CMD,' + AData + ',');
  //memInfo.Lines.add('FTP B4 CMD,' + AData + ',');
end;

procedure TfrmMain.IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: String);
var
  LogStr : string;
begin
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  LogStr := 'FTP Change Dir,' + ASender.CurrentDir + ',' + VDirectory + ',';
  ASender.CurrentDir := ReplaceChars(VDirectory);
  VDirectory := ASender.CurrentDir;
  AppendToLogWithDate(IPCommLogFile,LogStr);
  //memInfo.Lines.add(LogStr);
end;

procedure TfrmMain.IdFTPServer1ClientID(ASender: TIdFTPServerContext;
  const AID: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Client ID,' + AID + ',');
  //memInfo.Lines.add('FTP Client ID,' + AID + ',');
end;

procedure TfrmMain.IdFTPServer1Connect(AContext: TIdContext);
var
  LogStr : string;
begin
  //ShowMessage('Connected');
  gFTPTime := GetTickCount + FTP_TIMEOUT;
  LogStr := 'FTP Connect,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
  //memInfo.Lines.add(LogStr);
end;

procedure TfrmMain.IdFTPServer1Disconnect(AContext: TIdContext);
var
  LogStr : string;
begin
  if CheckFileSize(Download_Filename) > 0 then
    ResponseStatus := rspSuccess
  else
    ResponseStatus := rspFailure;

  LogStr := 'FTP Disconnect,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  if ResponseStatus = rspSuccess then
    LogStr := LogStr + 'Transfer Success,'
  else
    LogStr := LogStr + 'Transfer Failure,';
  LogStr := LogStr + Download_Filename + ',';
  //AContext.Binding.DisplayName
  AppendToLogWithDate(IPCommLogFile,LogStr);

end;

procedure TfrmMain.IdFTPServer1Exception(AContext: TIdContext;
  AException: Exception);
var
  LogStr : string;
begin
  //AContext.Binding.
  LogStr := 'FTP Exception,' + AContext.Binding.PeerIP + ',' + IntToStr(AContext.Binding.PeerPort) + ',';
  LogStr := LogStr + AException.Message + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
  //memInfo.Lines.add(LogStr);
end;

procedure TfrmMain.IdFTPServer1FileExistCheck(ASender: TIdFTPServerContext;
  const APathName: String; var VExist: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP File Exists,' + APathName + ',');
//  memInfo.Lines.add('FTP File Exists,' + APathName + ',');
end;

procedure TfrmMain.IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
  const AFilename: String; var VFileSize: Int64);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP File Size,' + AFilename + ',' + IntToStr(VFileSize) + ',');
  //memInfo.Lines.add('FTP File Size,' + AFilename + ',' + IntToStr(VFileSize) + ',');
end;

procedure TfrmMain.IdFTPServer1ListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Listen Exception,' + AException.Message + ',');
  //memInfo.Lines.add('FTP Listen Exception,' + AException.Message + ',');
end;

procedure TfrmMain.IdFTPServer1LoginFailureBanner(
  ASender: TIdFTPServerContext; AGreeting: TIdReply);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Login Failure,' + ASender.Username);
  //memInfo.Lines.add('FTP Login Failure,' + ASender.Username);
end;

procedure TfrmMain.IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Make dir,' + VDirectory + ',');
  //memInfo.Lines.add('FTP Make dir,' + VDirectory + ',');
end;

procedure TfrmMain.IdFTPServer1RenameFile(ASender: TIdFTPServerContext;
  const ARenameFromFile, ARenameToFile: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Rename file,' + ARenameFromFile + ',' + ARenameToFile + ',');
  //memInfo.Lines.add('FTP Rename file,' + ARenameFromFile + ',' + ARenameToFile + ',');
end;

procedure TfrmMain.IdFTPServer1SetATTRIB(ASender: TIdFTPServerContext;
  var VAttr: Cardinal; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Set ATTRIB,' + AFileName + ',');
  //memInfo.Lines.add('FTP Set ATTRIB,' + AFileName + ',');
end;

procedure TfrmMain.IdFTPServer1SiteCHGRP(ASender: TIdFTPServerContext;
  var AGroup: String; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP CHGRP,' + AFileName + ',');
  //memInfo.Lines.add('FTP CHGRP,' + AFileName + ',');
end;

procedure TfrmMain.IdFTPServer1SiteCHMOD(ASender: TIdFTPServerContext;
  var APermissions: Integer; const AFileName: String; var VAUth: Boolean);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP CHMOD,' + AFileName + ',');
  //memInfo.Lines.add('FTP CHMOD,' + AFileName + ',');
end;

procedure TfrmMain.IdFTPServer1Stat(ASender: TIdFTPServerContext;
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
  //memInfo.Lines.add('FTP Stat,' + LogStr);
end;

procedure TfrmMain.IdFTPServer1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  AppendToLogWithDate(IPCommLogFile,'FTP Status,' + AStatusText + ',');
  //memInfo.Lines.add('FTP Status,' + AStatusText + ',');
end;

procedure TfrmMain.IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
  const AFileName: String; AAppend: Boolean; var VStream: TStream);
var
  LogStr : string;
begin
  gFTPTime := GetTickCount + 10*FTP_TIMEOUT;
  LogStr := 'FTP Store File,' + ASender.CurrentDir + ',' + ASender.HomeDir + ',';
  if not Aappend then
  begin
    LogStr := LogStr + 'Create,';
    //if Download_Filename = '' then
    //begin
    //  Download_Filename := 'C:\Dynamass\In\' + FormatDateTime('yyyymmdd_HHnnsszzz', Now) + DATA_EXTENSION;
    //end;

    Download_Filename := 'C:\Dynamass\In\' + AFileName;

    VStream := TFileStream.Create(Download_Filename{ReplaceChars(AFilename)},fmCreate);
  end
  else
  begin
    LogStr := LogStr + 'Append,';
    VStream := TFileStream.Create(Download_Filename{ReplaceChars(AFilename)},fmOpenWrite);
  end;
  LogStr := LogStr + Download_Filename + ',';
  AppendToLogWithDate(IPCommLogFile,LogStr);
//  memInfo.Lines.add(LogStr);
end;

procedure TfrmMain.IdFTPServer1UserLogin(ASender: TIdFTPServerContext;
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
  //memInfo.Lines.add(LogStr);
end;

function TfrmMain.DownloadBridgeData_Internal(TargetIP,
  TargetMAC: AnsiString): Boolean;
var
  native_len,
  tot_len : integer;
  CRC : Word;
  StartTime : Cardinal;

begin
  if Status <> steIdle then Exit;
  try
    Result := false;
    Closing := false;
    ResponseStatus := rspFailure;
    native_len := 7;//7 for MAC
    //Ctrl chars + CRC
    tot_len := 4 + 2 + native_len;

    TX_Packet[0] := AnsiChar(STX);
    TX_Packet[1] := AnsiChar(DATA_ID);
    TX_Packet[2] := #0;//Len
    InsertMAC(TX_Packet,TargetMAC,3,6);
    TX_Packet[10] := AnsiChar(0);//CRC16_1
    TX_Packet[11] := AnsiChar(0);//CRC16_2
    TX_Packet[12] := AnsiChar(EOT);

    CRC := CalcCrc16(TX_Packet[3],native_len);
    Move(CRC,TX_Packet[tot_len-3],2);
    TX_Packet[tot_len-1] := AnsiChar(EOT);
    //TextMessages_Eth := '';

    try
      IdFTPServer1.Active := true
    except
      AppendToLogWithDate(IPCommLogFile,'Error opening FTP for data receiving');
      StatusBar1.SimpleText := 'Error opening FTP for data receiving';
    end;

    //Uncomment: use your UDP response function
    //  SendCommand('',qryData,tot_len,TargetIP,zPorts);
    SendIPCommand('',qryData,tot_len,TargetIP);
    //ResponseStatus := rspSuccess;
    if ResponseStatus = rspSuccess then
    begin
      try
        try
          StatusBar1.SimpleText := 'Downloading data ...';
          ResponseStatus := rspPending;
          Application.ProcessMessages;
          StartTime := GetTickCount;
          repeat
            Application.ProcessMessages;
            if Closing then Break;
            Sleep(1);
          until(((GetTickCount-StartTime)>30000) or (ResponseStatus <> rspPending));

          if ResponseStatus = rspPending then
          begin
            StatusBar1.SimpleText := 'Data downloaded still Pending';
//            memInfo.Lines.add('Error downloading data');
          end
          else if ResponseStatus = rspSuccess then
          StatusBar1.SimpleText := 'Data downloaded';
          Result := ResponseStatus = rspSuccess;
        except
          MessageDlg('Error in transfer!',mtError,[mbOK],0);
        end;
      finally
        Status := steIdle;
        //IdTrivialFTPServer1.Active := false;
        //IdFTPServer1.Active := false;
      end;
    end;
  finally
    try
      IdFTPServer1.Active := false;
    except
    end;
    Status := steIdle;
    QueryType := qryNone;
    TX_Packet := '';
    Result := ResponseStatus = rspSuccess;
  end;
end;


procedure TfrmMain.btnGetDataClick(Sender: TObject);
var
  fileName : AnsiString;
begin
try
    if MessageDlg('Request Data?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
    StatusBar1.SimpleText := 'Requesting Data...';
    btnGetData.Enabled := false;
    //PrepareCommand(Data,0,qryStatusRadar,'','');
    if NOT DownloadBridgeData_Internal(cedtIPAddress.Text, edtMACAddress.Text) then
      StatusBar1.SimpleText := 'No Data Downloaded !!';

  finally
    btnGetData.Enabled := true;
  end;
end;

procedure TfrmMain.PlotTrace(traceFile: TFilename);
begin


  frmTrace := TfrmTrace.Create(Self);
  if frmTrace.PrepareTraceDisplay(traceFile,false) then
    frmTrace.ShowModal;

  frmTrace.Free;
end;


procedure TfrmMain.atnShowHiddenExecute(Sender: TObject);
begin
  //V1070 - change from control show/hide to new tab page way
  if PageControl1.Pages[1].TabVisible = True then
  begin
    PageControl1.ActivePageIndex := 0;
    PageControl1.Pages[1].TabVisible := false;
    cbOldConfig.Checked := False;
    cbOldConfig.Enabled := False;
  end
  else
  begin
    PageControl1.Pages[1].TabVisible := True;
    PageControl1.ActivePageIndex := 1;
    cbOldConfig.Checked := False;
      cbOldConfig.Enabled := True;
      if cbDyn.Checked then
      begin
        seMin.Enabled:=True;
        seStatic.Enabled:=False;
        seMax.Enabled:=True;
        seMinSpeed.Enabled:=False;
        seMaxSpeed.Enabled:=True;
      end
      else
      begin
        seMin.Enabled:=False;
        seStatic.Enabled:=True;
        seMax.Enabled:=False;
        seMinSpeed.Enabled:=False;
        seMaxSpeed.Enabled:=False;
      end;
    end;


 { if seAvgMS.Visible = True then
  begin
      seAvgMS.Visible := False;
      Label3.Visible :=  False;
      grpPWM.Enabled := False;
      GreyOutGB(grpPWM);

      frmMain.Caption := 'HMA-VR Configuration Interface';
  end
  else
  begin
      seAvgMS.Visible := True;
      Label3.Visible :=  True;
      //1.0.3.0 - enable PWM only in advanced configs
      grpPWM.Enabled := True;
      GreyOutGB(grpPWM);
      cbOldConfig.Checked := False;
      cbOldConfig.Enabled := True;
      if cbDyn.Checked then
      begin
        seMin.Enabled:=True;
        seStatic.Enabled:=False;
        seMax.Enabled:=True;
        seMinSpeed.Enabled:=False;
        seMaxSpeed.Enabled:=True;
      end
      else
      begin
        seMin.Enabled:=False;
        seStatic.Enabled:=True;
        seMax.Enabled:=False;
        seMinSpeed.Enabled:=False;
        seMaxSpeed.Enabled:=False;
      end;

      frmMain.Caption := 'HMA-VR Configuration Interface - ADVANCED';
  end;  }

end;

procedure TfrmMain.btnSetPcIPAsServerClick(Sender: TObject);
begin
//    lblPCIPAddress   ceditServerIP
ceditServerIP.Text := lblPCIPAddress.Caption;
end;

procedure TfrmMain.btnDiscoverClick(Sender: TObject);
var
  i : Word;
begin
try
    btnDiscover.Enabled := false;
    discovery_Cnt := 0;
    for i := 0 to 4 do
    begin
      grdDiscovery.Cell[2,i] := '';
      grdDiscovery.Cell[3,i] := '';
    end;
    PrepareCommand(DISCOVER,0,qryDiscover,'','255.255.255.255');
  finally
    btnDiscover.Enabled := true;
  end;
end;

procedure TfrmMain.grdDiscoveryDblClickCell(Sender: TObject; DataCol,
  DataRow: Integer; Pos: TtsClickPosition);
begin
  if grdDiscovery.Cell[DataCol,DataRow] <>'' then
  begin
      if MessageDlg('Load Device Configuration?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;

      cedtIPAddress.Text := LongToIPString(Discovery_Settings_Config_Group.units[DataRow-1].My_IP);
      ceditMyIP.Text := LongToIPString(Discovery_Settings_Config_Group.units[DataRow-1].My_IP);
      ceditGatewayIP.Text := LongToIPString(Discovery_Settings_Config_Group.units[DataRow-1].My_GTW);
      ceditServerIP.Text := LongToIPString(Discovery_Settings_Config_Group.units[DataRow-1].My_ServerIP);
      ceditSubIP.Text := LongToIPString(Discovery_Settings_Config_Group.units[DataRow-1].My_SNM);
      edtMACAddress.Text := Discovery_Settings_Config_Group.units[DataRow-1].MAC_Add;
      rbRdr1Inbound.Checked := (Discovery_Settings_Config_Group.units[DataRow-1].A_is_IN = 1 );
      rbRdr2Inbound.Checked := NOT rbRdr1Inbound.Checked;

      //1.0.3.0 - 100D update in FW to incluse PWM and default struct and not subset of defaults

      cbDyn.Checked := Discovery_Settings_Config_Group.units[DataRow-1].PWM_Dynamic = 1;
      seMin.Value :=  Round(Discovery_Settings_Config_Group.units[DataRow-1].PWM_I_min/1000);
      seStatic.Value := Discovery_Settings_Config_Group.units[DataRow-1].PWM_S_static;
      seMax.Value := Round(Discovery_Settings_Config_Group.units[DataRow-1].PWM_I_max/1000);
      seMinSpeed.Value := Round(Discovery_Settings_Config_Group.units[DataRow-1].PWM_S_min/1000);
      seMaxSpeed.Value := Round(Discovery_Settings_Config_Group.units[DataRow-1].PWM_S_max/1000);
      seOffset.Value := Discovery_Settings_Config_Group.units[DataRow-1].PWM_Offset;
      sePwmInterval.Value := Discovery_Settings_Config_Group.units[DataRow-1].PWM_time_offset;

      if grpPWM.Enabled then
      begin
        cbDynClick(sender);
      end;
    
  end;

end;

procedure TfrmMain.cbEnableMonitorClick(Sender: TObject);
begin
  tmrRequestSpeed.Enabled := cbEnableMonitor.Checked = true;

  if cbEnableMonitor.Checked = false then
    lblSpeed.Caption := 'N/A';

end;

procedure TfrmMain.cbDynClick(Sender: TObject);
begin
  if grpPWM.Enabled then
  begin
    if cbDyn.Checked then
    begin
      seMin.Enabled:=True;
      seStatic.Enabled:=False;
      seMax.Enabled:=True;
      seMinSpeed.Enabled:=True;
      seMaxSpeed.Enabled:=True;
    end
    else
    begin
      seMin.Enabled:=False;
      seStatic.Enabled:=True;
      seMax.Enabled:=False;
      seMinSpeed.Enabled:=False;
      seMaxSpeed.Enabled:=False;
    end;
  end;
end;

//V1050 - Send reboot Command
procedure TfrmMain.btnRebootClick(Sender: TObject);
var
  TmpStr : AnsiString;
  radarCommand : TRadar_Command;
  i : integer;
begin
  try
    if MessageDlg('Send Command?',mtWarning,[mbYes,mbNo],0) <> mrYes then Exit;

    radarCommand.reboot := 1;
    TmpStr := '';
    Move(radarCommand,gCheckData,SizeOf(radarCommand));
    for i := 0 to SizeOf(radarCommand)-1 do
      TmpStr := TmpStr + AnsiChar(gCheckData[i]);

    StatusBar1.SimpleText := 'Sending Command...' ;
    btnReboot.Enabled := false;
    if PrepareCommand(COMMAND,SizeOf(radarCommand),qryCommand,TmpStr,'') then
      StatusBar1.SimpleText := 'Command Send Successful'
    else
      StatusBar1.SimpleText := 'Command send Failed !!';
  finally
    btnReboot.Enabled := true;
  end;
end;

procedure TfrmMain.tmrForceSpeedTimer(Sender: TObject);
begin
  tmrForceSpeed.Enabled := false;

  StatusBar1.SimpleText := 'Set Static Speed...' ;
  if PrepareCommand(SPEED_SET,0,qrySpeedSet,'','') then
    StatusBar1.SimpleText := 'Successful'
  else
    StatusBar1.SimpleText := 'Speed Request Failed !!';

  tmrForceSpeed.Enabled := cbForceSpeed.Checked = true;

end;

procedure TfrmMain.cbForceSpeedClick(Sender: TObject);
begin
 tmrForceSpeed.Enabled := cbForceSpeed.Checked = true;

end;
//v1060 - Import a config
function TfrmMain.ReadConfigFromFile(Datafile: string):Boolean;
var
  F : File;
  br : integer;
  CRC,
  Calc_CRC : Word;
  tmpConfig : TRadar_Config;
  Sender: TObject;
begin
  if FileExists(Datafile) then
  begin
    AssignFile(F,Datafile);
    try
      Reset(F,1);
      try
        BlockRead(F,tmpConfig,SizeOf(tmpConfig),br);

        Calc_CRC := calcCrc16(tmpConfig,SizeOf(tmpConfig)-2);
        if Calc_CRC = tmpConfig.CRC16 then
        begin
           seAvgMS.Value := tmpConfig.Save_time_offset;
           seTrendMS.Value := tmpConfig.Trend_tim_offset;
           if tmpConfig.A_is_IN = 1 then
           begin
            rbRdr1Inbound.Checked := true;
            rbRdr2Inbound.Checked := false;
           end
           else
           begin
            rbRdr1Inbound.Checked := false;
            rbRdr2Inbound.Checked := true;
           end;

           Settings.ConfigPorts[0] := tmpConfig.UDP_Ports_Local[0];
           Settings.DataPorts[0] := tmpConfig.UDP_Ports_Local[1];
           Settings.ConfigPorts[1] := tmpConfig.UDP_Ports_Remote[0];
           Settings.DataPorts[1] := tmpConfig.UDP_Ports_Remote[1];
           cedtIPAddress.Text := LongToIPString(tmpConfig.My_IP);
           edtMACAddress.Text := tmpConfig.MAC_Add;
           ceditServerIP.Text := LongToIPString(tmpConfig.targetIP);
           ceditMyIP.Text := LongToIPString(tmpConfig.My_IP);
           ceditGatewayIP.Text := LongToIPString(tmpConfig.My_GTW);
           ceditSubIP.Text := LongToIPString(tmpConfig.My_SNM);
           ceditServerIP.Text := LongToIPString(tmpConfig.My_ServerIP);
           sePwmInterval.Value := tmpConfig.PWM_time_offset;

           if(tmpConfig.PWM_Dynamic = 1) then cbDyn.Checked := true
           else cbDyn.Checked := false;

           seMin.Value := ROUND(tmpConfig.PWM_I_min/1000);
           seStatic.Value := tmpConfig.PWM_S_static;
           seMax.Value:= ROUND(tmpConfig.PWM_I_max/1000);
           seMinSpeed.Value := ROUND(tmpConfig.PWM_S_min/1000);
           seMaxSpeed.Value := ROUND(tmpConfig.PWM_S_max/1000);
           seOffset.Value := tmpConfig.PWM_Offset;

           if grpPWM.Enabled then
           begin
             cbDynClick(Sender);
           end;
           Result := true;
        end;
      finally
        CloseFile(F);
      end;
    except
    end;
  end;
end;

//v1060 - Export a config
function TfrmMain.SaveConfigToFile(Datafile: string):Boolean;
var
  lFilename : string;
  F : File;
  bw : integer;
  CRC,i : Word;
  radarConfig : TRadar_Config;

begin

  Result := false;
  if not CollectInfo then Exit;

  radarConfig.memPosiAdd := 0;
  radarConfig.memPosiStart := 0;
  radarConfig.TrainCount := 0;
  radarConfig.Baud_Rate := 9600;
  radarConfig.Save_time_offset := seAvgMS.Value;
  radarConfig.Trend_tim_offset := seTrendMS.Value;
  if rbRdr1Inbound.Checked then
    radarConfig.A_is_IN := 1
  else
    radarConfig.A_is_IN := 0;

  radarConfig.Config_OK := 0;//10 to reset trains
  radarConfig.UDP_Ports_Local[0] := Settings.ConfigPorts[0];
  radarConfig.UDP_Ports_Local[1] := Settings.DataPorts[0];
  radarConfig.UDP_Ports_Remote[0] := Settings.ConfigPorts[1];
  radarConfig.UDP_Ports_Remote[1] := Settings.DataPorts[1];
  radarConfig.targetIP := IPStringToLong(ceditServerIP.Text);
  radarConfig.Version[0] := '0';
  radarConfig.SiteID[0] := 'H';
  radarConfig.SiteID[1] := 'M';
  radarConfig.SiteID[2] := 'A';
  radarConfig.SiteID[3] := 'V';
  radarConfig.SiteID[4] := 'R';
  radarConfig.SiteID[5] := #0;

  radarConfig.acq_rate := 750;
  radarConfig.My_IP := IPStringToLong(ceditMyIP.Text);
  radarConfig.My_GTW := IPStringToLong(ceditGatewayIP.Text);
  radarConfig.My_SNM := IPStringToLong(ceditSubIP.Text);
  radarConfig.My_ServerIP := IPStringToLong(ceditServerIP.Text);
  for i := 1 to Length(Settings.MACAddress) do
  begin
    radarConfig.MAC_Add[i-1] := AnsiChar(edtMACAddress.Text[i]);
  end;
  radarConfig.last_train :=0;
  radarConfig.last_train_on :=0;
  radarConfig.power_time := 0;
  radarConfig.power_status := 0;
  radarConfig.power_db_pos := 0;
  radarConfig.power_db_cnt := 0;
  radarConfig.power_debounce := 0;
  radarConfig.tmzone := 2;
  radarConfig.PWM_time_offset := sePwmInterval.Value;
  if(cbDyn.Checked) then
    radarConfig.PWM_Dynamic := 1
  else
    radarConfig.PWM_Dynamic := 0;
  radarConfig.PWM_I_min := seMin.Value*1000;
  radarConfig.PWM_S_static := seStatic.Value;
  radarConfig.PWM_I_max := seMax.Value*1000;
  radarConfig.PWM_S_min := seMinSpeed.Value*1000;
  radarConfig.PWM_S_max := seMaxSpeed.Value*1000;
  radarConfig.PWM_Offset := seOffset.Value;

  for i := 0 to (sizeof(radarConfig.dummy)-1) do
    radarConfig.dummy[i] := '0';
    
  radarConfig.CRC16 := calcCrc16(radarConfig,SizeOf(radarConfig)-2);

  AssignFile(F,Datafile);
  try
    Rewrite(F,1);
    try
      BlockWrite(F,radarConfig,SizeOf(radarConfig),bw);
      Result := true;
    finally
      CloseFile(F);
    end;
  except
  end;
end;

//v1060 - btn event Import a config
procedure TfrmMain.btnImportClick(Sender: TObject);
begin
  if MessageDlg('Import Device Configuration?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  OpenDialog2.InitialDir := EXPORT_PATH_DEF;
  if not OpenDialog2.Execute then Exit;
  if ReadConfigFromFile(OpenDialog2.Filename) then
    MessageDlg('Device Configuration Imported',mtInformation,[mbOK],0)
  else
    MessageDlg('Device Configuration Import Failed',mtError,[mbOK],0) ;
end;

//v1060 - btn event Export a config
procedure TfrmMain.btnExportClick(Sender: TObject);
begin
  if MessageDlg('Export Device Configuration?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  SaveDialog2.InitialDir := EXPORT_PATH_DEF;
  if not SaveDialog2.Execute then Exit;
  if SaveConfigToFile( SaveDialog2.FileName) then
    MessageDlg('Device Configuration Exported',mtInformation,[mbOK],0)
  else
    MessageDlg('Device Configuration Export Failed',mtError,[mbOK],0) ;
end;

procedure TfrmMain.btnHWConfigClick(Sender: TObject);
var
  TmpStr : AnsiString;
  HWConfig : THardware_Settings;
  i : integer;
begin
  if MessageDlg('Send Hardware Configuration?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;


  HWConfig.LowSpeed := seLoSpeed.Value;
  HWConfig.HiSpeed := seHiSpeed.Value;
  HWConfig.FastestTarger := rdgTarget.ItemIndex; //0=strongest, 1 = fastes(original default
  HWConfig.Sensitivity := seDetcSens.Value;
  HWConfig.SP := 11; //Flashing Speed - unused - static
  HWConfig.RS := 173; //Baud Rate - static
  HWConfig.UN := 771; // unknown - static
  HWConfig.HT := 0; // Output Hold Time - static
  HWConfig.IO := 0; //Inputs/outputs - static
  HWConfig.SI := 5; // Rotary Switch Speed Inc - static
  HWConfig.MO := 2; // Radar Bitmask - static
  HWConfig.MD := 1; // Radar Bitmask 2 - static
  HWConfig.AN := 1026; // unknown - static
  HWConfig.OP := 16; // unknown - static
  HWConfig.SH := 256; // unknown - static
  HWConfig.BN := 5; // unknown - static
  HWConfig.TA := 30; // unknown - static
  HWConfig.TS := 500; // unknown - static
  HWConfig.DM := 0; // unknown - static
  HWConfig.KY := 814; // unknown - static
  HWConfig.T0 := 32767; // unknown - static
  HWConfig.CRC16 := calcCrc16(HWConfig,SizeOf(HWConfig)-2);

  TmpStr := '';
  Move(HWConfig,gCheckData,SizeOf(HWConfig));
  for i := 0 to SizeOf(HWConfig)-1 do
    TmpStr := TmpStr + AnsiChar(gCheckData[i]);

  StatusBar1.SimpleText := 'Sending Hardware Configuration...' ;
  btnHWConfig.Enabled := False;
  if PrepareCommand(HW_CONFIG,SizeOf(HWConfig),qryHWConfig,TmpStr,'') then
    StatusBar1.SimpleText := 'Hardware Configuration Successful'
  else
    StatusBar1.SimpleText := 'Hardware Configuration Failed !!';

  btnHWConfig.Enabled := True;

end;

end.

