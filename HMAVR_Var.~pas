unit HMAVR_Var;

interface

uses
  Registry, Classes;

const
  STX = $02;
  EOT = $04;
  SPEED = $86;
  CONFIG = $90;
  DATA_ID = $95;
  SET_RTC = $97;
  DISCOVER = $91;
  HW_CONFIG = $92;  //1070 - new cmd for HW config
  RADAR_STATUS = $80;
  COMMAND = $81;
  SPEED_SET = $82;
  SECTION = 'HMAVR Configurator';
  MAX_SENSORS = 32;
  DB_PATH_DEF = 'C:\Dynamass\DB\';
  DATA_PATH_DEF = 'C:\Dynamass\In\';
  LOG_PATH_DEF = 'C:\Dynamass\Logs\';
  EXPORT_PATH_DEF = 'C:\Dynamass\Export\';
  DATA_EXTENSION = '.rad';
  MEAS_RESULT_DESC : Array[0..4] of String[15] = ('Error','Success','No locos','Sensor error','Reader error');
  UDP_DMT_DEF : Array[0..1] of Word = ( 25000, 25005 );
  UDP_SVR_DEF : Array[0..1] of Word = ( 25001, 25006 );

  MAX_TP = 16;
  MAX_AXLES_V3 = 6;
  MAXAXLES = 6;
  TAG_STR_LEN = 20;
  FTP_TIMEOUT = 3000;
  TRAIN_BLOCK_MEM = $3000;
