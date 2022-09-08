unit HMAVR_DataView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DBCtrls, DB, ADODB, Grids_ts, TSGrid,
  TSDBGrid, jpeg;

type
  TfrmDataView = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    dbcbxSites: TDBLookupComboBox;
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
    dsAlerts: TDataSource;
    qryTrains: TADOQuery;
    dsTrains: TDataSource;
    qryTrainsMessage_ID: TAutoIncField;
    qryTrainsSite_ID: TIntegerField;
    qryTrainsPost_Date: TDateTimeField;
    qryTrainsWagon_Count: TIntegerField;
    qryTrainsAlarm_Count: TIntegerField;
    qryTrainsDirection: TWideStringField;
    qryTrainsMeas_Result: TWordField;
    grdTrainHeader: TtsDBGrid;
    grdAlerts: TtsDBGrid;
    Panel3: TPanel;
    Image1: TImage;
    qryTrainsMeas_Res_Desc: TStringField;
    qryAlertsAlert_Type_Desc: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure dbcbxSitesCloseUp(Sender: TObject);
    procedure dsAlertsDataChange(Sender: TObject; Field: TField);
    procedure qryTrainsCalcFields(DataSet: TDataSet);
    procedure qryAlertsCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    procedure UpdateAlertView;
    procedure UpdateTrainView;
  public
    { Public declarations }
  end;

var
  frmDataView: TfrmDataView;

implementation

uses HMAVR_Datamodule, HMAVR_Var;

{$R *.dfm}

procedure TfrmDataView.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmDataView.FormShow(Sender: TObject);
begin
  //
end;

procedure TfrmDataView.FormActivate(Sender: TObject);
begin
  //
end;

procedure TfrmDataView.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //
end;

procedure TfrmDataView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
end;

procedure TfrmDataView.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmDataView.dbcbxSitesCloseUp(Sender: TObject);
begin
  if dbcbxSites.Text <> '' then
  begin
    UpdateAlertView;
    UpdateTrainView;
  end;
end;

procedure TfrmDataView.UpdateAlertView;
begin
  with qryAlerts do
  begin
    Parameters[0].Value := dbcbxSites.KeyValue;
    Parameters[1].Value := FormatDateTime('yyyy-mm-dd HH.nn.ss',Now - 90);
    if Active then
      Requery()
    else
      Open;
  end;
end;

procedure TfrmDataView.UpdateTrainView;
begin
  with qryTrains do
  begin
    Parameters[0].Value := dbcbxSites.KeyValue;
    Parameters[1].Value := FormatDateTime('yyyy-mm-dd HH.nn.ss',Now - 90);
    if Active then
      Requery()
    else
      Open;
  end;
end;

procedure TfrmDataView.dsAlertsDataChange(Sender: TObject; Field: TField);
begin
  DataModule1.RetrieveThumbnail(qryAlertsPhoto,Image1);
end;

procedure TfrmDataView.qryTrainsCalcFields(DataSet: TDataSet);
var
  Idx : integer;
begin
  Idx := qryTrainsMeas_Result.AsInteger;
  if (Idx >= 0) and (Idx < 5) then
    qryTrainsMeas_Res_Desc.AsString := MEAS_RESULT_DESC[Idx]
  else
    qryTrainsMeas_Res_Desc.AsString := '';
end;

procedure TfrmDataView.qryAlertsCalcFields(DataSet: TDataSet);
var
  lStr : string;
begin
  lStr := '';
  if (qryAlertsAlarm_Type.AsInteger and 1) = 1 then
    lStr := 'Overload,';
  if (qryAlertsAlarm_Type.AsInteger and 2) = 2 then
    lStr := lStr + 'Underload,';
  if (qryAlertsAlarm_Type.AsInteger and 4) = 4 then
    lStr := lStr + 'Axle over load,';
  if (qryAlertsAlarm_Type.AsInteger and 8) = 8 then
    lStr := lStr + 'End-End,';
  if (qryAlertsAlarm_Type.AsInteger and 16) = 16 then
    lStr := lStr + 'Side-Side,';
  if lStr[Length(lStr)] = ',' then
    Delete(lStr,Length(lStr),1);
  qryAlertsAlert_Type_Desc.AsString := lStr;
end;

end.
