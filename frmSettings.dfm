object SettingsForm: TSettingsForm
  Left = 194
  Top = 102
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Settings and configuration'
  ClientHeight = 393
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcMain: TPageControl
    Left = 8
    Top = 8
    Width = 616
    Height = 345
    ActivePage = tsSettings
    TabOrder = 0
    object tsSettings: TTabSheet
      Caption = 'Settngs'
      ImageIndex = 3
      object gbRecord: TGroupBox
        Left = 4
        Top = 4
        Width = 297
        Height = 165
        Caption = ' Record '
        TabOrder = 0
        object lblActualRecord: TLabel
          Left = 8
          Top = 56
          Width = 80
          Height = 13
          Caption = 'Current record:'
        end
        object Label1: TLabel
          Left = 8
          Top = 113
          Width = 280
          Height = 44
          AutoSize = False
          Caption = 
            'Record is updated and saved each 11 seconds. After resetting it ' +
            'to zero, it will soon be updated by program. This function only ' +
            'deletes current record, but does not stop counting time and sav ' +
            'ing new records after reset.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clGray
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object chbSaveRecord: TCheckBox
          Tag = 2
          Left = 8
          Top = 16
          Width = 281
          Height = 17
          Caption = 'Write on-line records in program log'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chbSaveRecordClick
        end
        object eRecord: TEdit
          Left = 96
          Top = 52
          Width = 193
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object btnClearRecord: TButton
          Left = 214
          Top = 80
          Width = 75
          Height = 25
          Caption = 'Reset!'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnClearRecordClick
        end
        object chbDeleteOld: TCheckBox
          Tag = 1
          Left = 8
          Top = 32
          Width = 270
          Height = 17
          Caption = 'Purge old records, when saving new one'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object gbSynchronise: TGroupBox
        Left = 308
        Top = 4
        Width = 297
        Height = 165
        Caption = ' Time synchronisation '
        TabOrder = 1
        object lblTimeServer: TLabel
          Left = 8
          Top = 56
          Width = 68
          Height = 13
          Caption = 'Serwer czasu:'
        end
        object Label3: TLabel
          Left = 8
          Top = 135
          Width = 278
          Height = 22
          AutoSize = False
          Caption = 
            'Warning! Time synchronisation updates system clock and therefore' +
            'is system-wide. It does not occurs only in this program! See bel' +
            'ow notice as well.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clGray
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object chbSyncStart: TCheckBox
          Tag = 2
          Left = 8
          Top = 16
          Width = 249
          Height = 17
          Caption = 'Sync time with each Windows start'
          TabOrder = 0
          OnClick = chbSyncStartClick
        end
        object cbTimeServer: TComboBox
          Tag = 1
          Left = 96
          Top = 52
          Width = 193
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'vega.cbk.poznan.pl'
            'ntp.certum.pl'
            'tempus1.gum.gov.pl'
            'tempus2.gum.gov.pl'
            'ntp.task.gda.pl'
            'time.atman.pl'
            'ntp.icm.edu.pl'
            'ntp.nask.pl'
            'sunflower.man.poznan.pl'
            'ucirtr.agh.edu.pl'
            'info.cyf-kr.edu.pl'
            'time.ien.it'
            'swisstime.ethz.ch'
            'ntp1.fau.de'
            'ntp2.fau.de'
            'ntps1-0.cs.tu-berlin.de'
            'ntps1-1.cs.tu-berlin.de'
            'clock.nc.fukuoka-u.ac.jp'
            'ntp.cs.mu.oz.au'
            'tick.keso.fi'
            'tock.keso.fi'
            'ntp.obspm.fr'
            'ntp.univ-lyon1.fr'
            'time.kfki.hu'
            'fartein.ifi.uio.no'
            'ntp.lth.se'
            'biofiz.mf.uni-lj.si'
            'ntp1.arnes.si'
            'ntp2.arnes.si'
            'time.ijs.si'
            'ntp.cs.tcd.ie'
            'ntp.maths.tcd.ie'
            'ntp.tcd.ie'
            'ntp.cs.strath.ac.uk'
            'ntp0.uk.uu.net'
            'ntp1.uk.uu.net'
            'ntp2.uk.uu.net'
            'ntp2a.mcc.ac.uk'
            'ntp2b.mcc.ac.uk'
            'ntp2c.mcc.ac.uk'
            'ntp2d.mcc.ac.uk'
            'time.nuri.net'
            'ntp.cs.unp.ac.za'
            'augean.eleceng.adelaide.edu.au'
            'ntp.adelaide.edu.au'
            'tick.nap.com.ar'
            'tock.nap.com.ar'
            'time.sinectis.com.ar'
            'ntp.cais.rnp.br'
            'time.windows.com'
            'time.nist.gov'
            'time-a.nist.gov'
            'time-b.nist.gov'
            'time-nw.nist.gov'
            'time-a.timefreq.bldrdoc.gov'
            'time-b.timefreq.bldrdoc.gov'
            'time-c.timefreq.bldrdoc.gov'
            'utcnist.colorado.edu'
            'nist1.datum.com'
            'usno.pa-x.dec.com'
            'timekeeper.isi.edu'
            'tick.usno.navy.mil'
            'tock.usno.navy.mil'
            'bonehed.lcs.mit.edu'
            'clock.isc.org'
            'clock.via.net'
            'tick.wustl.edu'
            'ncnoc.ncren.net'
            'ntp1.delmarva.com'
            'otc1.psu.edu'
            'ntp1.cmc.ec.gc.ca'
            'ntp2.cmc.ec.gc.ca'
            'time.chu.nrc.ca'
            'time.nrc.ca'
            'timelord.uregina.ca'
            'tick.utoronto.ca'
            'tock.utoronto.ca'
            'ntp.ucsd.edu'
            'ntp1.mainecoon.com'
            'ntp2.mainecoon.com'
            'louie.udel.edu'
            'ntp.shorty.com'
            'rolex.peachnet.edu'
            'timex.peachnet.edu'
            'ntp-0.cso.uiuc.edu'
            'ntp-1.cso.uiuc.edu'
            'ntp-2.cso.uiuc.edu'
            'ntp-1.mcs.anl.gov'
            'ntp-2.mcs.anl.gov'
            'ntp1.kansas.net'
            'ntp2.kansas.net'
            'ns.nts.umn.edu'
            'nss.nts.umn.edu'
            'cuckoo.nevada.edu'
            'tick.cs.unlv.edu'
            'tock.cs.unlv.edu'
            'ntp.ctr.columbia.edu'
            'sundial.columbia.edu'
            'timex.cs.columbia.edu'
            'tick.koalas.com'
            'tock.koalas.com'
            'clock.psu.edu'
            'fuzz.psc.edu'
            'ntp-1.ece.cmu.edu'
            'ntp-2.ece.cmu.edu'
            'ntp.tmc.edu'
            'ntp5.tamu.edu'
            'tick.greyware.com'
            'tock.greyware.com'
            'ntp-1.vt.edu'
            'ntp-2.vt.edu'
            'ntp1.cs.wisc.edu'
            'ntp2.cs.wisc.edu'
            'ntp3.cs.wisc.edu')
        end
        object btnSyncNow: TButton
          Left = 182
          Top = 104
          Width = 107
          Height = 25
          Caption = 'Sync now!'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = btnSyncNowClick
        end
        object btnShowSyncLog: TButton
          Left = 8
          Top = 104
          Width = 107
          Height = 25
          Caption = 'Show log'
          TabOrder = 6
          OnClick = btnShowSyncLogClick
        end
        object chbSyncMidnight: TCheckBox
          Tag = 2
          Left = 8
          Top = 32
          Width = 268
          Height = 17
          Caption = 'Sync time at midnight each day'
          TabOrder = 1
          OnClick = chbSyncStartClick
        end
        object chbRandomServer: TCheckBox
          Tag = 2
          Left = 8
          Top = 76
          Width = 180
          Height = 17
          Caption = 'Always use random time server'
          TabOrder = 3
          OnClick = chbRandomServerClick
        end
        object chbPolishOnly: TCheckBox
          Tag = 1
          Left = 212
          Top = 76
          Width = 77
          Height = 17
          Caption = 'Only Polish'
          TabOrder = 4
        end
      end
      object gbSaving: TGroupBox
        Left = 4
        Top = 176
        Width = 297
        Height = 137
        Caption = ' Saving to file '
        TabOrder = 2
        object Label4: TLabel
          Left = 8
          Top = 88
          Width = 283
          Height = 44
          AutoSize = False
          Caption = 
            'If folder does not exist -- it will be created. File with basic ' +
            'parameters is updated each 11 seconds. Logs (events log and time' +
            'synchronisation log) are exported each full houwr (that is -- tw' +
            'nty four times per each day).'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clGray
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object chbSaveFile: TCheckBox
          Tag = 2
          Left = 8
          Top = 16
          Width = 238
          Height = 17
          Caption = 'Save basic program parameters to file'
          TabOrder = 0
          OnClick = chbSaveFileClick
        end
        object eFolder: TEdit
          Tag = 1
          Left = 8
          Top = 36
          Width = 257
          Height = 21
          TabOrder = 1
        end
        object btnLoad: TButton
          Left = 267
          Top = 36
          Width = 22
          Height = 21
          Caption = '...'
          Default = True
          TabOrder = 2
          OnClick = btnLoadClick
        end
        object chbExportLogs: TCheckBox
          Tag = 1
          Left = 8
          Top = 64
          Width = 265
          Height = 17
          Caption = 'Export events log and time sync log as well'
          TabOrder = 3
          OnClick = chbSaveFileClick
        end
      end
      object gbExtra: TGroupBox
        Left = 308
        Top = 176
        Width = 297
        Height = 137
        Caption = ' Other parameters '
        TabOrder = 3
        object Label2: TLabel
          Left = 8
          Top = 72
          Width = 279
          Height = 33
          AutoSize = False
          Caption = 
            'Program is unable to detect actual system reset. It guesses it, ' +
            'by checking period of time passed between shutdown and startup. ' +
            'If it is shorter or equal to above, it will log a "reset". If lo' +
            'ger -- then it will log a "startup"'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clGray
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label5: TLabel
          Left = 8
          Top = 52
          Width = 205
          Height = 13
          Caption = 'Fixed "dealy" for computer restart'
        end
        object lblMinuteDop: TLabel
          Left = 256
          Top = 52
          Width = 32
          Height = 13
          Caption = 'minute'
        end
        object Label7: TLabel
          Left = 8
          Top = 110
          Width = 278
          Height = 22
          AutoSize = False
          Caption = 
            'By the same amount of time, time synchronisation during system s' +
            'tartup is delayed, if this function is enabled (see above).'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clGray
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object chbRunAlways: TCheckBox
          Tag = 1
          Left = 8
          Top = 16
          Width = 269
          Height = 13
          Caption = 'Start Pulpit Clock with each system start'
          TabOrder = 0
        end
        object seRestartDelay: TSpinEdit
          Tag = 2
          Left = 216
          Top = 48
          Width = 33
          Height = 22
          EditorEnabled = False
          MaxLength = 1
          MaxValue = 9
          MinValue = 1
          TabOrder = 2
          Value = 3
          OnChange = seRestartDelayChange
        end
        object chbMinimizeToTrayBar: TCheckBox
          Tag = 1
          Left = 8
          Top = 32
          Width = 273
          Height = 13
          Caption = 'Run minimised to traybar'
          TabOrder = 1
        end
      end
    end
  end
  object btnSave: TButton
    Left = 549
    Top = 361
    Width = 75
    Height = 25
    Caption = 'Save'
    Default = True
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 8
    Top = 361
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object fdMain: TFolderDialog
    Top = 8
    Left = 8
    Title = 'Select a folder'
    Text = 'Select a folder, where you want to store all program files'
    Options = [bfFileSysDirsOnly, bfStatusText, bfShowPathInStatusArea, bfSyncCustomButton, bfAlignCustomButton, bfScreenCenter]
    RootFolder = sfoMyComputer
  end
end