type
  TCommsState = (steBusy,steIdle,steConnected);
  TResponseStatus = (rspSuccess,rspPending,rspFailure);
  TBridgeQueryType = (qryAcquire,qryBLDS_Alert,qryBLDS_Setting,qryBLDS_Train,qryClearAll,qryClearData,qryCommand,qryConfig,qryConfigChk,qryData,qryDataPack,
                      qryDED_Alert,qryDMT_Vehicle,qryGPRS_Setting,qryHeartbeat,qryLocoDB,qrySpeedSet,qryPowerDB,qryPowerDBClear,qrySendTrace,qryStatus,qryStatusRadar,
                      qryTimeSet,qryTrainPres,qryVoltmeter,qryWIMWIM_Alert,qryNone,qryDiscover,qryHWConfig);

  TRabbit_tm = Record //Size = 7 bytes
    tm_sec, // seconds 0-59
    tm_min, // 0-59
    tm_hour, // 0-23
    tm_mday, // 1-31
    tm_mon, // 1-12
    tm_year, // 80-147 (1980-2047)
    tm_wday : Byte;  // 0-6 0==sunday
  end;


  TSettings = Record
    Baud,
    ComPort,
    Mode : integer;
    IPAddress : Cardinal;
    IPMode,
    Emulate_BLDS : Boolean;
    MACAddress : string;
    ConfigPorts,
    DataPorts : Array[0..1] of Word;
    Radar1Inbound : Boolean;
  end;

  TStruct_tm = Record //Size = 7 bytes
    tm_sec, // seconds 0-59
    tm_min, // 0-59
    tm_hour, // 0-23
    tm_mday, // 1-31
    tm_mon, // 1-12
    tm_year, // 80-147 (1980-2047)
    tm_wday,
    tm_yday,
    tm_isdst : Word;  // 0-6 0==sunday
  end;


  TRadar_Status = Record //Size 83 bytes

    SiteID : Array[0..14] of AnsiChar; //Site Name
    MAC_Add : Array[0..7] of AnsiChar; //Local MAC address
    train_pres : Byte;             //Train presence
    rtc : Cardinal;              //Rabbit's local time
    last_train,                    //Last train date and time
    last_train_on : Cardinal;      //Last train presence signal date and time
    train_count : Word;            //Train count in mem
    Config_OK : Byte;              //Config CRC OK
    Radar_OK : Byte;              //Config CRC OK
    firmware : Array[0..4] of AnsiChar;//Firmware version
    power_level : Word;            //Power level (battery)
    power_status,                  //Power status (on/off)
    power_db_cnt : Byte;           //Events in power DB
    power_rtc : Cardinal;          //Power status change time
    RCM_type : Byte;               //Rabbit Type
    options,                       //Compiler directives
    acq_rate: Word;                //Acquisition rate, Hz
    dummy : Array [0..1] of Byte;  //Spare chars available
    CRC16 : Word;
  end;



  TRadar_Config_V100 = Record //12+2+4+4+2+4+4+4+4+15+2+28+4+2+2+2+24+8+2 =  129bytes
    memPosiAdd,
    memPosiStart,
    memPosiEnd :  Cardinal;
    TrainCount : Word;
    Baud_Rate : Cardinal;
    Save_time_offset,
    Trend_tim_offset : Word;
    A_is_IN,
    Config_OK : Byte;
    UDP_Ports_Local : Array[0..1] of Word;
    UDP_Ports_Remote : Array[0..1] of Word;
    targetIP : Cardinal;
    Version : Array[0..3] of AnsiChar;
    SiteID : Array[0..14] of AnsiChar;
    acq_rate : Word;  //57b
    My_IP,
    My_GTW,
    My_SNM,
    My_ServerIP,
    last_train,       //Last train
    last_train_on,    //Last train_on
    power_time : Cardinal;//28
    power_status,
    power_db_pos,
    power_db_cnt,
    power_debounce : Byte;
    error_code,
    tmzone : Word;
    dummy : Array[0..34] of AnsiChar;
    CRC16 : Word;
  end;

  TRadar_Config = Record //12+2+4+4+2+4+4+4+4+15+2+28+4+2+2+2+24+8+2+8(speeds)+13 =  147 bytes
    memPosiAdd,
    memPosiStart,
    memPosiEnd :  Cardinal;
    TrainCount : Word;
    Baud_Rate : Cardinal;
    Save_time_offset,
    Trend_tim_offset : Word;
    A_is_IN,
    Config_OK : Byte;
    UDP_Ports_Local : Array[0..1] of Word;
    UDP_Ports_Remote : Array[0..1] of Word;
    targetIP : Cardinal;
    Version : Array[0..3] of AnsiChar;
    SiteID : Array[0..14] of AnsiChar;
    acq_rate : Word;  //57b
    My_IP,
    My_GTW,
    My_SNM,
    My_ServerIP,
    last_train,       //Last train
    last_train_on,    //Last train_on
    power_time : Cardinal;//28
    power_status,
    power_db_pos,
    power_db_cnt,
    power_debounce : Byte;
    //error_code,//removed for 100d to have extra spcae
    tmzone : Word;

    //100D
    MAC_Add : Array[0..7] of AnsiChar;
    PWM_time_offset : Word;  //rate in ms to refresh pwm options if speed changed
    PWM_Dynamic : Byte;             //static or dyn pwm output based on speed
    PWM_I_min,               //swopped around 1-0.001 = min value
    PWM_I_max,     //swopped around 1-0.999 = max value
    PWM_S_min,
    PWM_S_max : SmallInt;
    PWM_S_static, //if ch is not dyn, then use this value = kph*1000
    PWM_Offset : LongInt; //def 2500 mA offset tp alogh to points (2.58*1000)
    dummy : Array[0..26] of AnsiChar;
    CRC16 : Word;
  end;

   TDiscovery_Settings = record
    Version : Array[0..3] of AnsiChar;
    MAC_Add : Array[0..7] of AnsiChar; //Local MAC address
    My_IP,
    My_GTW,
    My_SNM,
    My_ServerIP: Cardinal;
    A_is_IN : Byte;
    CRC16 : Word;
  end;

  //V1070 - HW Settings exported settings file from Houston radar app
  THardware_Settings = record
    LowSpeed, //- static
    HiSpeed,  // - static
    FastestTarger, //fastes speed or strongest reading
    Sensitivity, // detection range/sensitivity
    SP, //Flashing Speed - unused - static
    RS, //Baud Rate - static
    UN, // unknown - static
    HT, // Output Hold Time
    IO, //Inputs/outputs - static
    SI, // Rotary Switch Speed Inc - static
    MO, // Radar Bitmask - static
    MD, // Radar Bitmask 2 - static
    AN, // unknown - static
    OP, // unknown - static
    SH, // unknown - static
    BN, // unknown - static
    TA, // unknown - static
    TS, // unknown - static
    DM, // unknown - static
    KY, // unknown - static
    T0 : SmallInt; // unknown - static
    CRC16 : Word;
  end;

  TSpeed_Reading = record
    CurrentSpeed : SmallInt;
    CRC16 : Word;
  end;

  TDiscovery_Settings_Group = record
    units : Array[0..9] of  TDiscovery_Settings;
  end;

  TDiscovery_Settings_Config_Group = record
    units : Array[0..9] of  TRadar_Config;
  end;

  TTrain_Header = record
    train_tm : Cardinal;
    trend_tm,
    avg_tm,
    points_cnt,
    points_wrap,
    points_start : Word;
    A_is_IN : Byte;
    dummy : Array[0..3] of Byte;
  end;

  TData_Header = record
    Version : Array[0..3] of AnsiChar;
    TrainsInData : Word;
    train_hdr : Array[0..4] of TTrain_Header;
    dummy : Array[0..4] of Byte;
  end;

  //v1050
  TRadar_Command = Record
    reboot,
    send_sms : Byte;
    sms_num : Array[0..14] of Byte;
    reset_outs,
    reader_cmd : Byte;
    dummy : Array[0..8] of Byte;
  end;


var
  IniFile : TRegIniFile;
  Settings : TSettings;
  gCheckData : Array[0..255] of Byte;
//  TX_Packet_Eth,
  TX_Packet : Array[0..255] of AnsiChar;
  gFileList : TStrings;
  RadarStatus : TRadar_Status;
  Data_Header : TData_Header;
  Train_Header : TTrain_Header;
  Speed_Reading : TSpeed_Reading;
  Discovery_Settings : TDiscovery_Settings;
  Discovery_Settings_Group : TDiscovery_Settings_Group;
  Discovery_Settings_Config_Group : TDiscovery_Settings_Config_Group;
  RadarCmd : TRadar_Command;
  activeChans : integer;

