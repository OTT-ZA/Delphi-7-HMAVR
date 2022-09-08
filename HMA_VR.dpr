program HMA_VR;

uses
  Forms,
  HMAVR_Main in 'HMAVR_Main.pas' {frmMain},
  HMAVR_Var in 'HMAVR_Var.pas',
  HMAVR_Datamodule in 'HMAVR_Datamodule.pas' {DataModule1: TDataModule},
  HMAVR_DataView in 'HMAVR_DataView.pas' {frmDataView},
  HMAVR_About in 'HMAVR_About.pas' {AboutBox},
  FC_Common in '..\..\D7 Extras\FC_Common.pas',
  BWL_Trace in 'BWL_Trace.pas' {frmTrace},
  BWS_TraceConfigV3 in 'BWS_TraceConfigV3.pas' {frmTraceConfigV3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'HMA-VR Configuration Interface';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmTrace, frmTrace);
  Application.CreateForm(TfrmTraceConfigV3, frmTraceConfigV3);
  {$ifdef DB_Version}
    Application.CreateForm(TDataModule1, DataModule1);
  {$endif}
  Application.Run;
end.

