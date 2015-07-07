unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, pasAnalogClock, ComCtrls, OleCtrls, Menus, inifiles,
  CoolTrayIcon, ShockwaveFlashObjects_TLB, Math, ThemeMgr, FileCtrl, ComObj,
  ActiveX, UrlMon;

type
  TLogEntry = record
        DateTime: TDateTime;
        Text: String;
        FreeRAM: Cardinal;
        FreeRes: Cardinal;
        FreePage: Cardinal;
  end;

type
  TMainForm = class(TForm)
    MainTimer: TTimer;
    pnlMain: TPanel;
    pnlClock: TPanel;
    imgClock: TImage;
    pnlCurrentTimeValue: TPanel;
    pnlStartedLabel: TPanel;
    pnlStartedValue: TPanel;
    pnlTimeLabel: TPanel;
    pnlTimeValue: TPanel;
    pnlRecordLabel: TPanel;
    pnlRecordValue: TPanel;
    pnlInfo: TPanel;
    Panel1: TPanel;
    g2: TProgressBar;
    g1: TProgressBar;
    lblPhysMem: TLabel;
    lblVirtualMem: TLabel;
    lblPageFileMem: TLabel;
    g3: TProgressBar;
    sfMain: TShockwaveFlash;
    pmMain: TPopupMenu;
    mnuLog: TMenuItem;
    mnuMinimize: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    ctiMain: TCoolTrayIcon;
    mnuConfig: TMenuItem;
    mnuAbout: TMenuItem;
    tmMain: TThemeManager;
    MinimizeTimer: TTimer;

    function CalculateUpTime(Ticks: Longword): String; overload;
    function CalculateUpTime_Long(DateTime: TDateTime): String;
    function CalculateStartTime(Ticks: Longword): String;
    function ConvertStringToDate(Date: String): TDateTime;
    function Split(StringToSplit: String; DelimeterChar: String): TStringList;
    function BuildLogEntry(Date: TDateTime; Mode: Integer): String;
    function DateTimeToPolishString(DateTime: TDateTime): String;
    function IsMidnight(): Boolean;
    function IsFullHour(): Boolean;
    function IsMidday(): Boolean;
    function IsDirectoryValid(Directory: String): Boolean;
    function GetSystemInstallationDate(): TDateTime;

    procedure CheckForRecord();
    procedure SetupClock();
    procedure DrawClock();
    procedure ReadSettings();
    procedure WriteSettings();
    procedure WriteLog(Date: TDateTime; Mode: Integer);
    procedure UpdateInfo();
    procedure WriteTempFile();
    procedure ReadTempFile();
    procedure DeleteTempFile();
    procedure WriteExternalFile(Directory: String);
    procedure WriteExternalLogs(Directory: String);
    procedure StartupSynchronize();

    procedure WMEndSession(var Msg: TWMEndSession); message WM_ENDSESSION;
    procedure CloseApp(IsEndSession: Boolean);

    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure lblInfoClick(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlInfoClick(Sender: TObject);
    procedure PerformMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuLogClick(Sender: TObject);
    procedure mnuMinimizeClick(Sender: TObject);
    procedure mnuConfigClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MinimizeTimerTimer(Sender: TObject);
  private
    function CalculateUpTime(DateTime: TDateTime): String; overload;
  public
    RecordTick: Integer;
    MaxTicks: Longword;
    Options: TClockOptions;
    sSettingsFile, sLogFile: String;
    MidnightSynchronizeAlreadyPerformed, StartupSynchronizeAlreadyPerformed, SaveFile, FlashFileAvailable: Boolean;
    StartDate: TDateTime;

    function GetTimeServer(): String;
  end;

var
  MainForm: TMainForm;

const
  TicksPerDay: Cardinal = 1000 * 60 * 60 * 24;
  TicksPerHour: Cardinal = 1000 * 60 * 60;
  TicksPerMinute: Cardinal = 1000 * 60;
  TicksPerSecond: Cardinal = 1000;

  asMonths: array [1..12] of String = ('stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca', 'lipca', 'sierpnia', 'wrzeœnia', 'paŸdziernika', 'listopada', 'grudnia');

  OneMinute: Double = 0.000694444444444444;
  OneSecond: Double = 0.0000115740740740741;

  DefaultTimeServerTimeout: Integer = 2500;

implementation

uses frmInfo, frmSettings, frmAbout, frmSync;

{$R *.DFM}
{$R WinXP.res}

procedure TMainForm.CloseApp(IsEndSession: Boolean);
begin
        WriteSettings();
        CheckForRecord();
        DeleteTempFile();

        if IsEndSession then WriteLog(Now(), 3);

        Application.Terminate();
end;

procedure TMainForm.ReadSettings();
var
        Ini: TIniFile;
begin
        Ini := TIniFile.Create(sSettingsFile);

        MaxTicks := Ini.ReadInteger('Data', 'MaxTicks', GetTickCount());
        StartDate := Ini.ReadDateTime('Data', 'StartDate', Now());
        SaveFile := Ini.ReadBool('Settings', 'chbSaveFile', False);
        MainForm.Left := Ini.ReadInteger('Data', 'Left', Screen.Width - MainForm.Width - 11);
        MainForm.Top := Ini.ReadInteger('Data', 'Top', Screen.Height - MainForm.Height - 42);
        Ini.Free;

        //if not FileExists(sSettingsFile) then WriteSettings();
end;

procedure TMainForm.WriteSettings();
var
        Ini: TIniFile;
begin
        Ini := TIniFile.Create(sSettingsFile);
        Ini.WriteInteger('Data', 'MaxTicks', MaxTicks);
        Ini.WriteInteger('Data', 'Left', MainForm.Left);
        Ini.WriteInteger('Data', 'Top', MainForm.Top);
        Ini.WriteDateTime('Data', 'StartDate', StartDate);
        Ini.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
        sFlashFile: String;
begin
        sFlashFile := ExtractFilePath(Application.ExeName) + 'clock.dat';
        if FileExists(sFlashFile) then
        begin
                FlashFileAvailable := True;
                sfMain.Movie := sFlashFile;
                sfMain.Visible := True;
                imgClock.Visible := False;
                sfMain.Playing := True;
        end
        else
        begin
                FlashFileAvailable := False;
                sfMain.Visible := False;
                sfMain.Align := alNone;
                sfMain.Width := 0;
                sfMain.Height := 0;
                imgClock.Visible := True;
        end;

        sSettingsFile := ExtractFilePath(Application.ExeName) + 'settings.dat';
        sLogFile := ExtractFilePath(Application.ExeName) + 'log.dat';

        ReadSettings();
        RecordTick := 0;

        if not FlashFileAvailable then
        begin
                SetupClock();
                DrawClock();
        end;

        UpdateInfo();

        pnlTimeValue.Caption := CalculateUpTime(GetTickCount());
        pnlRecordValue.Caption := CalculateUpTime(MaxTicks);
        pnlCurrentTimeValue.Caption := FormatDateTime('hh:nn:ss', Time);

        ctiMain.Hint := Application.Title;
        MainForm.Caption := Application.Title;

        mnuMinimize.ShortCut := ShortCut(VK_F1, [ssAlt]);
        mnuLog.ShortCut := ShortCut(VK_F2, [ssAlt]);
        mnuConfig.ShortCut := ShortCut(VK_F3, [ssAlt]);
        mnuExit.ShortCut := ShortCut(VK_F4, [ssAlt]);

        ReadTempFile();

        StartupSynchronizeAlreadyPerformed := False;
        MidnightSynchronizeAlreadyPerformed := False;

        Randomize();
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TMainForm.MainTimerTimer(Sender: TObject);
var
        sInstall: String;
        dtInstall: TDateTime;
begin
        pnlTimeValue.Caption := CalculateUpTime(GetTickCount());
        ctiMain.Hint := Application.Title + ' [' + pnlTimeValue.Caption + ']';

        InfoForm.pnlTimeLabel.Caption := ' ' + DateTimeToPolishString(StartDate) + ' (' + CalculateUpTime(StartDate) + ' temu)';

        dtInstall := GetSystemInstallationDate();
        sInstall := DateTimeToPolishString(dtInstall) + ' (' + CalculateUpTime_Long(dtInstall) + ' temu)';
        InfoForm.pnlSystemInstall.Caption := ' ' + sInstall;

        Inc(RecordTick);
        if RecordTick = 11 then
        begin
                RecordTick := 0;
                CheckForRecord();

                WriteTempFile();

                if (SaveFile) and (IsDirectoryValid(SettingsForm.eFolder.Text)) then WriteExternalFile(SettingsForm.eFolder.Text);

                if not StartupSynchronizeAlreadyPerformed then StartupSynchronize();
        end;

        if IsFullHour() then if (SaveFile) and (SettingsForm.chbExportLogs.Checked) and (IsDirectoryValid(SettingsForm.eFolder.Text)) then WriteExternalLogs(SettingsForm.eFolder.Text);

        if IsMidday() then if MidnightSynchronizeAlreadyPerformed = True then MidnightSynchronizeAlreadyPerformed := False;

        if (IsMidnight()) and (not MidnightSynchronizeAlreadyPerformed) then
        begin
                if SettingsForm.chbSyncMidnight.Checked then
                begin
                        if not SyncForm.Connected() then
                        begin
                                with SyncForm.mInfo.Lines do
                                begin
                                        Clear();
                                        Add('*** Brak dostêpu do Internetu! Synchronizacja przerwana! ***');
                                        MidnightSynchronizeAlreadyPerformed := False;
                                end;
                        end
                        else
                        begin
                                SyncForm.SynchronizeTime(GetTimeServer(), DefaultTimeServerTimeout);
                                MidnightSynchronizeAlreadyPerformed := True;
                        end;
                end;
        end;

        if not FlashFileAvailable then DrawClock();
        pnlCurrentTimeValue.Caption := FormatDateTime('hh:nn:ss', Time);

        UpdateInfo();
end;

procedure TMainForm.StartupSynchronize();
var
        Day, Hour, Min: Word;
        Ticks: Longword;
begin
        if StartupSynchronizeAlreadyPerformed then Exit;
        
        Ticks := GetTickCount();

        Day := Ticks div TicksPerDay;
        Dec(Ticks, Day * TicksPerDay);

        Hour := Ticks div TicksPerHour;
        Dec(Ticks, Hour * TicksPerHour);

        Min := Ticks div TicksPerMinute;

        //Synchronizacja zegara przy starcie
        if (Day = 0) and (Hour = 0) and (Min = SettingsForm.seRestartDelay.Value) then
        begin
                if SettingsForm.chbSyncStart.Checked then
                begin
                        if not SyncForm.Connected() then
                        begin
                                with SyncForm.mInfo.Lines do
                                begin
                                        Clear();
                                        Add('*** Brak dostêpu do Internetu! Synchronizacja przerwana! ***');
                                        StartupSynchronizeAlreadyPerformed := False;
                                end;
                        end
                        else
                        begin
                                SyncForm.SynchronizeTime(GetTimeServer(), DefaultTimeServerTimeout);
                                StartupSynchronizeAlreadyPerformed := True;
                        end;
                end;
        end;
end;

function TMainForm.CalculateUpTime(Ticks: Longword): String;
var
        Day, Hour, Min, Sec: Word;
        sDay, sHour, sMin, sSec: String;
begin
        Day := Ticks div TicksPerDay;
        Dec(Ticks, Day * TicksPerDay);

        Hour := Ticks div TicksPerHour;
        Dec(Ticks, Hour * TicksPerHour);

        Min := Ticks div TicksPerMinute;
        Dec(Ticks, Min * TicksPerMinute);

        Sec := Ticks div TicksPerSecond;

        sHour := IntToStr(Hour); if Hour < 10 then sHour := '0' + sHour;
        sMin := IntToStr(Min); if Min < 10 then sMin := '0' + sMin;
        sSec := IntToStr(Sec); if Sec < 10 then sSec := '0' + sSec;

        sDay := IntToStr(Day);
        if Day = 1 then sDay := sDay + ' dzieñ' else sDay := sDay + ' dni';

        Result := sDay + ' ' + sHour + ':' + sMin + ':' + sSec;
end;

function TMainForm.CalculateUpTime(DateTime: TDateTime): String;
var
        Day, Hour, Min, Sec, MSec: Word;
        sDay, sHour, sMin, sSec: String;
        TheDate: TDateTime;
begin
        TheDate := Now() - DateTime;
        Day := Floor(Now() - DateTime);
        DecodeTime(TheDate, Hour, Min, Sec, MSec);

        sHour := IntToStr(Hour); if Hour < 10 then sHour := '0' + sHour;
        sMin := IntToStr(Min); if Min < 10 then sMin := '0' + sMin;
        sSec := IntToStr(Sec); if Sec < 10 then sSec := '0' + sSec;

        sDay := IntToStr(Day);
        if Day = 1 then sDay := sDay + ' dzieñ' else sDay := sDay + ' dni';

        Result := sDay + ' ' + sHour + ':' + sMin + ':' + sSec;
end;

function TMainForm.CalculateUpTime_Long(DateTime: TDateTime): String;
var
        Year, Month, Day, Hour, Min, Sec, MSec: Word;
        sYear, sMonth, sDay, sHour, sMin, sSec: String;
        TheDate: TDateTime;
        d: Integer;
begin
        TheDate := Now() - DateTime;
        DecodeDate(TheDate, Year, Month, Day);
        DecodeTime(TheDate, Hour, Min, Sec, MSec);

        sHour := IntToStr(Hour); if Hour < 10 then sHour := '0' + sHour;
        sMin := IntToStr(Min); if Min < 10 then sMin := '0' + sMin;
        sSec := IntToStr(Sec); if Sec < 10 then sSec := '0' + sSec;

        sDay := IntToStr(Day);
        if Day = 1 then sDay := sDay + ' dzieñ' else sDay := sDay + ' dni';

        d := InfoForm.DopelnijPoPolsku(Month);
        case d of
                1: sMonth := IntToStr(Month) + ' miesi¹c';
                2: sMonth := IntToStr(Month) + ' miesi¹ce';
                3: sMonth := IntToStr(Month) + ' miesiêcy';
        end;
        if Month = 0 then sMonth := '' else sMonth := sMonth + ', ';

        Year := Year - 1900;
        d := InfoForm.DopelnijPoPolsku(Year);
        case d of
                1: sYear := IntToStr(Year) + ' rok';
                2: sYear := IntToStr(Year) + ' lata';
                3: sYear := IntToStr(Year) + ' lat';
        end;
        if Year = 0 then sYear := '' else sYear := sYear + ', ';

        Result := sYear + sMonth + sDay + ' i ' + sHour + ':' + sMin + ':' + sSec;
end;

function TMainForm.IsMidnight(): Boolean;
var
        Hour, Min, Sec, MSec: Word;
begin
        DecodeTime(Now(), Hour, Min, Sec, MSec);

        Result := (Hour = 0) and (Min = 0) and (Sec = 0);
end;

function TMainForm.IsMidday(): Boolean;
var
        Hour, Min, Sec, MSec: Word;
begin
        DecodeTime(Now(), Hour, Min, Sec, MSec);

        Result := (Hour = 12) and (Min = 0) and (Sec = 0);
end;

function TMainForm.IsFullHour(): Boolean;
var
        Hour, Min, Sec, MSec: Word;
begin
        DecodeTime(Now(), Hour, Min, Sec, MSec);

        Result := (Min = 0) and (Sec = 0);
end;

function TMainForm.CalculateStartTime(Ticks: Longword): String;
var
        Year, Month, Day, Hour, Min, Sec, MSec: Word;
        sDate: String;
        TheDate: TDateTime;
begin
        Day := Ticks div TicksPerDay;
        Dec(Ticks, Day * TicksPerDay);

        Hour := Ticks div TicksPerHour;
        Dec(Ticks, Hour * TicksPerHour);

        Min := Ticks div TicksPerMinute;
        Dec(Ticks, Min * TicksPerMinute);

        Sec := Ticks div TicksPerSecond;

        TheDate := Now() - Day - EncodeTime(Hour, Min, Sec, 0);

        DecodeDate(TheDate, Year, Month, Day);
        DecodeTime(TheDate, Hour, Min, Sec, MSec);

        sDate := IntToStr(Day) + ' ' + asMonths[Month] + ' ' + IntToStr(Year);
        Result := sDate + ' o ' + TimeToStr(TheDate);
end;

function TMainForm.DateTimeToPolishString(DateTime: TDateTime): String;
var
        Year, Month, Day: Word;
        sDate: String;
begin
        DecodeDate(DateTime, Year, Month, Day);

        sDate := IntToStr(Day) + ' ' + asMonths[Month] + ' ' + IntToStr(Year);
        Result := sDate + ' o ' + TimeToStr(DateTime);
end;

procedure TMainForm.CheckForRecord();
var
        lwNow: Longword;
        slLog, slLogEntry: TStringList;
        a, iMode: Integer;
begin
        lwNow := GetTickCount();

        if lwNow > MaxTicks then
        begin
                //Jeœli rekord - zapamiêtaj go

                MaxTicks := lwNow;
                WriteSettings();

                //Jeœli jest zapisywanie rekordów w dzienniku
                if SettingsForm.chbSaveRecord.Checked then
                begin
                        // Jeœli jest kasowanie starych rekordów
                        if SettingsForm.chbDeleteOld.Checked then
                        begin
                                slLog := TStringList.Create();

                                if FileExists(sLogFile) then
                                begin
                                        slLog.LoadFromFile(sLogFile);
                                        //slLogTemp.Assign(slLog);

                                        if slLog.Count > 0 then
                                        begin
                                                a := 0;

                                                while a < slLog.Count do
                                                begin
                                                        slLogEntry := Split(slLog.Strings[a], '|');
                                                        iMode := StrToIntDef(slLogEntry[1], 0);
                                                        slLogEntry.Free;

                                                        if iMode = 4 then slLog.Delete(a);
                                                        Inc(a);
                                                end;

                                                slLog.SaveToFile(sLogFile);
                                                slLog.Free;
                                        end;
                                end;
                        end;

                        //Zapisanie faktu wyst¹pienia rekordu w dzienniku
                        WriteLog(Now(), 4);
                end;
        end;

        pnlRecordValue.Caption := CalculateUpTime(MaxTicks);
        SettingsForm.eRecord.Text := pnlRecordValue.Caption;
end;

procedure TMainForm.SetupClock();
begin
        Options.HourWidth := 3;
        Options.HourColor := clBlack;
        Options.HourStyle := psSolid;
        Options.SecondWidth := 1;
        Options.SecondColor := clRed;
        Options.SecondStyle := psSolid;
        Options.MinuteWidth := 3;
        Options.MinuteColor := clBlack;
        Options.MinuteStyle := psSolid;
end;

procedure TMainForm.DrawClock();
begin
        imgClock.Canvas.Brush.Color := clBtnFace;
        imgClock.Canvas.FillRect(Rect(0, 0, imgClock.Width, imgClock.Height));

        DrawClockShield(imgClock.Canvas, 90, 42, 6, 2, clBlack);
        DrawAnalogClock(Time, imgClock.Canvas, 90, 42, 6, Options);
end;

procedure TMainForm.lblInfoClick(Sender: TObject);
begin
        MainForm.Height := 440;
end;

procedure TMainForm.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
        pnlInfo.BevelOuter := bvLowered;
end;

procedure TMainForm.pnlInfoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
        pnlInfo.BevelOuter := bvRaised;
end;

procedure TMainForm.pnlInfoClick(Sender: TObject);
begin
        pnlInfo.BevelOuter := bvRaised;
        pmMain.Popup(Left + pnlInfo.Left + 7, Top + pnlInfo.Top + 37);
end;

procedure TMainForm.PerformMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
        if ssLeft in Shift then
        begin
                ReleaseCapture;
                MainForm.Perform(WM_SysCommand, $F012, 0);
        end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        CloseApp(False);
end;

procedure TMainForm.WriteLog(Date: TDateTime; Mode: Integer);
var
        slLog, slLogEntry: TStringList;
        sLogEntry, sTemp: String;
        dtTemp: TDateTime;
        CanWrite: Boolean;
        iMode: Integer;
begin
        CanWrite := True;
        iMode := 0;

        slLog := TStringList.Create();
        if FileExists(sLogFile) then slLog.LoadFromFile(sLogFile);

        if slLog.Count > 0 then
        begin
                sTemp := slLog.Strings[slLog.Count - 1];
                slLogEntry := Split(sTemp, '|');

                dtTemp := StrToDateTime(slLogEntry[0]);
                iMode := StrToIntDef(slLogEntry[1], 0);

                slLogEntry.Free;

                if (Abs(Date-dtTemp) <= (OneSecond * 7)) and (iMode < 3) then CanWrite := False; //7 sekund opóŸnienia - zabezpieczenie dla Ÿle obliczonej daty

                if (Abs(Date-dtTemp) <= (OneMinute * SettingsForm.seRestartDelay.Value)) and (iMode = 3) and (Mode = 1) then //7 minut - je¿eli start nast¹pi³ w tyle lub krócej po ostatniej operacji (któr¹ by³o zamkniêcie), wówczas mo¿na za³o¿yæ, ¿e by³ restart tylko...
                begin
                        CanWrite := True;
                        Mode := 2;
                end;

                if Date < dtTemp then CanWrite := False;
        end;

        if CanWrite then
        begin
                sLogEntry := BuildLogEntry(Date, Mode);

                if (iMode = 4) and (Mode = 4) then
                        slLog[slLog.Count - 1] := sLogEntry
                else
                        slLog.Add(sLogEntry);

                slLog.SaveToFile(sLogFile);
        end;

        slLog.Free;
end;

function TMainForm.ConvertStringToDate(Date: String): TDateTime;
var
        a: Integer;
        sTime, sDate, sYear, sMonth, sDay: String;
        dtDate, dtTime: TDateTime;
begin
        sDay := Copy(Date, 1, Pos(' ', Date) - 1);
        if Length(sDay) = 1 then sDay := '0' + sDay;
        sMonth := Copy(Date, Pos(' ', Date) + 1, Length(Date));
        sYear := Copy(sMonth, Pos(' ', sMonth) + 1, 4);
        sMonth := Copy(sMonth, 1, Pos(' ', sMonth) - 1);

        for a := 1 to 12 do
        begin
                if asMonths[a] = sMonth then
                begin
                        sMonth := IntToStr(a);
                        if a < 10 then sMonth := '0' + sMonth;
                        Break;
                end;
        end;

        sDate := sYear + DateSeparator + sMonth + DateSeparator + sDay;

        {sDate := ShortDateFormat;
        sDate := StringReplace(sDate, 'yyyy', sYear, [rfIgnoreCase]);
        sDate := StringReplace(sDate, 'mm', sMonth, [rfIgnoreCase]);
        sDate := StringReplace(sDate, 'dd', sDay, [rfIgnoreCase]);}

        sTime := Copy(Date, Pos(' o ', Date) + 3, 8);

        dtDate := StrToDate(sDate);
        dtTime := StrToTime(sTime);

        Result := dtDate + dtTime;
end;

procedure TMainForm.UpdateInfo();
var
        MemStatus: TMemoryStatus;
        memS: String;
        iPrec: Integer;
begin
        MemStatus.dwLength := SizeOf(MemStatus);
        GlobalMemoryStatus(MemStatus);

        iPrec := Byte(Round(MemStatus.dwAvailPhys / (MemStatus.dwTotalPhys / 100)));
        memS := 'Pamiêæ fizyczna: ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwAvailPhys div 1048576) + ' z ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwTotalPhys div 1048576);
        memS := memS + ' (' + IntToStr(iPrec) + '%) wolne';
        lblPhysMem.Caption := memS;

        iPrec := Byte(Round(MemStatus.dwAvailVirtual / (MemStatus.dwTotalVirtual / 100)));
        memS := 'Pamiêæ wirtualna: ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwAvailVirtual div 1048576) + ' z ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwTotalVirtual div 1048576);
        memS := memS + ' (' + IntToStr(iPrec) + '%) wolne';
        lblVirtualMem.Caption := memS;

        iPrec := Byte(Round(MemStatus.dwAvailPageFile / (MemStatus.dwTotalPageFile / 100)));
        memS := 'Pamiêæ stronnicowania: ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwAvailPageFile div 1048576) + ' z ';
        memS := memS + FormatFloat('#, "MB"', MemStatus.dwTotalPageFile div 1048576);
        memS := memS + ' (' + IntToStr(iPrec) + '%) wolne';
        lblPageFileMem.Caption := memS;

        g1.Max := Round(MemStatus.dwTotalPhys div 1000);
        g1.Position := Round(MemStatus.dwAvailPhys div 1000);
        g2.Max := Round(MemStatus.dwTotalVirtual div 1000);
        g2.Position := Round(MemStatus.dwAvailVirtual div 1000);
        g3.Max := Round(MemStatus.dwTotalPageFile div 1000);
        g3.Position := Round(MemStatus.dwAvailPageFile div 1000);
