unit helper.utilities;

interface

type
  THelperUtilities = class
  public
    class function Clamp(value, min, max: integer): integer;
    class function ClampToGrid(value, min, max, grid: integer): integer;
  end;

implementation

{ THelperUtilities }

class function THelperUtilities.Clamp(value, min, max: integer): integer;
begin
  if value < min then
    value := min;

  if value > max then
    value := max;

  result := value;
end;

class function THelperUtilities.ClampToGrid(value, min, max,
  grid: integer): integer;
begin
  result := Clamp(value, min, max);

  result := result div grid;
  result := result * grid;
end;

end.
