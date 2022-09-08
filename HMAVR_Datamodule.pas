unit HMAVR_Datamodule;

interface

uses
  SysUtils, Classes, DB, ADODB, Forms, Dialogs, JPEG, ExtCtrls, Graphics,
  Windows, HMAVR_Var, FC_Common;

type
  TDataModule1 = class(TDataModule)
    ADOConnection1: TADOConnection;
    GenSQL: TADOQuery;
    qryAlerts: TADOQuery;
    qryAlertsAlert_ID: TAutoIncField;
    qryAlertsSite_ID: TIntegerField;
    qryAlertsSeq_No: TIntegerField;
    qryAlertsAlert_Time: TDateTimeField;
    qryAlertsDirection: TWideStringField;
    qryAlertsVehicle_Idx: TIntegerField;
    qryAlertsWagon_No: TWideStringField;
    qryAlertsAlarm_Type: TWordField;
    qryAlertsOverload_Value: TSmallintField;
    qryAlertsUnderload_Value: TSmallintField;
    qryAlertsAxle_Value: TSmallintField;
    qryAlertsSkew_Value_Bogie: TSmallintField;
    qryAlertsSkew_Value_Lateral: TSmallintField;
    qryAlertsAxle_Number: TWordField;
    qryAlertsLoaded_End: TWideStringField;
    qryAlertsLoaded_Side: TWideStringField;
    qryAlertsPhoto: TBlobField;
    qrySites: TADOQuery;
    qrySitesSite_ID: TAutoIncField;
    qrySitesSite_Name: TWideStringField;
    dsSites: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    gPath,
    AccessFile : string;
    function ConnectDatabase(ADOConnection: TADOConnection): Boolean;
    function SiteIDByName(SiteName: AnsiString; CreateIfNotExists: Boolean): integer;
  public
    { Public declarations }
    function ProcessJPG() : Boolean;
    function RetrieveThumbnail(cField: TBlobField; var cImage: TImage): Boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

uses DateUtils;

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  ConnectDatabase(ADOConnection1);
  qrySites.Open;
end;

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  //
end;

function TDataModule1.ConnectDatabase(ADOConnection:TADOConnection): Boolean;
var
   DataSource,
   DBName : string;
   i : integer;
begin
  //Exit;
  Result := false;
  DBName := 'ITCMS.MDB';
  gPath := DB_PATH_DEF;
  AccessFile := gPath+DBName;
  //gApplicationDatabase := AccessFile;
  ADOConnection.Connected := false;
  if not FileExists(AccessFile) then
  begin
    ShowMessage('No database file!');
    Application.Terminate;
  end;
  ADOConnection.Connected := false;
  DataSource:='Provider=Microsoft.Jet.OLEDB.4.0' +
              ';Data Source=' + AccessFile +
              ';Jet OLEDB:Engine Type=5';
  ADOConnection.ConnectionString := DataSource;
  ADOConnection.LoginPrompt := False;
  try
    ADOConnection.Connected := true;
    Result := true;
  except
    Result := false;
  end;
  //CheckForUpdates;
end;

function TDataModule1.SiteIDByName(SiteName : AnsiString; CreateIfNotExists : Boolean): integer;
  function GetSiteID : integer;
  begin
    with GenSQL do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Site_ID from Sites');
      SQL.Add('WHERE Site_Name=''' + SiteName + '''');
      Open;
      First;
      if RecordCount > 0 then
        Result := FieldByName('Site_ID').AsInteger
      else
        Result := 0;
      Close;
    end;
  end;
begin
  Result := GetSiteID;
  if (Result = 0) and (CreateIfNotExists) then
  begin
    with GenSQL do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO Sites');
      SQL.Add('(Site_Name) VALUES(''' + SiteName + ''')');
      ExecSQL;
      Result := GetSiteID;
      if qrySites.Active = true then qrySites.Requery() else qrySites.Open;
    end;
  end;
end;

function TDataModule1.ProcessJPG: Boolean;
var
  i,
  lAlert_ID : integer;
  lFilename,
  lSiteName,
  lDateStr,
  OnlyFilename,
  ArchiveDir : string;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
  lDate : TDateTime;
  Stream : TMemoryStream;
  JpegImg: TJpegImage;
begin
  Result := false;
  Stream := nil;
  for i := 0 to gFileList.Count-1 do
  begin
    try
      lFilename := ExtractFileName(gFileList[i]);
      lSiteName := GetNextReading(lFilename,'_');
      lDateStr := GetNextReading(lFilename,'_');
      AYear := StrToInt(Copy(lDateStr,1,4));
      AMonth := StrToInt(Copy(lDateStr,5,2));
      ADay := StrToInt(Copy(lDateStr,7,2));
      lDateStr := GetNextReading(lFilename,'M');
      AHour := StrToInt(Copy(lDateStr,1,2));
      AMinute := StrToInt(Copy(lDateStr,3,2));
      ASecond := StrToInt(Copy(lDateStr,5,2));
      AMilliSecond := 0;
      lDate := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
      with GenSQL do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT Alert_ID,Photo FROM Alerts');
        SQL.Add('WHERE Alert_Time >= #' + FormatDateTime('yyyy-mm-dd HH.nn.ss',lDate-5/86400) +'#');
        SQL.Add('AND Alert_Time <= #' + FormatDateTime('yyyy-mm-dd HH.nn.ss',lDate+5/86400) +'#');
        Open;
        First;
        if RecordCount > 0 then
        begin
          JpegImg := TJPEGImage.Create;
          JpegImg.LoadFromFile(gFileList[i]);
          Stream := TMemoryStream.Create;
          try
            JpegImg.SaveToStream(Stream);
            lAlert_ID := Fields[0].AsInteger;
            Edit;
            (Fields[1] as TBlobField).LoadFromStream(Stream);
          finally
            if State in [dsEdit,dsInsert] then
              Post;
            JpegImg.Free;
            Stream.Free;
          end;
        end;
      end;
    finally
      lFilename := gFileList[i];
      OnlyFilename := ExtractFileName(lFilename);
      if FileExists(lFilename) then
      begin
        ArchiveDir := IncludeTrailingPathDelimiter(ExtractFilePath(lFilename));
        ArchiveDir := ArchiveDir + 'Archive\';
        if not DirectoryExists(ArchiveDir) then ForceDirectories(ArchiveDir);
        MoveFileEx(PChar(lFilename), PChar(ArchiveDir + OnlyFileName),MOVEFILE_REPLACE_EXISTING + MOVEFILE_WRITE_THROUGH);
      end;
    end;
  end;
end;

function TDataModule1.RetrieveThumbnail(cField: TBlobField;
  var cImage: TImage): Boolean;
var
  DBJpeg : TJPEGImage;
  ADOBlobStream : TADOBlobStream;
begin
  Result := false;
  ADOBlobStream := TADOBlobStream.Create(cField,bmRead);
  DBJpeg := TJPEGImage.Create;
  try
    if ADOBlobStream.Size > 10 then
    begin
      try
        DBJpeg.LoadFromStream(ADOBlobStream);
        cImage.Picture.Graphic := DBJpeg;
        cImage.Visible := true;
        Result := true;
        //Image2.Picture.Graphic := Image1.Picture.Graphic;
      except
      end;
    end
    else
    begin
      cImage.Visible := false;
      cImage.Picture.Bitmap.Canvas.Brush.Color := clBtnFace;
      cImage.Picture.Bitmap.Canvas.FillRect(Rect(0,0,cImage.Width,cImage.Height));
    end;
  finally
    ADOBlobStream.Free;
    DBJpeg.Free;
  end;
end;

end.
