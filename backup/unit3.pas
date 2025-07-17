unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, RectWindow;

type
  TPointArray = array of TPoint;

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;

    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChangePointCoordinates(Sender: TObject);
    procedure AddNewPoint(Sender: TObject);
    procedure DeletePoint(Sender: TObject);
  private
    CurrWin: TRectWindow;
    CurrPoint: Integer;
  public
        function GetCurrPoint: integer;
        procedure LoadWindow(Value: TRectWindow);
        procedure EditKeyPress(Sender: TObject; var Key: char);
        procedure EditChange(Sender: TObject);
        procedure EditChangeAddPoint(Sender: TObject);
  end;

var
  Form3: TForm3;

implementation



{$R *.lfm}

procedure TForm3.FormShow(Sender: TObject);
var
  Points: TPointArray;
  I: Integer;
begin
  ComboBox1.Items.Clear;
  CurrWin.GetPolygonVertices(Points);
  for I := 0 to High(Points) do
    ComboBox1.Items.Add(Format('(%d, %d)', [Points[I].X, Points[I].Y]));
    Edit1.OnKeyPress := @EditKeyPress;
    Edit2.OnKeyPress := @EditKeyPress;
    Edit3.OnKeyPress := @EditKeyPress;
    Edit4.OnKeyPress := @EditKeyPress;
    Edit1.OnChange := @EditChangeAddPoint;
    Edit2.OnChange := @EditChangeAddPoint;
    Edit3.OnChange := @EditChange;
    Edit4.OnChange := @EditChange;
    Button1.Enabled := False;
    Button2.Enabled := False;
    Button3.Enabled := False;
end;

procedure TForm3.ComboBox1Change(Sender: TObject);
var
Points: TPointArray;
begin
     CurrWin.GetPolygonVertices(Points);
    CurrPoint := ComboBox1.ItemIndex;
    Edit3.Text:= IntToStr(Points[CurrPoint].X);
    Edit4.Text:= IntToStr(Points[CurrPoint].Y);
    Button3.Enabled := ComboBox1.ItemIndex <> -1;
end;

