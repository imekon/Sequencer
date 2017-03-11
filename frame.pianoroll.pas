unit frame.pianoroll;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.GraphUtil;

type
  TPianoRollMode = (Select, AdjustSize);
  TNoteCountEvent = procedure(sender: TObject; var count: integer) of object;
  TGetNoteEvent = procedure(sender: TObject; index: integer;
    var osc, note, start, length: integer) of object;
  TNoteUpdateEvent = procedure(sender: TObject; index, note, start: integer) of object;
  TNoteRightClickEvent = procedure(sender: TObject; note: integer) of object;

  TPianoRollFrame = class(TFrame)
    PianoRollPaint: TPaintBox;
    procedure OnPianoRollPaint(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    m_noteCountEvent: TNoteCountEvent;
    m_getNoteEvent: TGetNoteEvent;
    m_noteUpdateEvent: TNoteUpdateEvent;
    m_noteRightClickEvent: TNoteRightClickEvent;
    m_mode: TPianoRollMode;

    m_move, m_snapToGrid: boolean;
    m_selectedNote: integer;
    m_numSteps: integer;
    m_cursor: integer;

    function GetNoteRect(note, start, length: integer): TRect;

    function DoCountEvent: integer;
    procedure DoGetNoteEvent(index: integer; var osc, note, start, length: integer);
    procedure DoNoteUpdateEvent(index, note, start: integer);
    procedure DoRightClick(note: integer);
    procedure SetCursor(const Value: integer);
  public
    { Public declarations }
    constructor Create(anOwner: TComponent); override;

    procedure Refresh;

    property Cursor: integer read m_cursor write SetCursor;
    property Mode: TPianoRollMode read m_mode write m_mode;
    property Selected: integer read m_selectedNote;
    property OnNoteCount: TNoteCountEvent
      read m_noteCountEvent write m_noteCountEvent;
    property OnGetNote: TGetNoteEvent
      read m_getNoteEvent write m_getNoteEvent;
    property OnNoteUpdate: TNoteUpdateEvent
      read m_noteUpdateEvent write m_noteUpdateEvent;
    property OnNoteRightClick: TNoteRightClickEvent
      read m_noteRightClickEvent write m_noteRightClickEvent;
  end;

implementation

{$R *.dfm}

uses helper.utilities;

const
  CellWidth = 24;
  CellHeight = 12;

constructor TPianoRollFrame.Create(anOwner: TComponent);
begin
  inherited;
  m_selectedNote := -1;
  m_cursor := -1;
  m_numSteps := 32;
  m_move := false;
  m_snapToGrid := false;
  m_noteCountEvent := nil;
  m_getNoteEvent := nil;
  m_noteUpdateEvent := nil;
  m_noteRightClickEvent := nil;
  m_mode := TPianoRollMode.Select;
end;

function TPianoRollFrame.DoCountEvent: integer;
var
  count: integer;

begin
  result := 0;
  if Assigned(m_noteCountEvent) then
  begin
    m_noteCountEvent(self, count);
    result := count;
  end;
end;

procedure TPianoRollFrame.DoGetNoteEvent(index: integer;
  var osc, note, start, length: integer);
begin
  if Assigned(m_getNoteEvent) then
    m_getNoteEvent(self, index, osc, note, start, length);
end;

procedure TPianoRollFrame.DoNoteUpdateEvent(index, note, start: integer);
begin
  if Assigned(m_noteUpdateEvent) then
    m_noteUpdateEvent(self, index, note, start);
end;

procedure TPianoRollFrame.DoRightClick(note: integer);
begin
  if Assigned(m_noteRightClickEvent) then
    m_noteRightClickEvent(self, note);
end;

function TPianoRollFrame.GetNoteRect(note, start, length: integer): TRect;
var
  rect: TRect;

begin
  SetRect(rect,
    start,
    (35 - note - 1) * CellHeight,
    start + length,
    (35 - note - 1) * CellHeight + CellHeight);

  result := rect;
end;

procedure TPianoRollFrame.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, count, osc, note, start, length: integer;
  point: TPoint;
  rect: TRect;

begin
  if Button = mbLeft then
  begin
    count := DoCountEvent;

    m_selectedNote := -1;
    m_move := false;

    for i := 0 to count - 1 do
    begin
      DoGetNoteEvent(i, osc, note, start, length);

      rect := GetNoteRect(note, start, length);

      point.X := x;
      point.Y := y;

      if rect.Contains(point) then
      begin
        m_selectedNote := i;
        m_move := true;
        break;
      end;
    end;

    PianoRollPaint.Refresh;
  end;

  if Button = mbRight then
  begin
    count := DoCountEvent;

    note := -1;

    for i := 0 to count - 1 do
    begin
      DoGetNoteEvent(i, osc, note, start, length);

      rect := GetNoteRect(note, start, length);

      point.X := x;
      point.Y := y;

      if rect.Contains(point) then
      begin
        DoRightClick(i);
        break;
      end;
    end;
  end;
end;

procedure TPianoRollFrame.OnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if m_move then
  begin
    x := THelperUtilities.ClampToGrid(x, 0, CellWidth * m_numSteps, CellWidth);
    DoNoteUpdateEvent(m_selectedNote, 34 - y div CellHeight, x);
    PianoRollPaint.Refresh;
  end;
end;

procedure TPianoRollFrame.OnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  m_move := false;
end;

procedure TPianoRollFrame.OnPianoRollPaint(Sender: TObject);
var
  i, x, y, h, osc, note, start, length: integer;
  dark, light, background: TColor;
  noteCount: integer;
  rect: TRect;

begin
  light := clLtGray;
  dark := clDkGray;
  background := clWhite;

  h := 35 * CellHeight;

  with PianoRollPaint.Canvas do
  begin
    SetRect(rect, 0, 0, PianoRollPaint.Width, PianoRollPaint.Height);
    Brush.Color := background;
    FillRect(rect);

    Pen.Width := 0;

    for x := 0 to m_numSteps do
    begin
      if x mod 4 = 0 then
        Pen.Color := dark
      else
        Pen.Color := light;

      MoveTo(x * CellWidth, 0);
      LineTo(x * CellWidth, h);
    end;

    Pen.Color := clLtGray;
    for y := 0 to 35 do
    begin
      if y mod 7 = 0 then
        Pen.Color := dark
      else
        Pen.Color := light;

      MoveTo(0, y * CellHeight);
      LineTo(m_numSteps * CellWidth, y * CellHeight);
    end;

    noteCount := DoCountEvent;

    Pen.Color := clBlack;

    for i := 0 to noteCount - 1 do
    begin
      DoGetNoteEvent(i, osc, note, start, length);
      rect := GetNoteRect(note, start, length);

      if i = m_selectedNote then
        Brush.Color := clRed
      else
        case osc of
          0: Brush.Color := clOlive;
          1: Brush.Color := clSkyBlue;
        end;

      Rectangle(rect);
    end;

    if m_cursor <> -1 then
    begin
      {*if m_cursor > 0 then
      begin
        SetRect(rect, CellWidth * m_cursor - CellWidth, 0,
          CellWidth * m_cursor, 35 * CellHeight);
        GradientFillCanvas(PianoRollPaint.Canvas, clNone, clRed, rect,
          TGradientDirection.gdHorizontal);
      end
      else
      begin
        Pen.Color := clRed;
        MoveTo(CellWidth * m_cursor, 0);
        LineTo(CellWidth * m_cursor, 35 * CellHeight);
      end;*}
      Pen.Color := clRed;
      Pen.Width := 3;
      MoveTo(CellWidth * m_cursor, 0);
      LineTo(CellWidth * m_cursor, 35 * CellHeight);
    end;
  end;
end;

procedure TPianoRollFrame.Refresh;
begin
  PianoRollPaint.Refresh;
end;

procedure TPianoRollFrame.SetCursor(const Value: integer);
begin
  m_cursor := value;
  PianoRollPaint.Refresh;
end;

end.