end;

function TMainForm.Split(StringToSplit: String; DelimeterChar: String): TStringList;
var
        buffer: string;
begin
        Result := TStringlist.Create;

        repeat
        begin
                if (copy(StringToSplit,1,1) = copy(DelimeterChar,1,1)) and (copy(StringToSplit,1,length(DelimeterChar)) = DelimeterChar) then
                begin
                        Result.Add(buffer);
                        buffer := '';
                        StringToSplit := copy(StringToSplit,2,length(StringToSplit));
                end
                else
                begin
                        buffer := buffer + copy(StringToSplit,1,1);
                        StringToSplit := copy(StringToSplit,2,length(StringToSplit));
                end;

                if StringToSplit = '' then
                begin
                        buffer := buffer + StringToSplit;
                        Result.Add(buffer);
                        buffer := '';
                        StringToSplit := '';
                end;
        end;
        until StringToSplit = '';
end;

function TMainForm.BuildLogEntry(Date: TDateTime; Mode: Integer): String;
var
        msMem: TMemoryStatus;
        sDate: String;
begin
        sDate := DateTimeToStr(Date);
        if Length(sDate) = 10 then sDate := sDate + ' 00:00:00'; 

        Result := sDate + '|';
        Result := Result + IntToStr(Mode) + '|';

        if (Mode = 3) or (Mode = 4) then
                Result := Result + IntToStr(GetTickCount()) + '|'
        else
                Result := Result + '0|'; //D³ugoœæ dzia³ania komputera jest zapisywana tylko dla zdarzeñ: zamkniêcie systemu (3) i rekord d³ugoœci dzia³ania (4). Dla innych nie...

        msMem.dwLength := SizeOf(msMem);
        GlobalMemoryStatus(msMem);

        Result := Result + IntToStr(msMem.dwAvailPhys) + '|';
        Result := Result + IntToStr(msMem.dwAvailVirtual) + '|';
        Result := Result + IntToStr(msMem.dwAvailPageFile);
