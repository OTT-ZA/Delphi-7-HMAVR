unit BWL_Trace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, ExtCtrls, StdCtrls, Buttons,
  ComCtrls, TeCanvas, Spin, TeeFunci, TeeEdit, TeeTools,
   TeeDragPoint,TeeStore,HMAVR_Var;
const
  //AD_BUFF_DEPTH = 128;
  TRACE_EXT = '.rad';
  TRACE_PATH = 'C:\Dynamass\Trace\';

type
  TReadingSet = Record
    reads : Array[0..3] of single;
  end;

  TfrmTrace = class(TForm)
    Panel1: TPanel;
    pnlBottom: TPanel;
    Chart: TChart;
    btnCopy: TBitBtn;
    btnPrint: TBitBtn;
    btnOK: TBitBtn;
    ChartPreviewer1: TChartPreviewer;
    StatusBar1: TStatusBar;
    lblPoint: TLabel;
    OpenDialog: TOpenDialog;
    ChartTool1: TAnnotationTool;
    ChartEditor1: TChartEditor;

    btnExport: TBitBtn;
    SaveDialog1: TSaveDialog;
    srsCh1: TLineSeries;
    srsCh2: TLineSeries;
    srsCh3: TLineSeries;
    srsCh4: TLineSeries;
    srsCh5: TLineSeries;
    ChartTool2: TColorLineTool;
    procedure FormCreate(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnViewOldClick(Sender: TObject);
    procedure ChartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChartClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure ChartMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ChartDblClick(Sender: TObject);
    procedure ChartClickLegend(Sender: TCustomChart; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    gIndex,gRate : integer;
    gSeries : TChartSeries;
    chanArray : Array[0..9] of Byte;
    chanReadings : Array of Double;
    chanTimeReadings : Array of Double;
    sourceFile : string;
    procedure updateBuffSize;
    procedure ApplyPlotSettings;
    function NearestPoint(ASeries: TChartSeries; x, y: Integer): Integer;
    procedure SetCallout(AIndex: Integer);
    function CalculateSeekStep(zChans, zRawFilt : Byte) : Cardinal;
    function ExportSeriesData : Boolean;
    function ExportChartData(fileName : string) : Boolean;
  public
    { Public declarations }
    STEP_SIZE,
    AD_BUFF_DEPTH : integer;
    function PrepareTraceDisplay(Datafile: string; zOverlay : Boolean) : Boolean;
    function CollectChannels(Data_Header : TData_Header): Boolean;

  end;

var
  frmTrace: TfrmTrace;

implementation

uses DateUtils, Math, HMAVR_Main, BWS_TraceConfigV3;

{$R *.dfm}

procedure TfrmTrace.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  lblPoint.Caption := '';
  ChartTool1.Visible := false;
  ApplyPlotSettings;
  gIndex := 0;
  gRate := 1;
  TeeUseMouseWheel := false;
  AD_BUFF_DEPTH := 10; //max readings per train before wrapping
  updateBuffSize;
  //
end;

procedure TfrmTrace.updateBuffSize;
begin
  STEP_SIZE := AD_BUFF_DEPTH;
  SetLength(chanReadings,AD_BUFF_DEPTH);
  SetLength(chanTimeReadings,AD_BUFF_DEPTH);  
end;

function TfrmTrace.CollectChannels(Data_Header : TData_Header): Boolean;
var
  idx : integer;
begin
  Result := false;
  frmTraceConfigV3 := TfrmTraceConfigV3.Create(Self);
  frmTraceConfigV3.PopulateDisplay(Data_Header);
  if frmTraceConfigV3.ShowModal = mrOK then
  begin


      activeChans := 0;
      if frmTraceConfigV3.cbT1.Checked = true then
      begin
        activeChans := activeChans + 1;
        Result := true;
      end;
      if frmTraceConfigV3.cbT2.Checked = true then
      begin
        activeChans := activeChans + 2;
        Result := true;
      end;
      if frmTraceConfigV3.cbT3.Checked = true then
      begin
        activeChans := activeChans + 4;
        Result := true;
      end;
      if frmTraceConfigV3.cbT4.Checked = true then
      begin
        activeChans := activeChans + 8;
        Result := true;
      end;
      if frmTraceConfigV3.cbT5.Checked = true then
      begin
        activeChans := activeChans + 16;
        Result := true;
      end;

  end;
  frmTraceConfigV3.Free;
end;


function TfrmTrace.PrepareTraceDisplay(Datafile: string; zOverlay : Boolean): Boolean;
var
  fs : TFileStream;

  i,chIdx,//activeChans,
  cnt,traceIncValue : integer;
  SiteID : String;
  Vers : Array[0..3] of AnsiChar;
  tmpTime : TDateTime;
  timeStep, timePos : Double;
  word1, word2, word3 : Smallint;
  Bytes : Array[0..5] of Byte;
  seekStep : Cardinal;
  offset : Cardinal;
  function GetReadings : Boolean;
  var
    ii : integer;
  begin
    Result := false;
    tmpTime := 0;
    try
      if Train_Header.points_wrap = 1 then
      begin
        ii := Train_Header.points_start;

        AD_BUFF_DEPTH := 6000; //max readings per train before wrapping
        updateBuffSize;
        while ii < 6000 do
        begin
          fs.ReadBuffer(word1,2);
          chanReadings[ii] := word1;
          chanReadings[ii] := chanReadings[ii]/100.00;
          Inc(ii,1);
        end;
        //do part before wraped data
        ii := 0;
        while ii < Train_Header.points_cnt do //cnt is set to 0 when wrapped
        begin
          fs.ReadBuffer(word1,2);
          chanReadings[ii] := word1;
          chanReadings[ii] := chanReadings[ii]/100.00;
          Inc(ii,1);
        end;
      end
      else
      begin
        ii := 0;
        AD_BUFF_DEPTH := Train_Header.points_cnt;
        updateBuffSize;

        while ii < Train_Header.points_cnt do
        begin
          fs.ReadBuffer(word1,2);
          //chanReadings[ii] := word1;
          //chanReadings[ii] := chanReadings[ii]/100.00;
          chanReadings[ii] := word1/100.00;
          chanTimeReadings[ii] := IncMilliSecond(tmpTime,(ii*(Train_Header.trend_tm)));
          Inc(ii,1);
        end;
      end;
    except

      Exit;
    end;

    Result := true;
  end;

  procedure PlotChannel(zIdx : integer);
  var
    ii : integer;
  begin
    if (zIdx < 0) or (zIdx > Chart.SeriesCount-1) then Exit;
    try
      case zIdx of
        0:
        begin//chanTimeReadings,
          //srsCh1.AddArray(chanReadings);
          { set our X array }
          With srsCh1.XValues do
          begin
            Value:=TChartValues(chanTimeReadings);  { <-- the array }
            Count:=Train_Header.points_cnt;               { <-- number of points }
            Modified:=True;           { <-- recalculate min and max }
          end;

          { set our Y array }
          With srsCh1.YValues do
          begin
            Value:=TChartValues(chanReadings);
            Count:=Train_Header.points_cnt;
            Modified:=True;
          end;

        end;
        1:
        begin
          //srsCh2.AddArray(chanReadings);
          { set our X array }
          With srsCh2.XValues do
          begin
            Value:=TChartValues(chanTimeReadings);  { <-- the array }
            Count:=Train_Header.points_cnt;               { <-- number of points }
            Modified:=True;           { <-- recalculate min and max }
          end;

          { set our Y array }
          With srsCh2.YValues do
          begin
            Value:=TChartValues(chanReadings);
            Count:=Train_Header.points_cnt;
            Modified:=True;
          end;
        end;
        2:
        begin
          //srsCh3.AddArray(chanReadings);
          { set our X array }
          With srsCh3.XValues do
          begin
            Value:=TChartValues(chanTimeReadings);  { <-- the array }
            Count:=Train_Header.points_cnt;               { <-- number of points }
            Modified:=True;           { <-- recalculate min and max }
          end;

          { set our Y array }
          With srsCh3.YValues do
          begin
            Value:=TChartValues(chanReadings);
            Count:=Train_Header.points_cnt;
            Modified:=True;
          end;
        end;
        3:
        begin
          //srsCh4.AddArray(chanReadings);
          { set our X array }
          With srsCh4.XValues do
          begin
            Value:=TChartValues(chanTimeReadings);  { <-- the array }
            Count:=Train_Header.points_cnt;               { <-- number of points }
            Modified:=True;           { <-- recalculate min and max }
          end;

          { set our Y array }
          With srsCh4.YValues do
          begin
            Value:=TChartValues(chanReadings);
            Count:=Train_Header.points_cnt;
            Modified:=True;
          end;
        end;
        4:
        begin
          //srsCh5.AddArray(chanReadings);
          { set our X array }
          With srsCh5.XValues do
          begin
            Value:=TChartValues(chanTimeReadings);  { <-- the array }
            Count:=Train_Header.points_cnt;               { <-- number of points }
            Modified:=True;           { <-- recalculate min and max }
          end;

          { set our Y array }
          With srsCh5.YValues do
          begin
            Value:=TChartValues(chanReadings);
            Count:=Train_Header.points_cnt;
            Modified:=True;
          end;
        end;
      end;
    except
//     frmMain.memInfo.Lines.Add('Plot error ' + IntToStr(zIdx));
    end;
  end;
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
begin
  Result := false;

  chIdx := 0;
  cnt := 0;

  if not FileExists(Datafile) then Exit;
  sourceFile := Datafile;
  if zOverlay = false then
  begin
    //Clear the main series'.
    for i := 0 to Chart.SeriesCount-1 do
      Chart.Series[i].Clear;
  end;

  for i := 0 to Chart.SeriesCount-1 do
    Chart.Series[i].Visible := false;

  //Chart.LeftAxis.AutomaticMaximum := true;
  //Chart.LeftAxis.AutomaticMinimum := true;
////  Chart.LeftAxis.Maximum := 20;

  OpenDialog.FileName := Datafile;
  fs := TFileStream.Create(Datafile,fmOpenRead or fmShareDenyWrite);
  try
    //[Data_hdr][train_hdr][data][train_hdr][data].....for data_hdr.trainsindata value

    fs.ReadBuffer(Data_Header,sizeof(Data_Header));

    if not CollectChannels(Data_Header) then Exit;

    //if(Data_Header.Version = '100A') then
    //begin
    //  if(Data_Header.TrainsInData > 0) then
//        frmMain.memInfo.Lines.Add(IntToStr(Data_Header.TrainsInData) + ' Trains In Data File')
    //  else
    //  begin
//        frmMain.memInfo.Lines.Add('0 Trains In Data File');
    //    Exit;
    //  end;
    //  activeChans := Data_Header.TrainsInData;
    //end
    //else
    //begin
//      frmMain.memInfo.Lines.Add('Unknown Data Version:'+Data_Header.Version);
    //  Exit;
    //end;

    //////////////Data is avail///////////////////

//    AD_BUFF_DEPTH := Data_Header.TrainsInData
//    updateBuffSize;
//    fs.ReadBuffer(Vers,4);
//    fs.Seek(0,soBeginning);

//    frmMain.ProgressBar1.Position := 0;
    while fs.Position < fs.Size do
    begin
     if(  (activeChans and $01) = 1) then
     begin
        activeChans := activeChans - 1;
        chIdx := 0;
        srsCh1.Visible := true;
     end
     else
     if(  (activeChans and $02) = 2) then
     begin
        activeChans := activeChans - 2;
        chIdx := 1;    
        srsCh2.Visible := true;
     end
     else
     if(  (activeChans and $04) = 4) then
     begin
        activeChans := activeChans - 4;
        chIdx := 2;  
        srsCh3.Visible := true;
     end
     else
     if(  (activeChans and $08) = 8) then
     begin
        activeChans := activeChans - 8;
        chIdx := 3; 
        srsCh4.Visible := true;
     end
     else
     if(  (activeChans and $10) = 16) then
     begin
        activeChans := activeChans - 16;
        chIdx := 4;  
        srsCh5.Visible := true;
     end
     else
        Break;


     //Get train hdr
     offset := sizeof(Data_Header);
     offset := offset + ( chIdx * TRAIN_BLOCK_MEM);



     //make sure next train block is avail in file

     if (fs.Size < (offset+TRAIN_BLOCK_MEM))  then Exit;

     fs.Seek(offset,soBeginning);

     fs.ReadBuffer(Train_Header,sizeof(Train_Header));

      if GetReadings then //get all the readings for one train
      begin
        PlotChannel(chIdx);
        //Inc(chIdx);


        case chIdx of
          0: srsCh1.Title := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[chIdx].train_tm));
          1: srsCh2.Title := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[chIdx].train_tm));
          2: srsCh3.Title := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[chIdx].train_tm));
          3: srsCh4.Title := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[chIdx].train_tm));
          4: srsCh5.Title := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[chIdx].train_tm));
        end;

        Result := true;

        if chIdx > 4 then
        begin
          chIdx := 0;

          
          Result := false;
          Exit;
          //timePos := timePos + timeStep * AD_BUFF_DEPTH;
        end;
      end
      else
      begin
