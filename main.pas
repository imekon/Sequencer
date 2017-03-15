unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frame.pianoroll, midi.output,
  Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    PianoRollFrame: TPianoRollFrame;
    DevicesBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DevicesBtnClick(Sender: TObject);
  private
    { Private declarations }
    _selectedOutputDevice: integer;
    _sequencer: TMIDIOutput;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses midi.configuration, midi.output.form;

procedure TMainForm.DevicesBtnClick(Sender: TObject);
var
  i, n: integer;
  name: string;
  config: TMIDIConfiguration;
  deviceList: TStringList;
  dlg: TOutputMIDIDevicesForm;

begin
  deviceList := TStringList.Create;
  config := TMIDIConfiguration.Create;
  dlg := TOutputMIDIDevicesForm.Create(self);
  try
    n := config.NumberOutputDevices;
    for i := 0 to n - 1 do
    begin
      name := config.GetOutputDeviceName(i);
      deviceList.Add(name);
    end;
    dlg.Init(deviceList, _selectedOutputDevice);
    if dlg.ShowModal = mrOK then
      _selectedOutputDevice := dlg.Selected;
  finally
    dlg.Free;
    deviceList.Free;
    config.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  _selectedOutputDevice := -1;
  _sequencer := TMIDIOutput.Create;
  _sequencer.SetTempo(120);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  _sequencer.Free;
end;

end.
