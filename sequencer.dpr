program sequencer;

uses
  Vcl.Forms,
  main in 'main.pas' {MainForm},
  frame.pianoroll in 'frame.pianoroll.pas' {PianoRollFrame: TFrame},
  helper.utilities in 'helper.utilities.pas',
  midi.output in 'midi.output.pas',
  midi.configuration in 'midi.configuration.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