function CalcCrc(data: array of byte; count : word): word;
function calcCrc16(const source; count : word): word;
procedure ReadSettingsfromRegistry;
procedure SaveSettingstoRegistry;
procedure CheckUDPPortRange(var zPort : Word; zPortDefault : Word);

implementation

uses SysUtils;

function CalcCrc(data: array of byte; count : word): word;
var
    crc:    word;
    i:      word;
    start_count : word;
    //count:   word;

begin

    crc := 0;
    start_count := count;
    //count := (sizeof(ConfigInfo)-2) ;

    while count > 0 do
    begin
        crc := crc xor data[start_count-count] shl 8;
        for i:=0 to 7 do
        begin
            if (crc and $8000) <> 0 then
                crc := crc shl 1 xor $1021
            else
                crc := crc shl 1;
        end;

        count := count - 1;

    end;

    result := (crc and $FFFF);

end;

function calcCrc16(const source; count : word): word;
var
    crc:    word;
    i:      word;
    start_count : word;
    data : Array of Byte;


begin
    SetLength(data,count);

    Move(source, data[0], count);
    crc := 0;
    start_count := count;
    //count := (sizeof(ConfigInfo)-2) ;

    while count > 0 do
    begin
        crc := crc xor data[start_count-count] shl 8;
        for i:=0 to 7 do
        begin
            if (crc and $8000) <> 0 then
                crc := crc shl 1 xor $1021
            else
                crc := crc shl 1;
        end;

        count := count - 1;

    end;

    result := (crc and $FFFF);

end;

procedure ReadSettingsfromRegistry;
begin
  Settings.ComPort := IniFile.ReadInteger(Section,'Comm_Port',1);
  Settings.Baud := IniFile.ReadInteger(Section,'Baud',9600);
  Settings.Mode := 0;//IniFile.ReadInteger(Section,'Mode',1);
  Settings.IPAddress := IniFile.ReadInteger(Section,'IP_Address',0);
  Settings.IPMode := IniFile.ReadBool(Section,'IP_Mode',True);
  Settings.MACAddress := IniFile.ReadString(Section,'MAC_Address','000000');
  Settings.Emulate_BLDS := IniFile.ReadBool(Section,'Emulate_BLDS',True);
  Settings.ConfigPorts[0] := IniFile.ReadInteger(Section,'Config_Port1',25000);
  Settings.ConfigPorts[1] := IniFile.ReadInteger(Section,'Config_Port2',25001);
  Settings.DataPorts[0] := IniFile.ReadInteger(Section,'Data_Port1',25005);
  Settings.DataPorts[1] := IniFile.ReadInteger(Section,'Data_Port2',25006);
  Settings.Radar1Inbound := IniFile.ReadBool(Section,'Radar1Inbound',True);

  if Settings.MACAddress = '' then
    Settings.MACAddress := '000000';

end;

procedure SaveSettingstoRegistry;
begin

  if Settings.MACAddress = '' then
    Settings.MACAddress := '000000';

  IniFile.WriteInteger(Section,'Comm_Port',Settings.ComPort);
  IniFile.WriteInteger(Section,'Baud',Settings.Baud);
  IniFile.WriteInteger(Section,'Mode',Settings.Mode);
  IniFile.WriteInteger(Section,'IP_Address',Settings.IPAddress);
  IniFile.WriteBool(Section,'IP_Mode',Settings.IPMode);
  IniFile.WriteString(Section,'MAC_Address',Settings.MACAddress);
  IniFile.WriteBool(Section,'Emulate_BLDS',Settings.Emulate_BLDS);
  IniFile.WriteInteger(Section,'Config_Port1',Settings.ConfigPorts[0]);
  IniFile.WriteInteger(Section,'Config_Port2',Settings.ConfigPorts[1]);
  IniFile.WriteInteger(Section,'Data_Port1',Settings.DataPorts[0]);
  IniFile.WriteInteger(Section,'Data_Port2',Settings.DataPorts[1]);
  IniFile.WriteBool(Section,'Radar1Inbound',Settings.Radar1Inbound);

end;

procedure CheckUDPPortRange(var zPort : Word; zPortDefault : Word);
begin
  if (zPort < 1) or (zPort > 65535) then
    zPort := zPortDefault;
end;

initialization
  IniFile := TRegIniFile.Create('\Software\Binary Technology\');
  IniFile.OpenKey('\Software\Binary Technology\',false);
  try
    ReadSettingsfromRegistry;
  except
  end;
  if not DirectoryExists(DATA_PATH_DEF) then ForceDirectories(DATA_PATH_DEF);
  gFileList := TStringList.Create;
  gFileList.Clear;


finalization
  IniFile.Free;
  gFileList.Free;


end.
