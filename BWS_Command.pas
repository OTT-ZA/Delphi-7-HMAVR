unit BWS_Command;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin, HMAVR_Var,DateUtils;

type
  TfrmCommand = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    cbT1: TCheckBox;
    cbT2: TCheckBox;
    cbT3: TCheckBox;
    cbT4: TCheckBox;
    BitBtn4: TBitBtn;
    btnOK: TBitBtn;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbT5: TCheckBox;
    procedure cbT1Click(Sender: TObject);
    procedure cbT5Click(Sender: TObject);
    procedure cbT2Click(Sender: TObject);
    procedure cbT3Click(Sender: TObject);
    procedure cbT4Click(Sender: TObject);
  private
    { Private declarations }
    function CheckTotalSelected(chanCount : integer) : Boolean;
  public
    { Public declarations }
    procedure PopulateDisplay(Data_Header : TData_Header);
  end;

var
  frmCommand: TfrmCommand;

implementation

{$R *.dfm}

{ TfrmTraceConfigV3 }

procedure TfrmCommand.PopulateDisplay(Data_Header: TData_Header);
var
  i : word;
begin

   for i := 1 to Data_Header.TrainsInData do
   begin
     case i of
       1: begin
            cbT1.Caption := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[i-1].train_tm));
            cbT1.Enabled := true;
            cbT1.Checked := true;
          end;
       2: begin
            cbT2.Caption := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[i-1].train_tm));
            cbT2.Enabled := true;
            cbT2.Checked := true;
          end;
       3: begin
            cbT3.Caption := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[i-1].train_tm));
            cbT3.Enabled := true;
            cbT3.Checked := true;
          end;
       4: begin
            cbT4.Caption := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[i-1].train_tm));
            cbT4.Enabled := true;
            cbT4.Checked := true;
          end;
       5: begin
            cbT5.Caption := DateTimeToStr(UnixToDateTime(Data_Header.train_hdr[i-1].train_tm));
            cbT5.Enabled := true;
            cbT5.Checked := true;
          end;
     end;

   end;

  //cbRawData.Enabled := (traceHeader.rawFilt and 1) = 1;
  //cbFilteredData.Enabled := (traceHeader.rawFilt and 2) = 2;
  //if (traceHeader.channels and 3) = 3 then
  //begin
  //  cbCh1.Enabled := true;
  //  cbCh1.Checked := true;
  //end;
  //if (traceHeader.channels and 12) = 12 then
  //begin
  //  cbCh3.Enabled := true;
  //  cbCh3.Checked := true;
  //end;
   //case traceHeader.rawFilt of
  //  1,3: begin
  //         cbRawData.Checked := true;
  //       end;
  //  2: begin
  //       cbFilteredData.Checked := true;
  //     end;
  //end;
end;

procedure TfrmCommand.cbT1Click(Sender: TObject);
//var
  //chanCount : integer;
begin
  //chanCount := 0;
  //if cbCh1.Checked = true then Inc(chanCount,2);
  //if cbCh3.Checked = true then Inc(chanCount,2);
  //if not CheckTotalSelected(chanCount) then
  //  (Sender as TCheckBox).Checked := false;
  //if (cbRawData.Checked = true) and (cbFilteredData.Checked = true) then
  //  chanCount := chanCount*2;
  //cbOffset.Enabled := (chanCount < 4);
end;


procedure TfrmCommand.cbT2Click(Sender: TObject);
begin
//
end;

procedure TfrmCommand.cbT3Click(Sender: TObject);
begin
//
end;

procedure TfrmCommand.cbT4Click(Sender: TObject);
begin
//
end;

procedure TfrmCommand.cbT5Click(Sender: TObject);
begin
  //
end;


function TfrmCommand.CheckTotalSelected(chanCount: integer): Boolean;
begin
  //Result := true;
  //if (cbRawData.Checked = true) and (cbFilteredData.Checked = true) then
  //  chanCount := chanCount*2;
  //if chanCount > 4 then Result := false;
end;


end.



