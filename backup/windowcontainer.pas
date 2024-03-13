unit WindowContainer;

interface

uses
  Classes, SysUtils, Contnrs, AbstractWindow;

type
  TWindowContainer = class
  private
    FRectWindows: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddWindow(Window: TAbstractWindow);
    function GetWindow(index: Integer): TAbstractWindow;
    function Count: Integer;
    // Другие методы, если необходимо
  end;

implementation

constructor TWindowContainer.Create;
begin
  FWindows := TObjectList.Create(True);
end;

destructor TWindowContainer.Destroy;
begin
  FWindows.Free;
  inherited;
end;

procedure TWindowContainer.AddWindow(Window: TAbstractWindow);
begin
  FWindows.Add(Window);
end;

function TWindowContainer.GetWindow(index: Integer): TAbstractWindow;
begin
  Result := TAbstractWindow(FWindows[index]);
end;

function TWindowContainer.Count: Integer;
begin
  Result := FWindows.Count;
end;

// Другие методы, если необходимо

end.