end;

procedure TMainForm.WriteExternalFile(Directory: String);
var
        msMem: TMemoryStatus;
        sLine, sTmp, Ini: TStringList;
        sFile: String;
        a, b, c: Integer;
begin
        Ini := TStringList.Create();
        Ini.Values['Data'] := DateTimeToPolishString(Now);

        msMem.dwLength := SizeOf(msMem);
        GlobalMemoryStatus(msMem);

        Ini.Values['Wolna pamiêæ RAM'] := FormatFloat('#, "MB"', msMem.dwAvailPhys div 1048576);
        Ini.Values['Wolna pamiêæ wirtualna'] := FormatFloat('#, "MB"', msMem.dwAvailVirtual div 1048576);
        Ini.Values['Wolna pamiêæ stronnicowania'] := FormatFloat('#, "MB"', msMem.dwAvailPageFile div 1048576);

        Ini.Values['Start systemu'] := pnlStartedValue.Caption;
        Ini.Values['Czas dzia³ania systemu'] := pnlTimeValue.Caption;
        Ini.Values['Rekord'] := pnlRecordValue.Caption;

        sTmp := TStringList.Create();
        sLine := TStringList.Create();

        sFile := ExtractFilePath(Application.ExeName) + 'sync_log.dat';
        if FileExists(sFile) then
        begin
                sTmp.LoadFromFile(sFile);

                if sTmp.Count > 0 then
                begin
                        sLine := Split(sTmp.Strings[sTmp.Count - 1], '|');

                        Ini.Values['Synchronizacja czasu'] := DateTimeToPolishString(StrToDateTime(sLine[0]));
                        Ini.Values['Serwer czasu'] := sLine[1];
                        Ini.Values['Korekta lokalnego zegara'] := sLine[2];
                end;

                Ini.Values['Liczba synchronizacji czasu'] := IntToStr(sTmp.Count);
        end;

        Ini.Values['Instalacja systemu operacyjnego'] := Trim(InfoForm.pnlSystemInstall.Caption);
        Ini.Values['Pierwsze uruchomienie programu'] := Trim(InfoForm.pnlTimeLabel.Caption);

        c := 0;

        if FileExists(sLogFile) then
        begin
                sTmp.LoadFromFile(sLogFile);

                for a := 0 to sTmp.Count -1 do
                begin
                        sLine := Split(sTmp.Strings[a], '|');
                        b:= StrToIntDef(sLine[1], 0);
                        if (b = 1) or (b = 2) then Inc(c);
                end;
        end;

        Ini.Values['Liczba restartów'] := IntToStr(c);

        sLine.Free;
        sTmp.Free;
        
        Ini.SaveToFile(IncludeTrailingBackSlash(Directory) + 'podstawowe_informacje.txt');
        Ini.Free;
