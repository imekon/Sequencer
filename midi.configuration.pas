unit midi.configuration;

interface

uses
  WinApi.MMSystem;

type
  TMIDIConfiguration = class
  private
    function GetNumOutputDevices: integer;
  public
    constructor Create;
    destructor Destroy; override;

    function GetOutputDeviceName(index: integer): string;

    property NumberOutputDevices: integer read GetNumOutputDevices;
  end;

implementation

{ TMIDIConfiguration }

constructor TMIDIConfiguration.Create;
begin

end;

destructor TMIDIConfiguration.Destroy;
begin

  inherited;
end;

function TMIDIConfiguration.GetNumOutputDevices: integer;
begin
  result := midiOutGetNumDevs;
end;

function TMIDIConfiguration.GetOutputDeviceName(index: integer): string;
var
  caps: MIDIOUTCAPS;

begin
  midiOutGetDevCaps(index, @caps, sizeof(MIDIOUTCAPS));
  result := caps.szPname;
end;

end.