//        frmMain.MemInfo.Lines.Add('Aborted GetReadings');
      end;

//      frmMain.ProgressBar1.Position := Round(100*(fs.Position)/fs.Size);
      Application.ProcessMessages;

    end;
  finally
    fs.Free;
//    frmMain.ProgressBar1.Position := 0;
  end;
  Chart.Title.Text.Clear;


  //StatusBar1.Panels[1].Text := FormatFloat('0',rate) + ' Hz';
  Caption := 'Data Trend - ' + ExtractFileName(Datafile);


end;

procedure TfrmTrace.btnCopyClick(Sender: TObject);
begin
  Chart.CopyToClipboardMetafile(True);
end;

procedure TfrmTrace.btnPrintClick(Sender: TObject);
begin
  ChartPreviewer1.Execute;
end;

procedure TfrmTrace.ApplyPlotSettings;
begin
  //Chart.LeftAxis.AutomaticMinimum := true;
  //Chart.LeftAxis.Minimum := 0;
  //Chart.LeftAxis.AutomaticMaximum := true;
  //Chart.LeftAxis.Maximum := 20;
end;

procedure TfrmTrace.ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  XValue,
  LValue : Double;
begin
  if not (Sender is TChart) then
  begin
    Exit;
  end;

  if (Y < (Sender as TChart).LeftAxis.IStartPos) or
     (Y > (Sender as TChart).LeftAxis.IEndPos) or
     (X < (Sender as TChart).BottomAxis.IStartPos) or
     (X > (Sender as TChart).BottomAxis.IEndPos) then Exit;

  LValue := Chart.LeftAxis.CalcPosPoint(Y);
  XValue := Chart.BottomAxis.CalcPosPoint(X);
  lblPoint.Caption := '(' + FormatDateTime('HH:nn:ss',XValue) + ' ; ' + FormatFloat('0.00',LValue) + ' km/h)';
