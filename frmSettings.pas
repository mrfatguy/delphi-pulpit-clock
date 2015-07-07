unit frmSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, INIFiles, Registry, ShellAPI, Spin, FoldrDlg, FileCtrl;

type
  TSettingsForm = class(TForm)
    pcMain: TPageControl;
    btnSave: TButton;
    tsSettings: TTabSheet;
    gbRecord: TGroupBox;
    chbSaveRecord: TCheckBox;
    eRecord: TEdit;
    lblActualRecord: TLabel;
    btnClearRecord: TButton;
    chbDeleteOld: TCheckBox;
    gbSynchronise: TGroupBox;
    chbSyncStart: TCheckBox;
    gbSaving: TGroupBox;
    chbSaveFile: TCheckBox;
    eFolder: TEdit;
    btnLoad: TButton;
    lblTimeServer: TLabel;
    cbTimeServer: TComboBox;
    Label3: TLabel;
    btnSyncNow: TButton;
    Label4: TLabel;
    btnCancel: TButton;
    Label1: TLabel;
    gbExtra: TGroupBox;
    Label2: TLabel;
    chbRunAlways: TCheckBox;
    Label5: TLabel;
    seRestartDelay: TSpinEdit;
    lblMinuteDop: TLabel;
    btnShowSyncLog: TButton;
    chbSyncMidnight: TCheckBox;
    chbExportLogs: TCheckBox;
    chbMinimizeToTrayBar: TCheckBox;
    fdMain: TFolderDialog;
    Label7: TLabel;
    chbRandomServer: TCheckBox;
    chbPolishOnly: TCheckBox;

    procedure ReadSettings(FileName, Section: String);
    procedure WriteSettings(FileName, Section: String);
    procedure WriteRegistry();

    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearRecordClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chbSaveRecordClick(Sender: TObject);
    procedure chbSyncStartClick(Sender: TObject);
    procedure chbSaveFileClick(Sender: TObject);
    procedure seRestartDelayChange(Sender: TObject);
    procedure btnShowSyncLogClick(Sender: TObject);
    procedure btnSyncNowClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure chbRandomServerClick(Sender: TObject);
  private
    { Private declarations }
  public
    sSettingsFile: String;
  end;

var
  SettingsForm: TSettingsForm;

implementation

uses frmMain, frmInfo, frmSync;

{$R *.DFM}

procedure TSettingsForm.btnSaveClick(Sender: TObject);
begin
        MainForm.SaveFile := False;
        
        if chbSaveFile.Checked then
        begin
                if MainForm.IsDirectoryValid(eFolder.Text) then
                begin
                        WriteSettings(sSettingsFile, 'Settings');
                        MainForm.SaveFile := True;
                        Close();
                end
                else MessageBox(Application.Handle, PChar('Wskazany folder (' + eFolder.Text + ') jest nieprawid³owy!'), 'B³¹d!', $30);
        end
        else
        begin
                WriteSettings(sSettingsFile, 'Settings');
                Close();
        end;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
        sSettingsFile := ExtractFilePath(Application.ExeName) + 'settings.dat';

        cbTimeServer.ItemIndex := 0;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
        ReadSettings(sSettingsFile, 'Settings');

        eRecord.Text := MainForm.pnlRecordValue.Caption;

        if (eFolder.Text = '') or (not MainForm.IsDirectoryValid(eFolder.Text)) then eFolder.Text := ExtractFilePath(Application.ExeName)
end;

