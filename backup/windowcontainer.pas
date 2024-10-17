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
    procedure RemoveWindow(Index: integer);
    procedure Clear;
    function GetWindow(index: integer): TRectWindow;
    function Count: integer;
    function GetWindows: TObjectList;
    function IndexOf(const AWindow: TAbstractWindow): integer;
    function GetSelectedIndex: integer;
    function FindWindow(const ClickX, ClickY: integer): integer;
     function GetIndexRowColumn(Row, Column: integer): Integer;
      function SortWindows: Boolean;
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

function TWindowContainer.IndexOf(const AWindow: TAbstractWindow): integer;
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
  Window: TAbstractWindow;
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

 function TWindowContainer.SortWindows: Boolean;
var
  i, j: Integer;
  Temp: TRectWindow;
begin
  Result := False;
  // Check if there are at least two windows to sort
  if Count < 2 then Exit;

  // Simple bubble sort algorithm
  for i := 0 to Count - 2 do
  begin
    for j := 0 to Count - 2 - i do
    begin
      if (FWindows[j] is TRectWindow) and (FWindows[j + 1] is TRectWindow) then
      begin
        if TRectWindow(FWindows[j]).GetRow > TRectWindow(FWindows[j + 1]).GetRow then
        begin
          // Swap the windows
          Temp := TRectWindow(FWindows[j]);
          FWindows[j] := FWindows[j + 1];
          FWindows[j + 1] := Temp;
          Result := True; // Indicate that a swap occurred
        end;
      end;
    end;
  end;
end;




end.