end;

procedure TMainForm.WriteExternalLogs(Directory: String);
var
        slLine, slFile, slTemp: TStringList;
        a: Integer;
        iTicks: Cardinal;
        sOp, sLine: String;
begin
        slFile := TStringList.Create();
        slLine := TStringList.Create();
        slTemp := TStringList.Create();

        if FileExists(sLogFile) then
        begin
                slFile.LoadFromFile(sLogFile);

                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 28) + '+' + StringOfChar('-', 18) + '+');
                slTemp.Add('|   Data i godzina    |          Zdarzenie         |    Czas pracy    |');
                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 28) + '+' + StringOfChar('-', 18) + '+');

                for a := 0 to slFile.Count -1 do
                begin
                        slLine := Split(slFile.Strings[a], '|');

                        sLine := '| ' + slLine[0] + ' | ';

                        case StrToIntDef(slLine[1], 0) of
                                0: sOp := 'Nieokreœlony b³¹d!';
                                1: sOp := 'Uruchomienie komputera';
                                2: sOp := 'Restart komputera';
                                3: sOp := 'Zamkniêcie systemu';
                                4: sOp := 'Rekord d³ugoœci dzia³ania';
                        end;

                        sLine := sLine + sOp + StringOfChar(' ', 26 - Length(sOp)) + ' | ';

                        iTicks := StrToIntDef(slLine[2], 0);

                        sOp := '';
                        if iTicks > 0 then sOp := CalculateUpTime(iTicks);
                        if Length(sOp) = 14 then sOp := ' ' + sOp + ' ';
                        sLine := sLine + sOp + StringOfChar(' ', 16 - Length(sOp)) + ' |';

                        slTemp.Add(sLine);
                end;

                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 28) + '+' + StringOfChar('-', 18) + '+');
                slTemp.SaveToFile(IncludeTrailingBackSlash(Directory) + 'dziennik_zdarzen.txt');
        end;

        slTemp.Clear();

        if FileExists(ExtractFilePath(Application.ExeName) + 'sync_log.dat') then
        begin
                slFile.LoadFromFile(ExtractFilePath(Application.ExeName) + 'sync_log.dat');

                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 46) + '+' + StringOfChar('-', 22) + '+');
                slTemp.Add('|   Data i godzina    |                 Serwer czasu                 |    Korekta zegara    |');
                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 46) + '+' + StringOfChar('-', 22) + '+');

                for a := 0 to slFile.Count -1 do
                begin
                        slLine := Split(slFile.Strings[a], '|');

                        sLine := '| ' + slLine[0] + ' | ';

                        sOp := slLine[1];
                        sLine := sLine + sOp + StringOfChar(' ', 44 - Length(sOp)) + ' | ';

                        sOp := slLine[2];
                        sOp := StringReplace(sOp, ' sekundy', '', []);
                        if Copy(sOp, 1, 1) <> '-' then sOp := ' ' + sOp;
                        sLine := sLine + sOp + StringOfChar(' ', 20 - Length(sOp)) + ' |';

                        slTemp.Add(sLine);
                end;

                slTemp.Add('+' + StringOfChar('-', 21) + '+' + StringOfChar('-', 46) + '+' + StringOfChar('-', 22) + '+');
                slTemp.SaveToFile(IncludeTrailingBackSlash(Directory) + 'dziennik_synchronizacji_czasu.txt');
        end;

        slLine.Free;
        slTemp.Free;
        slFile.Free;
