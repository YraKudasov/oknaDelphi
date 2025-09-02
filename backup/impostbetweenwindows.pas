unit ImpostBetweenWindows;

interface

uses
  Classes, SysUtils, Contnrs;

type
  // Сам импост
  TImpostBetweenWindow = class
  private
    FOrientation: Integer;   // 0 = X, 1 = Y
    FXOtstup: Integer;
    FYOtstup: Integer;
    FSize: Integer;
  public
    constructor Create(AOrientation, AXOtstup, AYOtstup, ASize: Integer);

    property Orientation: Integer read FOrientation write FOrientation;

    property XOtstup: Integer read FXOtstup write FXOtstup;
    property YOtstup: Integer read FYOtstup write FYOtstup;
    property Size: Integer read FSize write FSize;

    function IsHorizontal: Boolean;
    function IsVertical: Boolean;
  end;

  // Контейнер импостов
  TImpostsBetweenWindows = class
  private
    FImposts: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddImpost(Impost: TImpostBetweenWindow);
    procedure RemoveImpost(Index: Integer);
    function GetImpost(Index: Integer): TImpostBetweenWindow;
    function Count: Integer;
    procedure Clear;
  end;

implementation

{ TImpostBetweenWindow }

constructor TImpostBetweenWindow.Create(AOrientation, AOtstup, ASize: Integer);
begin
  if (AOrientation <> 0) and (AOrientation <> 1) then
    raise Exception.Create('Ориентация должна быть 0 (X) или 1 (Y)');

  FOrientation := AOrientation;
  FXOtstup := AXOtstup;
  FYOtstup := AYOtstup;
  FSize := ASize;
end;

function TImpostBetweenWindow.IsHorizontal: Boolean;
begin
  Result := (FOrientation = 0);
end;

function TImpostBetweenWindow.IsVertical: Boolean;
begin
  Result := (FOrientation = 1);
end;

{ TImpostsBetweenWindows }

constructor TImpostsBetweenWindows.Create;
begin
  FImposts := TObjectList.Create(True); // True = владеет объектами
end;

destructor TImpostsBetweenWindows.Destroy;
begin
  FImposts.Free;
  inherited;
end;

procedure TImpostsBetweenWindows.AddImpost(Impost: TImpostBetweenWindow);
begin
  FImposts.Add(Impost);
end;

procedure TImpostsBetweenWindows.RemoveImpost(Index: Integer);
begin
  if (Index >= 0) and (Index < FImposts.Count) then
    FImposts.Delete(Index);
end;

function TImpostsBetweenWindows.GetImpost(Index: Integer): TImpostBetweenWindow;
begin
  Result := TImpostBetweenWindow(FImposts[Index]);
end;

function TImpostsBetweenWindows.Count: Integer;
begin
  Result := FImposts.Count;
end;

procedure TImpostsBetweenWindows.Clear;
begin
  FImposts.Clear;
end;

end.

