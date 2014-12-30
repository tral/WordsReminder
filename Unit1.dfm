object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 124
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 168
    Top = 16
  end
  object TrayIcon1: TTrayIcon
    Hint = 'WordsReminder'
    BalloonHint = 'pourtant [pu'#640't'#593#771']'
    BalloonTitle = 'pourtant [pu'#640't'#593#771']'
    BalloonTimeout = 5000000
    BalloonFlags = bfInfo
    PopupMenu = PopupMenu1
    Visible = True
    OnClick = TrayIcon1Click
    Left = 120
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 112
    Top = 64
    object N2: TMenuItem
      Caption = #1060#1088#1072#1079#1099
      OnClick = N2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object cm_winautoload: TMenuItem
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' '#1089' Windows'
      OnClick = cm_winautoloadClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N1Click
    end
  end
end
