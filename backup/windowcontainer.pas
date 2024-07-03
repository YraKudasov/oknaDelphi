unit WindowContainer;

interface

uses
  Classes, SysUtils, Contnrs, AbstractWindow, RectWindow;

type
  TWindowContainer = class
  private
    FWindows: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddWindow(Window: TAbstractWindow);
    procedure RemoveWindow(Index: Integer);
    procedure Clear;
    function GetWindow(index: Integer): TAbstractWindow;
    function Count: Integer;
    function GetWindows: TObjectList;
    function IndexOf(const AWindow: TAbstractWindow): Integer;
    function GetSelectedIndex: Integer;
    function FindWindow(const ClickX, ClickY: Integer): Integer;
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

function TWindowContainer.GetWindows: TObjectList;
begin
  Result := FWindows;
end;

procedure TWindowContainer.RemoveWindow(Index: Integer);
begin
  if (Index >= 0) and (Index < FWindows.Count) then
  begin
    FWindows.Delete(Index);
  end;
end;

procedure TWindowContainer.Clear;
begin
  FWindows.Clear;
end;

function TWindowContainer.IndexOf(const AWindow: TAbstractWindow): Integer;
begin
  Result := FWindows.IndexOf(AWindow);
end;

function TWindowContainer.GetSelectedIndex: Integer;
var
  Index: Integer;
begin
  Result := -1; // Инициализируем результат, если ничего не выбрано
  for Index := 0 to Count - 1 do
  begin
    if FWindows[Index] is TRectWindow then
    begin
      if TRectWindow(FWindows[Index]).FSelected then
      begin
        Result := Index; // Возвращаем индекс выбранного экземпляра
        Break; // Прерываем цикл, так как нашли выбранный экземпляр
      end;
    end;
  end;
end;
// Другие методы, если необходимо

function TWindowContainer.FindWindow(const ClickX, ClickY: Integer): Integer;
var
  Index: Integer;
  Window: TAbstractWindow;
begin
  Result := -1; // Инициализируем результат, если ничего не найдено
  for Index := 0 to Count - 1 do
  begin
    Window := GetWindow(Index);
    if Assigned(Window) and Window.Contains(APoint) then
    begin
      Result := Index; // Возвращаем индекс окна, содержащего точку клика
      Break; // Прерываем цикл, так как нашли нужное окно
    end;
  end;
end;

end.
