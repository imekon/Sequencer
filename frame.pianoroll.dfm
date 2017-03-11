object PianoRollFrame: TPianoRollFrame
  Left = 0
  Top = 0
  Width = 694
  Height = 585
  DoubleBuffered = True
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  ParentDoubleBuffered = False
  TabOrder = 0
  object PianoRollPaint: TPaintBox
    Left = 0
    Top = 0
    Width = 694
    Height = 585
    Align = alClient
    OnMouseDown = OnMouseDown
    OnMouseMove = OnMouseMove
    OnMouseUp = OnMouseUp
    OnPaint = OnPianoRollPaint
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 630
    ExplicitHeight = 534
  end
end
