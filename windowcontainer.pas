unit WindowContainer;

interface

uses
  Classes, SysUtils, Contnrs, RectWindow;

type
  TWindowContainer = class
  private
    FWindows: TObjectList;
    FCommonXOtstup: integer;
    FConstrWidth: integer;
    FConstrHeight: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddWindow(Window: TRectWindow);
    procedure RemoveWindow(Index: integer);
    procedure Clear;
    function GetWindow(index: integer): TRectWindow;
    function Count: integer;
    function GetWindows: TObjectList;
    function IndexOf(const AWindow: TRectWindow): integer;
    function GetSelectedIndex: integer;
    function FindWindow(const ClickX, ClickY: integer): integer;
    function GetIndexRowColumn(Row, Column: integer): Integer;
    function GetConstrWidth: integer;
    procedure SetConstrWidth(Value: integer);
    function GetConstrHeight: integer;
    procedure SetConstrHeight(Value: integer);
    procedure SetCommonXOtstup(Value: integer);
    function GetCommonXOtstup: integer;
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

procedure TWindowContainer.AddWindow(Window: TRectWindow);
begin
  FWindows.Add(Window);
end;

function TWindowContainer.GetWindow(index: integer): TRectWindow;
begin
  Result := TRectWindow(FWindows[index]);
end;

  function TWindowContainer.GetIndexRowColumn(Row, Column: integer): Integer;
  var
    Index: integer;
  begin
    Result := -1;
    // Инициализируем результат, если ничего не выбрано
    for Index := 0 to Count - 1 do
    begin
      if FWindows[Index] is TRectWindow then
      begin
        if ((TRectWindow(FWindows[Index]).GetRow = Row) and (TRectWindow(FWindows[Index]).GetRow = Column)) then
        begin
          Result := Index;
          // Возвращаем индекс выбранного экземпляра
          Break;
          // Прерываем цикл, так как нашли выбранный экземпляр
        end;
      end;
    end;
  end;

function TWindowContainer.Count: integer;
begin
  Result := FWindows.Count;
end;

function TWindowContainer.GetWindows: TObjectList;
begin
  Result := FWindows;
end;

procedure TWindowContainer.RemoveWindow(Index: Integer);
var
  i: Integer;
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

function TWindowContainer.IndexOf(const AWindow: TRectWindow): integer;
begin
  Result := FWindows.IndexOf(AWindow);
end;

function TWindowContainer.GetSelectedIndex: integer;
var
  Index: integer;
begin
  Result := -1;
  // Инициализируем результат, если ничего не выбрано
  for Index := 0 to Count - 1 do
  begin
    if FWindows[Index] is TRectWindow then
    begin
      if TRectWindow(FWindows[Index]).FSelected then
      begin
        Result := Index;
        // Возвращаем индекс выбранного экземпляра
        Break;
        // Прерываем цикл, так как нашли выбранный экземпляр
      end;
    end;
  end;
end;
// Другие методы, если необходимо

function TWindowContainer.FindWindow(const ClickX, ClickY: integer): integer;
var
  Index: integer;
  Window: TRectWindow;
begin
  Result := -1;
  // Инициализируем результат, если ничего не найдено
  for Index := 0 to Count - 1 do
  begin
    Window := GetWindow(Index);
    if Assigned(Window) and Window.Contains(ClickX, ClickY) then
    begin
      Result := Index;
      // Возвращаем индекс окна, содержащего точку клика
      Break; // Прерываем цикл, так как нашли нужное окно
    end;
  end;
end;

function TWindowContainer.GetConstrWidth: integer;
begin
  Result := FConstrWidth;
end;

procedure TWindowContainer.SetConstrWidth(Value: integer);
begin
  FConstrWidth := Value;
end;

function TWindowContainer.GetConstrHeight: integer;
begin
  Result := FConstrHeight;
end;

procedure TWindowContainer.SetConstrHeight(Value: integer);
begin
  FConstrHeight := Value;
end;

function TWindowContainer.GetCommonXOtstup: integer;
begin
  Result := FCommonXOtstup;
end;

procedure TWindowContainer.SetCommonXOtstup(Value: integer);
begin
  FCommonXOtstup := Value;
end;



end.
