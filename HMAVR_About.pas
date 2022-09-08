unit HMAVR_About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils, jpeg, ShellAPI, frxpngimage, FC_Common;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    lblEmail: TLabel;
    Label4: TLabel;
    lblWeb: TLabel;
    Memo1: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    lblFileVersion: TLabel;
    lblFileDate: TLabel;
    Memo2: TMemo;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.lblEmailClick(Sender: TObject);
begin
  if (Sender is TLabel) then
  with (Sender as Tlabel) do
    ShellExecute(Application.Handle,
                PChar('open'),
                PChar(Hint),
                PChar(0),
                nil,
                SW_NORMAL);
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  lblFileDate.Caption := 'File Date: ' + FormatDateTime('yyyy/mm/dd HH:nn:ss',FileDateToDateTime(FileAge(Application.ExeName)));
  lblFileVersion.Caption := 'File Version: ' + GetFileVersion;
end;

end.

