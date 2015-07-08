unit frmAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, ShellAPI, TFlatHintUnit;

type
  TAboutForm = class(TForm)
    imgLogo: TImage;
    lblURL: TLabel;
    Label11: TLabel;
    lblName: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    imgInscription: TImage;
    procedure GoToURL(Sender: TObject);
    procedure CloseWindow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

procedure TAboutForm.GoToURL(Sender: TObject);
begin
        ShellExecute(Handle,'open','http://www.gaman.pl/','','',SW_SHOW);
end;

procedure TAboutForm.CloseWindow(Sender: TObject);
begin
        Close;
end;

procedure TAboutForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if Key=27 then Close;
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
        lblName.Caption := Application.Title;
end;

end.
