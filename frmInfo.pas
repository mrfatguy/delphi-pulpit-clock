unit frmInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TInfoForm = class(TForm)
    pcMain: TPageControl;
    tsLog: TTabSheet;
    tsInfo: TTabSheet;
    mInfo: TMemo;
    fList: TListView;
    btnClose: TButton;
    btnDeleteLog: TButton;
    tsHistory: TTabSheet;
    mHistory: TMemo;
    pnlTimeLabel: TPanel;
    Panel1: TPanel;
    pnlEmptyLog: TPanel;
    Panel2: TPanel;
    pnlSystemInstall: TPanel;
    function DopelnijPoPolsku(Value: Integer): Integer;

    procedure RefreshList();

    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
  private
    { Private declarations }
  public
    sLogFile: String;
    InstallDate: TDateTime;
  end;

var
  InfoForm: TInfoForm;

implementation

uses frmMain;

{$R *.DFM}

procedure TInfoForm.btnCloseClick(Sender: TObject);
begin
        Close();
end;

procedure TInfoForm.RefreshList();
var
        slLog, slLogEntry: TStringList;
        iTicks, a, b: Integer;
        sTemp: String;
        lst: TListItem;
begin
        slLog := TStringList.Create();

        if FileExists(sLogFile) then
        begin
                fList.Items.Clear;
                slLog.LoadFromFile(sLogFile);

                if slLog.Count = 0 then
                begin
                        pnlEmptyLog.Caption := 'Dziennik zdarzeñ jest pusty';
                        btnDeleteLog.Enabled := False;
                        slLog.Free;
                        Exit;
                end;

                fList.Items.BeginUpdate;

                b := DopelnijPoPolsku(slLog.Count);
                case b of
                        1: pnlEmptyLog.Caption := 'Dziennik zawiera ' + IntToStr(slLog.Count) + ' zdarzenie';
                        2: pnlEmptyLog.Caption := 'Dziennik zawiera ' + IntToStr(slLog.Count) + ' zdarzenia';
                        3: pnlEmptyLog.Caption := 'Dziennik zawiera ' + IntToStr(slLog.Count) + ' zdarzeñ';
                end;

                btnDeleteLog.Enabled := True;

                for a := 0 to slLog.Count - 1 do
                begin
                        sTemp := slLog.Strings[a];
                        slLogEntry := MainForm.Split(sTemp, '|');

                        lst := fList.Items.Add;
                        lst.Caption := slLogEntry[0];

                        case StrToIntDef(slLogEntry[1], 0) of
                                1: lst.SubItems.Add('Uruchomienie komputera');
                                2: lst.SubItems.Add('Restart komputera');
                                3: lst.SubItems.Add('Zamkniêcie systemu');
                                4: lst.SubItems.Add('Rekord d³ugoœci dzia³ania');
                        end;

                        iTicks := StrToIntDef(slLogEntry[2], 0);

                        if iTicks > 0 then
                                lst.SubItems.Add(MainForm.CalculateUpTime(iTicks))
                        else
                                lst.SubItems.Add('--');

                        lst.SubItems.Add(FormatFloat('#, "MB"', StrToInt64Def(slLogEntry[3], 0) div 1048576));
                        lst.SubItems.Add(FormatFloat('#, "MB"', StrToInt64Def(slLogEntry[4], 0) div 1048576));
                        lst.SubItems.Add(FormatFloat('#, "MB"', StrToInt64Def(slLogEntry[5], 0) div 1048576));

                        fList.Items.EndUpdate;
                end;
        end
        else btnDeleteLog.Enabled := False;

        slLog.Free;
end;

procedure TInfoForm.FormCreate(Sender: TObject);
var
        sHistoryFile, sInfoFile: String;
begin
        sLogFile := ExtractFilePath(Application.ExeName) + 'log.dat';
        sHistoryFile := ExtractFilePath(Application.ExeName) + 'history.txt';
        sInfoFile := ExtractFilePath(Application.ExeName) + 'info.txt';

        if FileExists(sHistoryFile) then mHistory.Lines.LoadFromFile(sHistoryFile);
        if FileExists(sInfoFile) then mInfo.Lines.LoadFromFile(sInfoFile);
end;

procedure TInfoForm.btnDeleteLogClick(Sender: TObject);
var
        slLog: TStringList;
begin
        if Application.MessageBox(PChar('Czy na pewno wyczyœciæ zawartoœæ dziennika zdarzeñ?' + #13 + #10 + 'Ta operacja jest NIEODWRACALNA!'), 'Pytanie...', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_APPLMODAL) = ID_NO then exit;

        slLog := TStringList.Create();
        slLog.Clear;
        slLog.SaveToFile(sLogFile);
        slLog.Free;

        RefreshList();
end;

procedure TInfoForm.FormShow(Sender: TObject);
begin
        RefreshList();

        mInfo.Text := Trim(mInfo.Text);
        mHistory.Text := Trim(mHistory.Text);
end;

procedure TInfoForm.pcMainChange(Sender: TObject);
begin
        btnDeleteLog.Visible := (pcMain.ActivePageIndex = 0)
end;

function TInfoForm.DopelnijPoPolsku(Value: Integer): Integer;
var
        iLast, iLastTwo: Integer;
begin
        //Funkcja zwraca wartoœæ 1-3 w zale¿noœci, od tego jakie dope³nienie powinno byæ:
        //1 - "a": tylko dla jednoœci, np. 1 sekunda, 1 minuta, 1 godzina
        //2 - "y": dla wartoœci jednoœci 2-4, np. 2 sekundy, 22 minuty, 194 godziny (bez liczb 11-19),
        //3 - "[puste]": dla jednoœci (np. 21 sekund), liczb 11-19 (np. 14 minut, 217 godzin) i wszystkich pozosta³ych.

        Result := 3; //Domyœlnie 3, bo najwiêcej liczb spe³nia trzeci warunek

        iLast := StrToIntDef(Copy(IntToStr(Value), Length(IntToStr(Value)), 1),0);
        iLastTwo := StrToIntDef(Copy(IntToStr(Value), Length(IntToStr(Value))-1, 2),0);

        if (iLast > 1) and (iLast < 5) then Result := 2; //Liczby z 2-4 na pozycji jednoœci - drugi warunek

        if (iLastTwo > 10) and (iLastTwo < 20) then Result := 3; //Wymuszenie warunku 3 dla liczb maj¹cych 11-19 na pozycji dziesi¹tek

        if Value = 1 then Result := 1;//Jedyny taki przypadek - warunek pierwszy spe³nia tylko cyfra 1.
end;

end.
