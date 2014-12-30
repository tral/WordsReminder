object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1060#1088#1072#1079#1099
  ClientHeight = 423
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 30
    Height = 13
    Caption = #1055#1086#1080#1089#1082
  end
  object Label2: TLabel
    Left = 108
    Top = 395
    Width = 3
    Height = 13
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 48
    Width = 577
    Height = 336
    ColCount = 3
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    PopupMenu = phPopup
    TabOrder = 1
    OnKeyDown = StringGrid1KeyDown
    RowHeights = (
      24)
  end
  object Edit1: TEdit
    Left = 64
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    OnChange = Edit1Change
    OnKeyDown = Edit1KeyDown
  end
  object Button1: TButton
    Left = 461
    Top = 8
    Width = 124
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
    OnKeyDown = Button1KeyDown
  end
  object Button2: TButton
    Left = 8
    Top = 390
    Width = 89
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
    TabOrder = 3
    OnClick = Button2Click
  end
  object phPopup: TPopupMenu
    Left = 32
    Top = 328
    object test1: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077
      OnClick = test1Click
    end
  end
end
