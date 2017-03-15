object OutputMIDIDevicesForm: TOutputMIDIDevicesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Output MIDI Devices'
  ClientHeight = 162
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Devices'
  end
  object DevicesList: TListBox
    Left = 8
    Top = 27
    Width = 233
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object SelectBtn: TButton
    Left = 8
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Select'
    DoubleBuffered = True
    ModalResult = 1
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = SelectBtnClick
  end
  object CloseBtn: TButton
    Left = 166
    Top = 130
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 2
  end
end
