unit midi.output.form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TOutputMIDIDevicesForm = class(TForm)
    Label1: TLabel;
    DevicesList: TListBox;
    SelectBtn: TButton;
    CloseBtn: TButton;
    procedure SelectBtnClick(Sender: TObject);
  private
    _selected: integer;
    function GetSelected: integer;
    { Private declarations }
  public
    { Public declarations }
    procedure Init(devices: TStrings; selected: integer);
    property Selected: integer read GetSelected;
  end;

implementation

{$R *.dfm}

{ TOutputMIDIDevicesForm }

function TOutputMIDIDevicesForm.GetSelected: integer;
begin
  result := _selected;
end;

procedure TOutputMIDIDevicesForm.Init(devices: TStrings; selected: integer);
begin
  selected := -1;
  DevicesList.Items.AddStrings(devices);
  if selected <> -1 then
    DevicesList.Selected[selected] := true;
end;

procedure TOutputMIDIDevicesForm.SelectBtnClick(Sender: TObject);
var
  i: integer;

begin
  _selected := -1;
  if DevicesList.SelCount <> 0 then
    for i := 0 to DevicesList.Count - 1 do
    begin
      if DevicesList.Selected[i] then
      begin
        _selected := i;
        break;
      end;
    end;
end;

end.
