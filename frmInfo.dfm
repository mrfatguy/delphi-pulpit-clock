object InfoForm: TInfoForm
  Left = 136
  Top = 103
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Events log'
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
    Height = 417
    ActivePage = tsLog
    TabOrder = 0
    OnChange = pcMainChange
    object tsLog: TTabSheet
      Caption = 'Log'
      object fList: TListView
        Left = 2
        Top = 2
        Width = 680
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Timestamp'
            Width = 140
          end
          item
            Caption = 'Event'
            Width = 170
          end
          item
            Caption = 'Work period'
            Width = 120
          end
          item
            Alignment = taCenter
            Caption = 'RAM'
            Width = 75
          end
          item
            Alignment = taCenter
            Caption = 'Virtual'
            Width = 75
          end
          item
            Alignment = taCenter
            Caption = 'Page'
            Width = 75
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
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tsInfo: TTabSheet
      Caption = 'Information'
      ImageIndex = 1
      object mInfo: TMemo
        Left = 2
        Top = 2
        Width = 680
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsHistory: TTabSheet
      Caption = 'History of changes'
      ImageIndex = 2
      object mHistory: TMemo
        Left = 2
        Top = 2
        Width = 680
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object btnClose: TButton
    Left = 625
    Top = 480
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnDeleteLog: TButton
    Left = 8
    Top = 480
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btnDeleteLogClick
  end
  object pnlTimeLabel: TPanel
    Left = 174
    Top = 452
    Width = 330
    Height = 18
    Alignment = taLeftJustify
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 8
    Top = 452
    Width = 166
    Height = 18
    Alignment = taRightJustify
    Caption = 'First program run '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object pnlEmptyLog: TPanel
    Left = 510
    Top = 452
    Width = 188
    Height = 18
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 8
    Top = 432
    Width = 166
    Height = 18
    Alignment = taRightJustify
    Caption = 'System instalation date '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object pnlSystemInstall: TPanel
    Left = 174
    Top = 432
    Width = 524
    Height = 18
    Alignment = taLeftJustify
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
end