end;

procedure TMainForm.WMEndSession(var Msg: TWMEndSession);
begin
        try
                CloseApp(True);
        finally
                inherited;
        end;
end;

procedure TMainForm.mnuLogClick(Sender: TObject);
begin
        InfoForm.ShowModal;
end;

procedure TMainForm.mnuMinimizeClick(Sender: TObject);
begin
        if ctiMain.Tag = 0 then
        begin
                ctiMain.IconVisible := True;
                ctiMain.Tag := 1;
                mnuMinimize.Caption := 'Przywróæ na Pulpit';
                Application.Minimize;
        end
        else
        begin
                ctiMain.IconVisible := False;
                ctiMain.Tag := 0;
                mnuMinimize.Caption := 'Minimalizuj do obszaru powiadomieñ';
                Application.Restore;
        end;
end;

procedure TMainForm.mnuConfigClick(Sender: TObject);
begin
        SettingsForm.ShowModal();
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if (ssAlt in Shift) and (Key = VK_F1) then mnuMinimizeClick(Self);
        if (ssAlt in Shift) and (Key = VK_F2) then mnuLogClick(Self);
        if (ssAlt in Shift) and (Key = VK_F3) then mnuConfigClick(Self);
        if (ssAlt in Shift) and (Key = VK_F4) then CloseApp(False);