end;

procedure TfrmTrace.btnViewOldClick(Sender: TObject);
begin
  OpenDialog.InitialDir := TRACE_PATH;
  if not OpenDialog.Execute then Exit;
  PrepareTraceDisplay(OpenDialog.FileName, false);
end;

function TfrmTrace.NearestPoint(ASeries:TChartSeries; x,y:Integer):Integer;
var Difference : Integer;
    tmpDif     : Integer;
    t          : Integer;
begin
  result:=-1;
  Exit;
  Difference:=-1;
  for t:=0 to ASeries.Count-1 do
  begin
    tmpDif:=Round(TeeDistance(ASeries.CalcXPos(t)-x,ASeries.CalcYPos(t)-y));

    if (Difference=-1) or (tmpDif<Difference) then
    begin
      Difference:=tmpDif;
      result:=t;
    end;
  end;
end;

procedure TfrmTrace.SetCallout(AIndex:Integer);
begin
  Exit;
  // Re-position annotation callout
  with ChartTool1.Callout do
  begin
    Visible:=True;
    gIndex := AIndex;
    XPosition:=gSeries.CalcXPos(AIndex);
    YPosition:=gSeries.CalcYPos(AIndex);
    ZPosition:=0;
  end;
  // Change annotation text
  //ChartTool1.Text:='Point: '+IntToStr(AIndex)+#13+
  //                '('+FormatFloat('0.000',gSeries.XValue[AIndex]) + 's ; ' +
  //                 gSeries.ValueMarkText[AIndex] + 'V)';