procedure TSettingsForm.btnClearRecordClick(Sender: TObject);
begin
        if Application.MessageBox(PChar('Czy na pewno wyzerowaæ rekord?' + #13 + #10 + 'Ta operacja jest nieodwracalna!'), 'Pytanie...', $124) = ID_NO then exit;

        MainForm.MaxTicks := 0;
        MainForm.WriteSettings();
        MainForm.pnlRecordValue.Caption := MainForm.CalculateUpTime(MainForm.MaxTicks);
        eRecord.Text := MainForm.pnlRecordValue.Caption;
end;

procedure TSettingsForm.btnCancelClick(Sender: TObject);
begin
        Close();
end;

procedure TSettingsForm.ReadSettings(FileName, Section: String);
var
        Ini: TIniFile;
        a: Integer;
        cTemp: TComponent;
begin
        //Jeœli dowolny komponent na formularzu ma Tag = 1 to zostanie
        //dla niego odczytana wartoœæ z pliku konfiguracyjnego, jeœli ma
        //natomiast Tag = 2 to dodatkowo zostanie wykonane jego domyœlne
        //zdarzenie (OnClick, OnChange, etc.)

        //Jeœli plik nie istnieje, zapisz go zczytuj¹c wartoœci domyœlne
        //ustawione przez programistê w DesignTime, bo poni¿sza funkcja
        //ogólna nie potrafi ustawiaæ specyficznych wartoœci domyœlnych

        if not FileExists(FileName) then WriteSettings(FileName, Section);

        Ini := TIniFile.Create(FileName);

        for a := SettingsForm.ComponentCount - 1 downto 0 do
        begin
                cTemp := SettingsForm.Components[a];

                if cTemp.Tag > 0 then
                begin
                        if cTemp is TCheckBox then (cTemp as TCheckBox).Checked := Ini.ReadBool(Section, cTemp.Name, True);
                        if cTemp is TComboBox then (cTemp as TComboBox).ItemIndex := Ini.ReadInteger(Section, cTemp.Name, 0);
                        if cTemp is TSpinEdit then (cTemp as TSpinEdit).Value := Ini.ReadInteger(Section, cTemp.Name, 0);
                        if cTemp is TEdit then (cTemp as TEdit).Text := Ini.ReadString(Section, cTemp.Name, '');
                end;

                if cTemp.Tag = 2 then
                begin
                        if cTemp is TCheckBox then (cTemp as TCheckBox).OnClick(self);
                        if cTemp is TSpinEdit then (cTemp as TSpinEdit).OnChange(self);
                end;
        end;

        Ini.Free;
end;

procedure TSettingsForm.WriteSettings(FileName, Section: String);
var
        Ini: TIniFile;
        a: Integer;
        cTemp: TComponent;
begin
        //Jeœli dowolny komponent na formularzu ma Tag = 1 to zostanie
        //dla niego zapisana jego wartoœæ do pliku konfiguracyjnego.

        Ini := TIniFile.Create(FileName);

        for a := SettingsForm.ComponentCount - 1 downto 0 do
        begin
                cTemp := SettingsForm.Components[a];

                if cTemp.Tag > 0 then
                begin
                        if cTemp is TCheckBox then Ini.WriteBool(Section, cTemp.Name, (cTemp as TCheckBox).Checked);
                        if cTemp is TComboBox then Ini.WriteInteger(Section, cTemp.Name, (cTemp as TComboBox).ItemIndex);
                        if cTemp is TSpinEdit then Ini.WriteInteger(Section, cTemp.Name, (cTemp as TSpinEdit).Value);
                        if cTemp is TEdit then Ini.WriteString(Section, cTemp.Name, (cTemp as TEdit).Text);
                end;
        end;

        Ini.Free;

        WriteRegistry();
end;

procedure TSettingsForm.WriteRegistry();
var
        Reg: TRegistry;
begin
        if chbRunAlways.Checked=True then
        begin
                Reg := TRegistry.Create;
                Reg.RootKey := HKEY_CURRENT_USER;
                Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
                Reg.WriteString('Pulpit Clock', '"'+Application.ExeName+'"');
                Reg.CloseKey;
                Reg.Free;
        end
        else
        begin
                Reg := TRegistry.Create;
                Reg.RootKey := HKEY_CURRENT_USER;
                Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
                Reg.DeleteValue('Pulpit Clock');
                Reg.CloseKey;
                Reg.Free;
        end;
end;

procedure TSettingsForm.chbSaveRecordClick(Sender: TObject);
begin
        chbDeleteOld.Enabled := chbSaveRecord.Checked;
        lblActualRecord.Enabled := chbSaveRecord.Checked;
        eRecord.Enabled := chbSaveRecord.Checked;
end;

procedure TSettingsForm.chbSyncStartClick(Sender: TObject);
begin
        lblTimeServer.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;
        cbTimeServer.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;
        btnSyncNow.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;
        chbRandomServer.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;
        btnShowSyncLog.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;
        chbPolishOnly.Enabled := chbSyncStart.Checked or chbSyncMidnight.Checked;

        chbRandomServerClick(self);
end;

procedure TSettingsForm.chbSaveFileClick(Sender: TObject);
begin
        eFolder.Enabled := chbSaveFile.Checked;
        btnLoad.Enabled := chbSaveFile.Checked;
        chbExportLogs.Enabled := chbSaveFile.Checked;
end;

procedure TSettingsForm.seRestartDelayChange(Sender: TObject);
begin
        case InfoForm.DopelnijPoPolsku(seRestartDelay.Value) of
                1: lblMinuteDop.Caption := 'minuta';
                2: lblMinuteDop.Caption := 'minuty';
                3: lblMinuteDop.Caption := 'minut';
        end;
end;

procedure TSettingsForm.btnShowSyncLogClick(Sender: TObject);
begin
        SyncForm.pcMain.ActivePageIndex := 1;
        SyncForm.pcMainChange(self);
        SyncForm.ShowModal();
end;

procedure TSettingsForm.btnSyncNowClick(Sender: TObject);
begin
        if not SyncForm.Connected then
        begin
                MessageBox(Application.Handle, PChar('Brak po³¹czenia z Internetem!'), 'B³¹d!', $30);
                Exit;
        end;

        SyncForm.pcMain.ActivePageIndex := 0;
        SyncForm.pcMainChange(self);
        SyncForm.mInfo.Clear();
        SyncForm.SyncFireTimer.Enabled := True;
        SyncForm.ShowModal();
end;

procedure TSettingsForm.btnLoadClick(Sender: TObject);
begin
        if (eFolder.Text = '') or (not MainForm.IsDirectoryValid(eFolder.Text)) then
                fdMain.Directory := ExtractFilePath(Application.ExeName)
        else
                fdMain.Directory := eFolder.Text;

        if not fdMain.Execute then exit;

        if MainForm.IsDirectoryValid(fdMain.Directory) then
                eFolder.Text := IncludeTrailingBackSlash(fdMain.Directory)
        else
                MessageBox(Application.Handle, PChar('Wskazany folder  jest nieprawid³owy!'), 'B³¹d!', $30);
end;

procedure TSettingsForm.chbRandomServerClick(Sender: TObject);
begin
        cbTimeServer.Enabled := (not chbRandomServer.Checked) and (chbSyncStart.Checked or chbSyncMidnight.Checked);
        lblTimeServer.Enabled := (not chbRandomServer.Checked) and (chbSyncStart.Checked or chbSyncMidnight.Checked);

        chbPolishOnly.Enabled := (chbRandomServer.Checked) and (chbSyncStart.Checked or chbSyncMidnight.Checked);
end;

end.
