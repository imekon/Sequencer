unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frame.pianoroll, midi.output;

type
  TMainForm = class(TForm)
    PianoRollFrame: TPianoRollFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    _sequencer: TMIDIOutput;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses midi.configuration;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i, n: integer;
  name: string;
  config: TMIDIConfiguration;

begin
  _sequencer := TMIDIOutput.Create;
  _sequencer.SetTempo(120);

  config := TMIDIConfiguration.Create;
  n := config.NumberOutputDevices;
  for i := 0 to n - 1 do
  begin
    name := config.GetOutputDeviceName(i);
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  _sequencer.Free;
end;

end.