{******** РЕГУЛЯРКА ДЛЯ ВВОДА РАЗМЕРОВ **********}
procedure TForm3.EditKeyPress(Sender: TObject; var Key: char);
begin
  // Allow only digits and control keys (e.g., backspace, delete)
  if not (Key in ['0'..'9', #8, #127]) then
    Key := #0; // Discard the key press event
end;

{******** ПРОВЕРКА КОРРЕКТНОСТИ ВВОДА РАЗМЕРОВ **********}
procedure TForm3.EditChange(Sender: TObject);
var
  WidthValue, HeightValue: integer;
begin
  // Проверка на ввод корректных значений
  if TryStrToInt(Edit4.Text, HeightValue) and TryStrToInt(Edit3.Text, WidthValue) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (WidthValue >= CurrWin.GetXOtstup) and (WidthValue <= CurrWin.GetXOtstup+CurrWin.GetWidth) and (HeightValue >= CurrWin.GetYOtstup) and
      (HeightValue <= CurrWin.GetYOtstup+CurrWin.GetHeight) then
      Button2.Enabled := True
    else
      Button2.Enabled := False;
  end
  else
    Button2.Enabled := False;
end;

procedure TForm3.EditChangeAddPoint(Sender: TObject);
var
  WidthValue, HeightValue: integer;
begin
  if (Edit1.Text <> '') and (Edit2.Text <> '') then
  begin
    if TryStrToInt(Edit1.Text, HeightValue) and TryStrToInt(Edit2.Text, WidthValue) then
    begin
      Button1.Enabled := (ComboBox1.ItemIndex <> -1) and
                         (WidthValue >= CurrWin.GetXOtstup) and (WidthValue <= CurrWin.GetXOtstup + CurrWin.GetWidth) and
                         (HeightValue >= CurrWin.GetYOtstup) and (HeightValue <= CurrWin.GetYOtstup + CurrWin.GetHeight);
    end
    else
      Button1.Enabled := False;
  end
  else
    Button1.Enabled := False;
end;

procedure TForm3.ChangePointCoordinates(Sender: TObject);
var
  Points: TPointArray;
  I: integer;
begin
  // Шаг 1: Извлекаем существующие вершины
  CurrWin.GetPolygonVertices(Points);

  // Шаг 2: Изменяем координаты указанной вершины
  Points[CurrPoint].X := StrToIntDef(Edit3.Text, Points[CurrPoint].X); // защита от неверного ввода
  Points[CurrPoint].Y := StrToIntDef(Edit4.Text, Points[CurrPoint].Y); // защита от неверного ввода

  // Шаг 3: Сохраняем обновлённые вершины обратно в объект окна
  CurrWin.SetPolygonVertices(Points);

  // Шаг 4: Перерисовка окна с учётом новых координат
  CurrWin.DrawWindow;

  // Шаг 5: Обновляем комбобокс с новыми координатами
  ComboBox1.Clear;
  for I := 0 to High(Points) do
    ComboBox1.Items.Add(Format('(%d, %d)', [Points[I].X, Points[I].Y]));

  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
end;

procedure TForm3.AddNewPoint(Sender: TObject);
var
  Points: TPointArray;
  NewPoints: TPointArray;
  I, InsertIndex: Integer;
  NewX, NewY: Integer;
begin
  // Получаем текущие вершины
  CurrWin.GetPolygonVertices(Points);

  // Получаем координаты новой точки с защитой от неверного ввода
  NewX := StrToIntDef(Edit1.Text, 0);
  NewY := StrToIntDef(Edit2.Text, 0);

  // Определяем индекс вставки (после CurrPoint)
  InsertIndex := CurrPoint + 1;

  // Создаём новый массив на одну точку больше
  SetLength(NewPoints, Length(Points) + 1);

  // Копируем точки до места вставки
  for I := 0 to InsertIndex - 1 do
    NewPoints[I] := Points[I];

  // Вставляем новую точку
  NewPoints[InsertIndex].X := NewX;
  NewPoints[InsertIndex].Y := NewY;

  // Копируем оставшиеся точки
  for I := InsertIndex to High(Points) do
    NewPoints[I + 1] := Points[I];

  // Сохраняем обновлённые вершины обратно в объект окна
  CurrWin.SetPolygonVertices(NewPoints);

  // Перерисовываем окно
  CurrWin.DrawWindow;

  // Обновляем ComboBox с новыми координатами
  ComboBox1.Clear;
  for I := 0 to High(NewPoints) do
    ComboBox1.Items.Add(Format('(%d, %d)', [NewPoints[I].X, NewPoints[I].Y]));

  // Очищаем поля ввода
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
end;

procedure TForm3.DeletePoint(Sender: TObject);
var
  Points: TPointArray;
  NewPoints: TPointArray;
  I, J: Integer;
begin
  // Получаем текущие вершины
  CurrWin.GetPolygonVertices(Points);

  // Проверяем, что CurrPoint в допустимом диапазоне
  if (CurrPoint < 0) or (CurrPoint > High(Points)) then
    Exit; // Индекс вне диапазона, ничего не делаем

  // Проверяем, что после удаления останется не меньше 3 вершин
  if Length(Points) <= 3 then
  begin
    ShowMessage('Нельзя удалить вершину: в многоугольнике должно оставаться не менее 3 вершин.');
    Exit;
  end;

  // Создаём новый массив на одну точку меньше
  SetLength(NewPoints, Length(Points) - 1);

  // Копируем все точки, кроме той, что нужно удалить
  J := 0;
  for I := 0 to High(Points) do
  begin
    if I <> CurrPoint then
    begin
      NewPoints[J] := Points[I];
      Inc(J);
    end;
  end;

  // Сохраняем обновлённые вершины обратно в объект окна
  CurrWin.SetPolygonVertices(NewPoints);

  // Перерисовываем окно
  CurrWin.DrawWindow;

  // Обновляем ComboBox с новыми координатами
  ComboBox1.Clear;
  for I := 0 to High(NewPoints) do
    ComboBox1.Items.Add(Format('(%d, %d)', [NewPoints[I].X, NewPoints[I].Y]));

  // Очищаем поля ввода
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';

  // Корректируем CurrPoint, если он вышел за пределы массива
  if CurrPoint > High(NewPoints) then
    CurrPoint := High(NewPoints);
end;

procedure TForm3.LoadWindow(Value: TRectWindow);
begin
  CurrWin := Value;
end;

function TForm3.GetCurrPoint: integer;
begin
  Result := CurrPoint;
end;

end.
