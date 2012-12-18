object Form1: TForm1
  Left = 149
  Top = 190
  Width = 979
  Height = 563
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 506
    Width = 963
    Height = 19
    Panels = <>
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 963
    Height = 506
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpLeft
    Tabs.Strings = (
      'a'
      'b'
      'c'
      'e'
      'f')
    TabIndex = 0
    object Button1: TButton
      Left = 432
      Top = 88
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