end;



procedure TfrmTrace.ChartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Exit;
  if Key = VK_LEFT then
  begin
    if gIndex > 0 then
      Dec(gIndex);
    SetCallout(gIndex);
  end
  else if Key = VK_RIGHT then
       begin
         Inc(gIndex);
         SetCallout(gIndex);
       end;
end;

procedure TfrmTrace.ChartClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tmp : integer;
begin
  Exit;
  // Locate nearest point to mouse...
  tmp:=NearestPoint(Series, x, y);

  if tmp<>-1 then
  begin
    ChartTool1.Visible := true;
    gSeries := Series;
    SetCallout(tmp);  // set annotation callout
  end;
  ActiveControl := Chart;
end;

procedure TfrmTrace.ChartMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Exit;
  if WheelDelta > 0 then
    Chart.ZoomPercent(110)
  else
    Chart.ZoomPercent(90);
end;


function TfrmTrace.CalculateSeekStep(zChans, zRawFilt: Byte): Cardinal;
begin
  Result := 0;
  if zRawFilt and 1 = 1 then
  begin
    if zChans and 1 = 1 then Inc(Result,STEP_SIZE);
    if zChans and 2 = 2 then Inc(Result,STEP_SIZE);
    if zChans and 4 = 4 then Inc(Result,STEP_SIZE);
    if zChans and 8 = 8 then Inc(Result,STEP_SIZE);
  end;
  if zRawFilt and 2 = 2 then
  begin
    if zChans and 1 = 1 then Inc(Result,STEP_SIZE);
    if zChans and 2 = 2 then Inc(Result,STEP_SIZE);
    if zChans and 4 = 4 then Inc(Result,STEP_SIZE);
    if zChans and 8 = 8 then Inc(Result,STEP_SIZE);
  end;