end;

procedure TMainForm.mnuAboutClick(Sender: TObject);
begin
        AboutForm.ShowModal();
end;

procedure TMainForm.WriteTempFile();
var
        slLog: TStringList;
        sLogEntry, sFile: String;
begin
        sFile := ExtractFilePath(Application.ExeName) + 'temp.dat';
        slLog := TStringList.Create();

        if FileExists(sFile) then slLog.LoadFromFile(sFile);
        sLogEntry := BuildLogEntry(Now(), 3);
        slLog.Clear();
        slLog.Add(sLogEntry);
        slLog.SaveToFile(sFile);

        slLog.Free;
end;

procedure TMainForm.ReadTempFile();
var
        slLog: TStringList;
        sLogEntry, sFile: String;
begin
        sFile := ExtractFilePath(Application.ExeName) + 'temp.dat';
        if not FileExists(sFile) then Exit;
        if not FileExists(sLogFile) then Exit;

        slLog := TStringList.Create();

        slLog.LoadFromFile(sFile);
        sLogEntry := slLog.Strings[0];
        slLog.LoadFromFile(sLogFile);
        slLog.Add(sLogEntry);
        slLog.SaveToFile(sLogFile);

        slLog.Free;

        DeleteTempFile();
end;

procedure TMainForm.DeleteTempFile();
var
        sFile: String;
