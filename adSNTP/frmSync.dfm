object SyncForm: TSyncForm
  Left = 201
  Top = 103
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Synchronizacja czasu...'
  ClientHeight = 513
  ClientWidth = 708
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
    Width = 692
    Height = 468
    ActivePage = tsStratum
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = pcMainChange
    object tsInfo: TTabSheet
      Caption = 'Synchronizacja czasu'
      ImageIndex = 1
      object lblSyncTime: TLabel
        Left = 104
        Top = 8
        Width = 142
        Height = 13
        Caption = 'Ostatnia synchronizacja: '
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object mInfo: TMemo
        Left = 2
        Top = 32
        Width = 680
        Height = 406
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object btnDeleteSyncLog: TButton
        Left = 2
        Top = 2
        Width = 90
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Wyczyœæ!'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnDeleteSyncLogClick
      end
      object btnSync: TButton
        Left = 592
        Top = 2
        Width = 90
        Height = 25
        Caption = 'Synchronizuj'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnSyncClick
      end
    end
    object tsLog: TTabSheet
      Caption = 'Dziennik synchronizacji'
      object lblEmptyLog: TLabel
        Left = 104
        Top = 8
        Width = 159
        Height = 13
        Caption = 'Dziennik zdarzeñ jest pusty!'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnDeleteLog: TButton
        Left = 2
        Top = 2
        Width = 90
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Wyczyœæ!'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnDeleteLogClick
      end
      object fList: TListView
        Left = 2
        Top = 32
        Width = 680
        Height = 406
        Anchors = [akLeft, akTop, akRight]
        Columns = <
          item
            Caption = 'Czas synchronizacji'
            Width = 160
          end
          item
            Caption = 'Serwer czasu'
            Width = 150
          end
          item
            Caption = 'Korekta zegara lokalnego'
            Width = 210
          end
          item
            Alignment = taCenter
            Caption = 'Strefa czasowa'
            Width = 140
          end>
        ColumnClick = False
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
    object tsStratum: TTabSheet
      Caption = 'Wydajnoœæ serwerów'
      ImageIndex = 2
      object lblCurrentServer: TLabel
        Left = 104
        Top = 8
        Width = 3
        Height = 13
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnCheck: TButton
        Left = 2
        Top = 2
        Width = 90
        Height = 25
        Caption = 'Badaj...'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnCheckClick
      end
      object btnInfo: TButton
        Left = 592
        Top = 2
        Width = 90
        Height = 25
        Caption = 'Informacje'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnInfoClick
      end
      object lvStratum: TListView
        Left = 2
        Top = 32
        Width = 680
        Height = 406
        Anchors = [akLeft, akTop, akRight]
        Columns = <
          item
            Caption = 'Badany serwer czasu'
            Width = 210
          end
          item
            Alignment = taCenter
            Caption = 'Adres IP serwera'
            Width = 160
          end
          item
            Alignment = taCenter
            Caption = 'Stratum serwera'
            Width = 140
          end
          item
            Alignment = taCenter
            Caption = 'Czas badania'
            Width = 140
          end>
        ColumnClick = False
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        ViewStyle = vsReport
      end
    end
  end
  object btnClose: TButton
    Left = 610
    Top = 480
    Width = 90
    Height = 25
    Cancel = True
    Caption = 'Zamknij'
    Default = True
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object SyncFireTimer: TTimer
    Enabled = False
    Interval = 333
    OnTimer = SyncFireTimerTimer
    Left = 8
    Top = 8
  end
end
