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
  private
    CurrWin: TRectWindow;
    CurrPoint: Integer;
  public
        function GetCurrPoint: integer;
        procedure LoadWindow(Value: TRectWindow);
        procedure EditKeyPress(Sender: TObject; var Key: char);
        procedure EditChange(Sender: TObject);
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
    Edit3.OnKeyPress := @EditKeyPress;
    Edit4.OnKeyPress := @EditKeyPress;
    Edit3.OnChange := @EditChange;
    Edit4.OnChange := @EditChange;
end;

procedure TForm3.ComboBox1Change(Sender: TObject);
var
Points: TPointArray;
begin
     CurrWin.GetPolygonVertices(Points);
    CurrPoint := ComboBox1.ItemIndex;
    Edit3.Text:= IntToStr(Points[CurrPoint].X);
    Edit4.Text:= IntToStr(Points[CurrPoint].Y);
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
  if TryStrToInt(Edit3.Text, HeightValue) and TryStrToInt(Edit4.Text, WidthValue) then
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

  Edit3.Text := '';
  Edit4.Text := '';
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
