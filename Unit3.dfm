object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1092#1088#1072#1079#1099
  ClientHeight = 225
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 100
    Height = 13
    Caption = #1048#1085#1086#1089#1090#1088#1072#1085#1085#1099#1081' '#1103#1079#1099#1082':'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 69
    Height = 13
    Caption = #1056#1086#1076#1085#1086#1081' '#1103#1079#1099#1082':'
  end
  object Edit1: TEdit
    Left = 16
    Top = 35
    Width = 433
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
    OnKeyUp = Edit1KeyUp
  end
  object Memo1: TMemo
    Left = 16
    Top = 83
    Width = 434
    Height = 86
    TabOrder = 1
    OnKeyDown = Memo1KeyDown
    OnKeyUp = Memo1KeyUp
  end
  object Button1: TButton
    Left = 112
    Top = 182
    Width = 121
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 247
    Top = 182
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button2Click
  end
end
