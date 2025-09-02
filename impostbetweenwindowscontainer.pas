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



end.

