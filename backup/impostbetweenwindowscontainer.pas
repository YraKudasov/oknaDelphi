unit ImpostBetweenWindowsContainer;

interface

uses
  Classes, SysUtils, Contnrs, Graphics, ExtCtrls,
  ImpostBetweenWindows;

type
  TImpostBetweenWindowsContainer = class
  private
    FImposts: TObjectList; // список импостов
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddImpost(Impost: TImpostBetweenWindow);
    procedure RemoveImpost(Index: Integer);
    function GetImpost(Index: Integer): TImpostBetweenWindow;
    function Count: Integer;
    procedure Clear;

    // Отрисовка всех импостов на Canvas
    procedure DrawAll(Image: TImage; ZoomIndex: Double);
  end;

implementation

{ TImpostBetweenWindowsContainer }

constructor TImpostBetweenWindowsContainer.Create;
begin
  FImposts := TObjectList.Create(True); // True = владеет объектами
end;

destructor TImpostBetweenWindowsContainer.Destroy;
begin
  FImposts.Free;
  inherited;
end;

procedure TImpostBetweenWindowsContainer.AddImpost(Impost: TImpostBetweenWindow);
begin
  FImposts.Add(Impost);
end;

procedure TImpostBetweenWindowsContainer.RemoveImpost(Index: Integer);
begin
  if (Index >= 0) and (Index < FImposts.Count) then
    FImposts.Delete(Index);
end;

function TImpostBetweenWindowsContainer.GetImpost(Index: Integer): TImpostBetweenWindow;
begin
  Result := TImpostBetweenWindow(FImposts[Index]);
end;

function TImpostBetweenWindowsContainer.Count: Integer;
begin
  Result := FImposts.Count;
end;

procedure TImpostBetweenWindowsContainer.Clear;
begin
  FImposts.Clear;
end;

procedure TImpostBetweenWindowsContainer.DrawAll(Image: TImage; ZoomIndex: Double);
var
  i: Integer;
  Impost: TImpostBetweenWindow;
  MidX, MidY: Integer;
begin
  Image.Canvas.Pen.Width := 2;
  Image.Canvas.Pen.Color := clGray;

  for i := 0 to Count - 1 do
  begin
    Impost := GetImpost(i);

    if Impost.IsHorizontal then
    begin
      MidY := Round(Impost.Size * ZoomIndex);
      Image.Canvas.MoveTo(0, MidY);
      Image.Canvas.LineTo(Image.Width, MidY);
    end
    else if Impost.IsVertical then
    begin
      MidX := Round(Impost.Size * ZoomIndex);
      Image.Canvas.MoveTo(MidX, 0);
      Image.Canvas.LineTo(MidX, Image.Height);
    end;
  end;
end;

end.

