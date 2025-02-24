unit FullContainer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Contnrs, WindowContainer;

type
  TFullContainer = class
  private
    FContainers: TObjectList; // List to store TWindowContainer objects
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddContainer(Container: TWindowContainer);
    procedure RemoveContainer(Index: Integer);
    procedure Clear;
    function GetContainer(Index: Integer): TWindowContainer;
    function Count: Integer;
    function FindWindowInAllContainers(const ClickX, ClickY: Integer): TWindowContainer;
    function IndexOfContainer(Container: TWindowContainer): Integer;
    // Other methods as needed
  end;

implementation

constructor TFullContainer.Create;
begin
  FContainers := TObjectList.Create(True); // Owns objects, so it will free them automatically
end;

destructor TFullContainer.Destroy;
begin
  FContainers.Free;
  inherited;
end;

procedure TFullContainer.AddContainer(Container: TWindowContainer);
begin
  FContainers.Add(Container);
end;

procedure TFullContainer.RemoveContainer(Index: Integer);
begin
  if (Index >= 0) and (Index < FContainers.Count) then
    FContainers.Delete(Index);
end;

procedure TFullContainer.Clear;
begin
  FContainers.Clear;
end;

function TFullContainer.GetContainer(Index: Integer): TWindowContainer;
begin
  if (Index >= 0) and (Index < FContainers.Count) then
    Result := TWindowContainer(FContainers[Index])
  else
    Result := nil;
end;

function TFullContainer.Count: Integer;
begin
  Result := FContainers.Count;
end;

function TFullContainer.FindWindowInAllContainers(const ClickX, ClickY: Integer): TWindowContainer;
var
  i, WindowIndex: Integer;
  Container: TWindowContainer;
begin
  Result := nil;
  for i := 0 to FContainers.Count - 1 do
  begin
    Container := TWindowContainer(FContainers[i]);
    WindowIndex := Container.FindWindow(ClickX, ClickY);
    if WindowIndex <> -1 then
    begin
      Result := Container;
      Break; // Stop searching once a match is found
    end;
  end;
end;

function TFullContainer.IndexOfContainer(Container: TWindowContainer): Integer;
begin
  Result := FContainers.IndexOf(Container);
end;

end.
