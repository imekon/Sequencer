unit midi.output;

interface

uses
  System.Math, WinApi.Windows;

type
  TMIDIOutput = class
  private
    _queue: THANDLE;
    _timer: THANDLE;
    _period: DWORD;
    _steps: integer;

    procedure Tick;

  public
    constructor Create;
    destructor Destroy; override;
    procedure SetTimer(period: integer);
    procedure SetTempo(tempo: integer);
    procedure Start;
    procedure Stop;
  end;

implementation

{ TMIDIOutput }

procedure TimerCallback(parameter: Pointer; timerOrWaitFired: boolean); stdcall;
var
  output: TMIDIOutput;

begin
  output := TMIDIOutput(parameter);
  output.Tick;
end;

constructor TMIDIOutput.Create;
begin
  _queue := CreateTimerQueue;
  _period := 1;
  _steps := 16;
end;

destructor TMIDIOutput.Destroy;
var
  completion: THandle;

begin
  completion := CreateEvent(nil, false, false, nil);
  DeleteTimerQueueEx(_queue, completion);
  WaitForSingleObject(completion, INFINITE);
  CloseHandle(completion);
  inherited;
end;

procedure TMIDIOutput.SetTempo(tempo: integer);
var
  period: single;

begin
  period := 1000.0 * 60.0 * 4.0 / tempo / _steps;
  _period := floor(period);
end;

procedure TMIDIOutput.SetTimer(period: integer);
begin
  _period := period;
end;

procedure TMIDIOutput.Start;
begin
  CreateTimerQueueTimer(_timer, _queue, TimerCallback, self, _period, _period, WT_EXECUTEDEFAULT);
end;

procedure TMIDIOutput.Stop;
var
  completion: THANDLE;

begin
  if _timer <> INVALID_HANDLE_VALUE then
  begin
    completion := CreateEvent(nil, false, false, nil);
    DeleteTimerQueueTimer(_queue, _timer, completion);
    WaitForSingleObject(completion, INFINITE);
    CloseHandle(completion);
  end;
end;

procedure TMIDIOutput.Tick;
begin
  //
end;

end.
