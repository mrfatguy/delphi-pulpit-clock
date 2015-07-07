program pulpit_clock;

uses
  Forms,
  Windows,
  frmMain in 'frmMain.pas' {MainForm},
  pasAnalogClock in 'pasAnalogClock.pas',
  frmInfo in 'frmInfo.pas' {InfoForm},
  frmSettings in 'frmSettings.pas' {SettingsForm},
  frmAbout in 'frmAbout.pas' {AboutForm},
  frmSync in 'adSNTP\frmSync.pas' {SyncForm};

{$R *.RES}

var
  ExtendedStyle: Integer;
begin
  CreateMutex(nil, FALSE, 'PulpitClockMutex');
  if GetLastError() = ERROR_ALREADY_EXISTS then
  begin
        MessageBox(Application.Handle, PChar('Jedna kopia tego programu ju¿ jest uruchomiona!'), 'B³¹d!', $30);
        Halt;
  end;

  ExtendedStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, ExtendedStyle or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  Application.Initialize;
  Application.Title := 'Pulpit Clock 1.30';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TSyncForm, SyncForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