begin
        sFile := ExtractFilePath(Application.ExeName) + 'temp.dat';
        if FileExists(sFile) then DeleteFile(sFile);
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
        CloseApp(False);
end;

procedure TMainForm.FormShow(Sender: TObject);
var
        sStartupTime: String;
begin
        SettingsForm.ReadSettings(sSettingsFile, 'Settings');
        
        sStartupTime := CalculateStartTime(GetTickCount());
        pnlStartedValue.Caption := sStartupTime;

        WriteLog(ConvertStringToDate(sStartupTime), 1);
        
        if SettingsForm.chbMinimizeToTrayBar.Checked then MinimizeTimer.Enabled := True; 
end;

function TMainForm.IsDirectoryValid(Directory: String): Boolean;
begin
        if Directory = '' then
        begin
                Result := False;
                Exit;
        end;

        if not DirectoryExists(Directory) then
        begin
                try
                        Result := ForceDirectories(Directory);
                except
                        Result := False;
                end;
        end
        else Result := True;
end;

procedure TMainForm.MinimizeTimerTimer(Sender: TObject);
begin
        MinimizeTimer.Enabled := False;
        mnuMinimizeClick(self);
end;

function TMainForm.GetSystemInstallationDate(): TDateTime;
var
        oBindObj: IDispatch;
        oOperatingSystems, oOperatingSystem, oWMIService: OleVariant;
        i, iValue: Longword;
        oEnum: IEnumVariant;
        oCtx: IBindCtx;
        oMk: IMoniker;
        sFileObj: WideString;
        sResult: String;
