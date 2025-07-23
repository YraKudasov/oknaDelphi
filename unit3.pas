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
    if TryStrToInt(Edit1.Text, WidthValue) and TryStrToInt(Edit2.Text, HeightValue) then
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
  I, CountX, CountY: Integer;
  NewX, NewY: Integer;
  MaxWidth, MaxHeight: Integer;
  XChanged, YChanged: Boolean;
begin
  MaxWidth := CurrWin.GetWidth;
  MaxHeight := CurrWin.GetHeight;

  CurrWin.GetPolygonVertices(Points);

  // Проверяем, изменена ли координата X
  XChanged := StrToInt(Edit3.Text) <> Points[CurrPoint].X;
  // Проверяем, изменена ли координата Y
  YChanged := StrToInt(Edit4.Text) <> Points[CurrPoint].Y;

  // Если изменены обе координаты — запрещаем
  if XChanged and YChanged then
  begin
    ShowMessage('Можно изменить только одну координату: либо X, либо Y.');
    Edit3.Text := IntToStr(Points[CurrPoint].X);
    Edit4.Text := IntToStr(Points[CurrPoint].Y);
    Exit;
  end;

  // Получаем новые координаты с защитой от неверного ввода
  if XChanged then
    NewX := StrToIntDef(Edit3.Text, Points[CurrPoint].X)
  else
    NewX := Points[CurrPoint].X;

  if YChanged then
    NewY := StrToIntDef(Edit4.Text, Points[CurrPoint].Y)
  else
    NewY := Points[CurrPoint].Y;

  // Проверяем условие: хотя бы одна координата должна быть на грани
  if not ((NewX = 0) or (NewX = MaxWidth) or (NewY = 0) or (NewY = MaxHeight)) then
  begin
    ShowMessage(Format('Хотя бы одна из координат новой точки должна находиться на грани: X = 0 или %d, либо Y = 0 или %d.',
      [MaxWidth, MaxHeight]));
    Edit3.Text := IntToStr(Points[CurrPoint].X);
    Edit4.Text := IntToStr(Points[CurrPoint].Y);
    Exit;
  end;

  // Проверяем, что не существует 3 и более точек с одинаковой координатой X или Y
  CountX := 1;
  CountY := 1;
  for I := 0 to High(Points) do
  begin
    if I <> CurrPoint then
    begin
      if Points[I].X = NewX then Inc(CountX);
      if Points[I].Y = NewY then Inc(CountY);
    end;
  end;

  if CountX >= 3 then
  begin
    ShowMessage('Ошибка: три и более вершины не могут иметь одинаковую координату X.');
    Edit3.Text := IntToStr(Points[CurrPoint].X);
    Edit4.Text := IntToStr(Points[CurrPoint].Y);
    Exit;
  end;

  if CountY >= 3 then
  begin
    ShowMessage('Ошибка: три и более вершины не могут иметь одинаковую координату Y.');
    Edit3.Text := IntToStr(Points[CurrPoint].X);
    Edit4.Text := IntToStr(Points[CurrPoint].Y);
    Exit;
  end;

  // Обновляем координаты
  Points[CurrPoint].X := NewX;
  Points[CurrPoint].Y := NewY;

  CurrWin.SetPolygonVertices(Points);
  CurrWin.DrawWindow;

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
  MaxWidth, MaxHeight: Integer;
  CountX, CountY: Integer;
begin
  CurrWin.GetPolygonVertices(Points);

  MaxWidth := CurrWin.GetWidth;
  MaxHeight := CurrWin.GetHeight;

  NewX := StrToIntDef(Edit1.Text, -1);
  NewY := StrToIntDef(Edit2.Text, -1);

  // Проверяем, что координаты валидны и точка находится на грани
  if (NewX < 0) or (NewY < 0) or
     not ((NewX = 0) or (NewX = MaxWidth) or (NewY = 0) or (NewY = MaxHeight)) then
  begin
    ShowMessage(Format('Хотя бы одна из координат новой точки должна находиться на грани: X = 0 или %d, либо Y = 0 или %d.',
      [MaxWidth, MaxHeight]));
    Exit;
  end;

  // Проверяем, что не будет 3 и более точек с одинаковой координатой X или Y после добавления
  CountX := 1; // учитываем новую точку
  CountY := 1;
  for I := 0 to High(Points) do
  begin
    if Points[I].X = NewX then Inc(CountX);
    if Points[I].Y = NewY then Inc(CountY);
  end;

  if CountX >= 3 then
  begin
    ShowMessage('Ошибка: три и более вершины не могут иметь одинаковую координату X.');
    Exit;
  end;

  if CountY >= 3 then
  begin
    ShowMessage('Ошибка: три и более вершины не могут иметь одинаковую координату Y.');
    Exit;
  end;

  InsertIndex := CurrPoint + 1;

  SetLength(NewPoints, Length(Points) + 1);

  for I := 0 to InsertIndex - 1 do
    NewPoints[I] := Points[I];

  NewPoints[InsertIndex].X := NewX;
  NewPoints[InsertIndex].Y := NewY;

  for I := InsertIndex to High(Points) do
    NewPoints[I + 1] := Points[I];

  CurrWin.SetPolygonVertices(NewPoints);
  CurrWin.DrawWindow;

  ComboBox1.Clear;
  for I := 0 to High(NewPoints) do
    ComboBox1.Items.Add(Format('(%d, %d)', [NewPoints[I].X, NewPoints[I].Y]));

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
  if Length(Points) <= 4 then
  begin
    ShowMessage('Нельзя удалить вершину: в многоугольнике должно оставаться не менее 4 вершин.');
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

    Button3.Enabled := False;
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