end;

function TfrmTrace.ExportSeriesData: Boolean;
var
  i,j : integer;
  fs : TFileStream;
  fileName : string;
begin
  for i := 0 to Chart.SeriesCount-1 do
  begin
    if Chart.Series[i].Visible then
    begin
      fileName := 'C:\Dynamass\Export\' + ChangeFileExt(ExtractFileName(OpenDialog.FileName),'.') + '_' + Chart.Series[i].Title + '.csv';
      try
      finally
        fs.Free;
      end;
    end;
  end;
end;

procedure TfrmTrace.ChartDblClick(Sender: TObject);
begin
  //ChartEditor1.Execute;
end;

procedure TfrmTrace.ChartClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //Chart.LeftAxis.AutomaticMaximum := false;
    //Chart.LeftAxis.Maximum := 20;
  Chart.Repaint;
end;

function TfrmTrace.ExportChartData(fileName : string): Boolean;
var
  i : integer;
  tmpSeriesList: TChartSeriesList;
begin
  Result := false;
  tmpSeriesList := TChartSeriesList.Create;
  try
    Screen.Cursor := crHourGlass;
    i := 0;
    while(i < Chart.SeriesCount) do
    begin
      if not Chart[i].Active then
      begin
        tmpSeriesList.Add(Chart[i]);
        Chart[i].ParentChart := nil;
      end else Inc(i);
    end;

    with TSeriesDataText.Create(Chart) do
    begin
      IncludeHeader:=true;
      IncludeLabels:=true;
      ValueFormat:='0.00';
      TextDelimiter:=',';
      SaveToFile(fileName);
      Free;
    end;

    for i:=tmpSeriesList.Count-1 downto 0 do
    begin
      tmpSeriesList[i].ParentChart := Chart;
    end;
    Result := true;
  finally
    Screen.Cursor := crDefault;
    tmpSeriesList.Free;
  end;
end;

procedure TfrmTrace.btnExportClick(Sender: TObject);
var
  lFilename : string;
begin
  if MessageDlg('Export selected series''?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then Exit;
  lFilename := ChangeFileExt(ExtractFileName(sourceFile),'.csv');
  SaveDialog1.FileName := lFilename;
  if SaveDialog1.Execute then
  begin
    if ExportChartData(SaveDialog1.Filename) then ShowMessage('Data exported!')
    else ShowMessage('An error occurred!');
  end;
end;

end.