begin
        sFileObj := 'winmgmts:\\.\root\cimv2';

        OleCheck(CreateBindCtx(0, oCtx));
        OleCheck(MkParseDisplayNameEx(oCtx, PWideChar(sFileObj), i, oMk));
        OleCheck(oMk.BindToObject(oCtx, nil, IUnknown, oBindObj));
        oWMIService := oBindObj;
        oOperatingSystems := oWMIService.ExecQuery('Select * from Win32_OperatingSystem');
        oEnum := IUnknown(oOperatingSystems._NewEnum) as IEnumVariant;

        while oEnum.Next(1, oOperatingSystem, iValue) = 0 do
        begin
                sResult := oOperatingSystem.InstallDate;
                oOperatingSystem := Unassigned;
        end;

        sResult := Trim(Copy(sResult, 1, Pos('.', sResult) - 1));
        sResult := Copy(sResult, 1, 4) + '-' + Copy(sResult, 5, 2) + '-' + Copy(sResult, 7, 2) + ' ' + Copy(sResult, 9, 2) + ':' + Copy(sResult, 11, 2) + ':' + Copy(sResult, 13, 2);
        sResult := Trim(sResult);

        Result := StrToDateTime(sResult);
end;

function TMainForm.GetTimeServer(): String;
var
        a, iRandom: Integer;
        sDomain, sLine: String;
        sTimeServers: TStringList;
label
        GoToHere;
begin
        if SettingsForm.chbRandomServer.Checked then
        begin
                sTimeServers := TStringList.Create();
                sTimeServers.Assign(SettingsForm.cbTimeServer.Items);

                if SettingsForm.chbPolishOnly.Checked then
                begin
                        a := 0;
                        while a < sTimeServers.Count do
                        begin
                                sLine := sTimeServers[a];
                                sDomain := Trim(Copy(sLine, Length(sLine) - 2, 3));
                                if sDomain <> '.pl' then sTimeServers.Delete(a) else Inc(a);
                        end;
                end;
GoToHere:
                iRandom := Random(sTimeServers.Count);
                Result := sTimeServers[iRandom];

                if not SyncForm.IsTimeServersOnLine(Result) then goto GoToHere;

                sTimeServers.Free;
        end
        else Result := SettingsForm.cbTimeServer.Text;
end;

end.
