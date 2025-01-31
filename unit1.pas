unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, Menus, RectWindow, WindowContainer,
  LCLType, Grids, Generics.Collections;

const
  tfInputMask = 'InputMask';
  // Пример определения константы, если она не найдена

type
  { TForm1 }
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    ScrollBox1: TScrollBox;
    StringGrid1: TStringGrid;





    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SizeConstruction(Sender: TObject);
    procedure SizeWindow(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteVerticalImpost(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: char);
    procedure EditChange(Sender: TObject);
    procedure EditChange2(Sender: TObject);
    procedure RectWindowSelected(Sender: TObject);
    procedure RectWindowDeselected(Sender: TObject);
    procedure VerticalImpost(VertImpost: integer);
    procedure CanvasClickHandler(Sender: TObject);
    procedure DrawWindows;
    function CheckSelectionWindows: boolean;
    procedure InputVerticalImpost(Sender: TObject);
    procedure InputHorizontalImpost(Sender: TObject);
    procedure HorizontalImpost(HorizImpost: integer);
    procedure DeleteHorizontalImpost(Sender: TObject);
    function CheckHeightChange: boolean;
    function CheckWidthChange: boolean;
    function UpdateIndexes(OperationNum, NewRow, NewCol, NewOtstup: integer): integer;
    function DrawingIndex: double;
    procedure UpdateTable;
    procedure PaintSizes;




  private
    { Private declarations }
    RectWindow: TRectWindow;
    FRectHeight, FRectWidth: integer;
    WindowContainer: TWindowContainer;
    // Добавляем экземпляр WindowContainer


  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParams(AOwner: TComponent);
  end;

var
  Form1: TForm1;


implementation

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TForm1.CreateWithParams(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{$R *.lfm}

{ TForm1 }


{******** ИЗМЕНЕНИЕ РАЗМЕРОВ КОНСТРУКЦИИ **********}
procedure TForm1.SizeConstruction(Sender: TObject);
var
  Window: TRectWindow;
  I, DiffX, DiffY: integer;
begin
    if ((StrToInt(Edit3.Text) <> FRectHeight) or
      (StrToInt(Edit4.Text) <> FRectWidth)) then
    begin
      if ((CheckHeightChange = False) or (CheckWidthChange = False)) then
      begin
        ShowMessage(
          'После изменения размеров конструкции, размеры окна(окон) стали меньше минимально допустимых');
        Edit3.Text := IntToStr(FRectHeight);
        Edit4.Text := IntToStr(FRectWidth);
      end
      else
      begin
        for I := 0 to WindowContainer.Count - 1 do
        begin
          Window := TRectWindow(WindowContainer.GetWindow(I));
          DiffY := StrToInt(Edit3.Text) - FRectHeight;
          DiffX := StrToInt(Edit4.Text) - FRectWidth;
          if (Window.GetYOtstup = 0) then
          begin
            Window.SetHeight(Window.GetHeight + DiffY);
            UpdateTable;
          end
          else
          begin
            Window.SetYOtstup(Window.GetYOtstup + DiffY);
          end;
          if (Window.GetXOtstup = 0) then
          begin
            Window.SetWidth(Window.GetWidth + DiffX);
            UpdateTable;
          end
          else
          begin
            Window.SetXOtstup(Window.GetXOtstup + DiffX);
          end;
        end;
      end;
      FRectHeight := StrToInt(Edit3.Text);
      FRectWidth := StrToInt(Edit4.Text);
    end;
    Image1.Canvas.Brush.Color := clWhite;
    Image1.Canvas.FillRect(0, 0, 3500, 2000);
    DrawWindows;

end;

{******** ИЗМЕНЕНИЕ РАЗМЕРОВ ОКНА **********}
procedure TForm1.SizeWindow(Sender: TObject);
var
  NearWindow, Window, ChangedWindow: TRectWindow;
  i, a, ind, DiffY, DiffX, HeightLeft, HeightRight, WidthUp, WidthDown: integer;
  WUpCont, WDownCont, HLeftCont, HRightCont: TList;
begin
  for i := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(i));
    if Window.GetSelection then
      // Use the getter method to check if the window is selected
    begin
      if ((StrToInt(Edit1.Text) <> Window.GetHeight) or
        (StrToInt(Edit2.Text) <> Window.GetWidth)) then
      begin

        DiffY := Window.GetHeight - StrToInt(Edit1.Text);
        DiffX := Window.GetWidth - StrToInt(Edit2.Text);
        HeightLeft := 0;
        WidthUp := 0;
        HeightRight := 0;
        WidthDown := 0;
        WUpCont := TList.Create;
        WDownCont := TList.Create;
        HLeftCont := TList.Create;
        HRightCont := TList.Create;


        if ((StrToInt(Edit1.Text) > FRectHeight) or
          (StrToInt(Edit2.Text) > FRectWidth)) then
        begin
          ShowMessage(
            'Введенные размеры окна больше размеров конструкции');
          Edit1.Text := IntToStr(FRectHeight);
          Edit2.Text := IntToStr(FRectWidth);
        end


        else
        begin
         {
         Изменение ширины отдельного окна
         }
          if (DiffY <> 0) then
          begin
            for a := 0 to WindowContainer.Count - 1 do
            begin
              NearWindow := TRectWindow(WindowContainer.GetWindow(a));

              if ((NearWindow.GetYOtstup = (Window.GetYOtstup + Window.GetHeight)) and
                (Window.GetXOtstup <= NearWindow.GetXOtstup) and
                ((Window.GetXOtstup + Window.GetWidth) >= NearWindow.GetXOtstup) and
                ((Window.GetXOtstup + Window.GetWidth) >=
                (NearWindow.GetXOtstup + NearWindow.GetWidth)) and
                ((NearWindow.GetHeight + DiffY) > 450)) then
              begin
                WidthDown := WidthDown + NearWindow.GetWidth;
                WDownCont.Add(Pointer(a));
              end;

              if (((NearWindow.GetYOtstup + NearWindow.GetHeight) =
                Window.GetYOtstup) and (Window.GetXOtstup <= NearWindow.GetXOtstup) and
                ((Window.GetXOtstup + Window.GetWidth) >= NearWindow.GetXOtstup) and
                ((Window.GetXOtstup + Window.GetWidth) >=
                (NearWindow.GetXOtstup + NearWindow.GetWidth)) and
                ((NearWindow.GetHeight + DiffY) > 450)) then
              begin
                WidthUp := WidthUp + NearWindow.GetWidth;
                WUpCont.Add(Pointer(a));
              end;

            end;

            if (WidthDown = Window.GetWidth) then
            begin
              Window.SetHeight(Window.GetHeight - DiffY);
              for a := 0 to WDownCont.Count - 1 do
              begin
                ind := integer(WDownCont.Items[a]);
                ChangedWindow := TRectWindow(WindowContainer.GetWindow(ind));
                ChangedWindow.SetHeight(ChangedWindow.GetHeight + DiffY);
                ChangedWindow.SetYOtstup(ChangedWindow.GetYOtstup - DiffY);
                UpdateTable;
              end;
            end
            else if (WidthUp = Window.GetWidth) then
            begin
              Window.SetHeight(Window.GetHeight - DiffY);
              Window.SetYOtstup(Window.GetYOtstup + DiffY);
              UpdateTable;
              for a := 0 to WUpCont.Count - 1 do
              begin
                ind := integer(WUpCont.Items[a]);
                ChangedWindow := TRectWindow(WindowContainer.GetWindow(ind));
                ChangedWindow.SetHeight(ChangedWindow.GetHeight + DiffY);
                UpdateTable;
              end;
            end
            else
              ShowMessage(
                'ВЫСОТУ окна НЕ удалось изменить. Возможно размеры СОСЕДНИХ окон становятся МЕНЬШЕ минимально допустимых при изменении размеров данного.');
          end;
          {
         Изменение высоты отдельного окна
         }
          if (DiffX <> 0) then
          begin
            for a := 0 to WindowContainer.Count - 1 do
            begin
              NearWindow := TRectWindow(WindowContainer.GetWindow(a));

              if ((NearWindow.GetXOtstup = (Window.GetXOtstup + Window.GetWidth)) and
                (Window.GetYOtstup <= NearWindow.GetYOtstup) and
                ((Window.GetYOtstup + Window.GetHeight) >= NearWindow.GetYOtstup) and
                ((Window.GetYOtstup + Window.GetHeight) >=
                (NearWindow.GetYOtstup + NearWindow.GetHeight)) and
                ((NearWindow.GetWidth + DiffX) > 450)) then
              begin
                HeightRight := HeightRight + NearWindow.GetHeight;
                HRightCont.Add(Pointer(a));
              end;

              if (((NearWindow.GetXOtstup + NearWindow.GetWidth) = Window.GetXOtstup) and
                (Window.GetYOtstup <= NearWindow.GetYOtstup) and
                ((Window.GetYOtstup + Window.GetHeight) >= NearWindow.GetYOtstup) and
                ((Window.GetYOtstup + Window.GetHeight) >=
                (NearWindow.GetYOtstup + NearWindow.GetHeight)) and
                ((NearWindow.GetWidth + DiffX) > 450)) then
              begin
                HeightLeft := HeightLeft + NearWindow.GetHeight;
                HLeftCont.Add(Pointer(a));
              end;

            end;

            if (HeightRight = Window.GetHeight) then
            begin
              Window.SetWidth(Window.GetWidth - DiffX);
              UpdateTable;
              for a := 0 to HRightCont.Count - 1 do
              begin
                ind := integer(HRightCont.Items[a]);
                ChangedWindow := TRectWindow(WindowContainer.GetWindow(ind));
                ChangedWindow.SetWidth(ChangedWindow.GetWidth + DiffX);
                ChangedWindow.SetXOtstup(ChangedWindow.GetXOtstup - DiffX);
                StringGrid1.Cells[2, ChangedWindow.GetTableIdx] :=
                  IntToStr(Window.GetWidth);
              end;
            end
            else if (HeightLeft = Window.GetHeight) then
            begin
              Window.SetWidth(Window.GetWidth - DiffX);
              Window.SetXOtstup(Window.GetXOtstup + DiffX);
              UpdateTable;
              for a := 0 to HLeftCont.Count - 1 do
              begin
                ind := integer(HLeftCont.Items[a]);
                ChangedWindow := TRectWindow(WindowContainer.GetWindow(ind));
                ChangedWindow.SetWidth(ChangedWindow.GetWidth + DiffX);
                UpdateTable;
              end;
            end
            else
              ShowMessage(
                'ШИРИНУ окна НЕ удалось изменить. Возможно размеры СОСЕДНИХ окон становятся МЕНЬШЕ минимально допустимых при изменении размеров данного.');
          end;
        end;
        Window.Select(Self);
        Image1.Canvas.Brush.Color := clWhite;
        Image1.Canvas.FillRect(0, 0, 3500, 2000);
        DrawWindows;
      end;
    end;
  end;
end;

{******** ВЫДЕЛЕНИЕ ОКНА ПРИ КЛИКЕ **********}
procedure TForm1.RectWindowSelected(Sender: TObject);
var
  Window: TRectWindow;
begin
  Window := TRectWindow(Sender);
  if Assigned(Window) then
  begin
    Panel1.Enabled := True;
    Panel3.Enabled := True;
    Edit1.Text := IntToStr(Window.GetHeight);
    Edit2.Text := IntToStr(Window.GetWidth);
    MenuItem2.Enabled := True;
    MenuItem3.Enabled := True;
    MenuItem5.Enabled := True;
    MenuItem6.Enabled := True;
    ComboBox1.Enabled := True;
    ComboBox1.ItemIndex := Window.GetType;
    if(Window.GetType <> 0) then
    begin
    CheckBox1.Visible := True;
    CheckBox1.Checked := Window.GetMoskit;
    Label8.Visible:= True;
    end;
     {
    ShowMessage('Номер окна' + IntToStr(Window.GetRow) +
      '.' + IntToStr(Window.GetColumn));
      }
  end;
end;

{******** ОТМЕНА ВЫДЕЛЕНИЯ **********}
procedure TForm1.RectWindowDeselected(Sender: TObject);
begin
  Edit1.Text := '0';
  Edit2.Text := '0';
  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
  MenuItem5.Enabled := False;
  MenuItem6.Enabled := False;
  Panel1.Enabled := False;
  Panel3.Enabled := False;
  ComboBox1.Enabled := False;
  CheckBox1.Visible:= False;
  Label8.Visible:= False;
end;


{******** ИЗМЕНЕНИЕ ТИПА ОКНА **********}
procedure TForm1.ComboBox1Change(Sender: TObject);
var
  Window: TRectWindow;
begin
  if (FRectHeight <> 0) and (FRectWidth <> 0) then
  begin
    Window := TRectWindow(WindowContainer.GetWindow(WindowContainer.GetSelectedIndex));
    if Assigned(Window) then
    begin
      Window.SetType(ComboBox1.ItemIndex);
      UpdateTable;
      if(Window.GetType <> 0) then
        begin
          CheckBox1.Visible := True;
          CheckBox1.Checked := Window.GetMoskit;
          Label8.Visible:= True;
        end
      else begin
        CheckBox1.Visible := False;
        Label8.Visible:= False;
      end;
      Window.SetZoomIndex(DrawingIndex);
      Window.DrawWindow;
    end;
  end;
end;

{******** ПОДСЧЕТ ИНДЕКСА ОТРИСОВКИ **********}
function TForm1.DrawingIndex: double;
var DIndex: double;
  begin
    if ((FrectHeight < 1300) and (FRectWidth < 1625)) then
        DIndex := 0.25
    else if ((FrectHeight < 1800) and (FRectWidth < 2250)) then
        DIndex := 0.22
    else if ((FrectHeight >= 1800) or (FRectWidth >= 2250)) then
        DIndex := 0.21;
    Result := DIndex;
  end;

{******** ИЗМЕНЕНИЕ НАЛИЧИЯ МОСКИТНОЙ СЕТКИ **********}
procedure TForm1.CheckBox1Change(Sender: TObject);
var
   Window: TRectWindow;
begin
    if (FRectHeight <> 0) and (FRectWidth <> 0) then
  begin
    Window := TRectWindow(WindowContainer.GetWindow(WindowContainer.GetSelectedIndex));
    if Assigned(Window) then
    begin
      if (CheckBox1.Checked) then
      begin
        Window.SetMoskit(true);
        UpdateTable;
        Window.SetZoomIndex(DrawingIndex);
        Window.DrawWindow;
    end
      else
      begin
        Window.SetMoskit(false);
        UpdateTable;
        Window.SetZoomIndex(DrawingIndex);
        Window.DrawWindow;
    end;
  end;
end;
end;


{******** ОТМЕНА РАЗМЕРОВ КОНСТРУКЦИИ **********}
procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  Edit3.Text := IntToStr(FRectHeight);
  Edit4.Text := IntToStr(FRectWidth);
end;

{******** ОТМЕНА РАЗМЕРОВ ОКНА **********}
procedure TForm1.BitBtn2Click(Sender: TObject);
var Window: TRectWindow;
   i: integer;
begin
   for i := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(i));
    if Window.GetSelection then
    begin
      Edit1.Text := IntToStr(Window.GetHeight);
      Edit2.Text := IntToStr(Window.GetWidth);
        end;
    end;
end;

{******** СОЗДАНИЕ ФОРМЫ **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.Enabled := False;
  Panel2.Enabled := False;
  Panel3.Enabled := False;
  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
  MenuItem5.Enabled := False;
  MenuItem6.Enabled := False;
  CheckBox1.Visible := False;
  Label8.Visible:= False;
end;



{******** ОТРИСОВКА СТАРТОВОЙ КОНСТРУКЦИИ **********}
procedure TForm1.Button1Click(Sender: TObject);
var  RectWidth, RectHeight: integer;
begin

  if Button1.Enabled then
  begin
    Self.SetFocus;
    MenuItem2.Enabled := False;
    MenuItem3.Enabled := False;
    MenuItem5.Enabled := False;
    MenuItem6.Enabled := False;
    Panel2.Enabled := True;
    Panel3.Enabled := True;
    Bitbtn3.Enabled := False;

    Image1.Canvas.Brush.Color := clWhite;
    Image1.Canvas.FillRect(Image1.ClientRect);

    StringGrid1.RowCount := 1;
    ComboBox1.Enabled := False;
    ComboBox1.ItemIndex := 0;
    CheckBox1.Visible := False;
    Label8.Visible:= False;
    // Сохраните старые значения
    FRectHeight := 0;
    FRectWidth := 0;

    Panel1.Enabled := False;
    Edit1.Text := '0';
    Edit2.Text := '0';

    Edit3.Text := IntToStr(FRectWidth);
    Edit4.Text := IntToStr(FRectHeight);

    Edit3.OnKeyPress := @EditKeyPress;
    // Обработчик события нажатия клавиши
    Edit3.OnChange := @EditChange;
    // Обработчик события изменения значения

    // Обработчик события нажатия клавиши
    Edit4.OnKeyPress := @EditKeyPress;
    // Обработчик события изменения значения
    Edit4.OnChange := @EditChange;

    Edit1.OnKeyPress := @EditKeyPress;
    // Обработчик события нажатия клавиши
    Edit1.OnChange := @EditChange2;
    // Обработчик события изменения значения

    // Обработчик события нажатия клавиши
    Edit2.OnKeyPress := @EditKeyPress;
    // Обработчик события изменения значения
    Edit2.OnChange := @EditChange2;


    Edit3.text := '1000';
    Edit4.text := '1000';


     WindowContainer := TWindowContainer.Create;

    // Создаем экземпляр WindowContainer

    // Получение значений из Edit3 и Edit4
    RectHeight := StrToInt(Edit3.Text);
    RectWidth := StrToInt(Edit4.Text);

    FRectWidth := RectWidth;
    FRectHeight := RectHeight;
    // Инициализация окна
    RectWindow := TRectWindow.Create(1, 1, RectHeight, RectWidth,
      Image1, 0, 0, ComboBox1.ItemIndex, false);
    WindowContainer.AddWindow(RectWindow);


    UpdateTable;
    // Отрисовка окна на изображении
    RectWindow.SetZoomIndex(DrawingIndex);
    RectWindow.DrawWindow;

    Image1.OnClick := @CanvasClickHandler;


    // Присоединяем обработчик события OnWindowSelected

    RectWindowDeselected(Self);
    RectWindow.OnWindowSelected := @RectWindowSelected;
    RectWindow.OnWindowDeselected := @RectWindowDeselected;

    PaintSizes;
  end;
end;


{******** РЕГУЛЯРКА ДЛЯ ВВОДА РАЗМЕРОВ **********}
procedure TForm1.EditKeyPress(Sender: TObject; var Key: char);
begin
  // Allow only digits and control keys (e.g., backspace, delete)
  if not (Key in ['0'..'9', #8, #127]) then
    Key := #0; // Discard the key press event
end;

{******** ПРОВЕРКА КОРРЕКТНОСТИ ВВОДА РАЗМЕРОВ **********}
procedure TForm1.EditChange(Sender: TObject);
var
  WidthValue, HeightValue: integer;
begin
  // Проверка на ввод корректных значений
  if TryStrToInt(Edit3.Text, HeightValue) and TryStrToInt(Edit4.Text, WidthValue) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (WidthValue >= 450) and (WidthValue <= 3500) and (HeightValue >= 450) and
      (HeightValue <= 2000) then
      BitBtn3.Enabled := True
    else
      BitBtn3.Enabled := False;
  end
  else
    BitBtn3.Enabled := False;
end;


{******** ПРОВЕРКА КОРРЕКТНОСТИ ВВОДА РАЗМЕРОВ **********}
procedure TForm1.EditChange2(Sender: TObject);
var
  WidthValue, HeightValue: integer;
begin
  // Проверка на ввод корректных значений
  if TryStrToInt(Edit1.Text, HeightValue) and TryStrToInt(Edit2.Text, WidthValue) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (WidthValue >= 450) and (WidthValue <= 3500) and (HeightValue >= 450) and
      (HeightValue <= 2000) then
      BitBtn1.Enabled := True
    else
      BitBtn1.Enabled := False;
  end
  else
    BitBtn1.Enabled := False;
end;

{******** ОТРИСОВКА РАЗМЕРОВ **********}

procedure TForm1.PaintSizes;
var
  KoefPaint: double;
  ScaledWidth, ScaledHeight: integer;
begin
  KoefPaint := DrawingIndex;
  ScaledWidth := Round((KoefPaint) * FRectWidth);
  ScaledHeight := Round((KoefPaint) * FRectHeight);
  Image1.Canvas.Pen.Width := 1 ;
  Image1.Canvas.Pen.Color := clBlack;
    Image1.Canvas.Font.Size := 11;
  Image1.Canvas.Brush.Style := bsClear;
  //Линия высоты
  Image1.Canvas.MoveTo(ScaledWidth+20, 3);
  Image1.Canvas.LineTo(ScaledWidth+20, ScaledHeight);
  Image1.Canvas.TextOut(ScaledWidth+35, ScaledHeight div 2 - 10, IntToStr(FRectHeight));
  //Маленькая линия высоты (сверху)
  Image1.Canvas.MoveTo(ScaledWidth, 3);
  Image1.Canvas.LineTo(ScaledWidth+30, 3);
  //Маленькая линия высоты (снизу)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth+30, ScaledHeight);


  //Линия ширины
  Image1.Canvas.MoveTo(3, ScaledHeight+20);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight+20);
  Image1.Canvas.TextOut(ScaledWidth div 2 - 10, ScaledHeight + 35, IntToStr(FRectWidth));
  //Маленькая линия ширины (слева)
  Image1.Canvas.MoveTo(3, ScaledHeight);
  Image1.Canvas.LineTo(3, ScaledHeight+30);
  //Маленькая линия ширины (справа)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight+30);

end;


{******** ВНЕСЕНИЕ РАЗМЕРОВ ВЕРТИКАЛЬНОГО ИМПОСТА **********}
procedure TForm1.InputVerticalImpost(Sender: TObject);
var
  Number: string;
  VertImpost: integer;
begin
  Number := '0';
  // Создаем диалог для ввода числа
  if InputQuery('Размер вертикального импоста',
    'Расстояние от левой границы окна (мм):', Number) then
  begin
    if TryStrToInt(Number, VertImpost) then
    begin
      VerticalImpost(VertImpost);
    end
    else
    begin
      ShowMessage('Некорректный ввод числа');
    end;

  end;
end;

{******** ВНЕСЕНИЕ РАЗМЕРОВ ГОРИЗОНТАЛЬНОГО ИМПОСТА **********}
procedure TForm1.InputHorizontalImpost(Sender: TObject);
var
  Number: string;
  HorizImpost: integer;
begin
  Number := '0';
  // Создаем диалог для ввода числа
  if InputQuery('Размер горизонтального импоста',
    'Расстояние от верхней границы окна (мм):',
    Number) then
  begin
    if TryStrToInt(Number, HorizImpost) then
    begin
      HorizontalImpost(HorizImpost);
    end
    else
    begin
      ShowMessage('Некорректный ввод числа');
    end;

  end;
end;

{******** ДОБАВЛЕНИЕ ВЕРТИКАЛЬНОГО ИМПОСТА **********}
procedure TForm1.VerticalImpost(VertImpost: integer);
var
  WindowIndex, Otstup: integer;
  Window, Window1, Window2: TRectWindow;
begin
  // Находим индекс окна, которое нужно разделить
  WindowIndex := WindowContainer.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(WindowContainer.GetWindow(WindowIndex));
    if Assigned(Window) then
    begin
      Otstup := Window.GetXOtstup;
      if ((VertImpost >= (Window.GetSize.Y - 450)) or (VertImpost <= 450)) then
      begin
        ShowMessage(
          'Размеры импоста больше или меньше критически допустимых');
      end
      else
      begin
        // Разделяем окно на два новых экземпляра
        Window1 := TRectWindow.Create(Window.GetRow, Window.GetColumn,
          Window.GetSize.X, VertImpost, Image1, Otstup, Window.GetYOtstup,
          ComboBox1.ItemIndex, false);
        Window2 := TRectWindow.Create(Window.GetRow, Window.GetColumn +
          1, Window.GetSize.X, Window.GetSize.Y - VertImpost, Image1,
          Otstup + VertImpost, Window.GetYOtstup, ComboBox1.ItemIndex, false);

        UpdateIndexes(0, Window.GetRow, Window.GetColumn + 1, Otstup);


        // Удаляем исходное окно из контейнера
        WindowContainer.RemoveWindow(WindowIndex);

        // Добавляем два новых окна в контейнер
        WindowContainer.AddWindow(Window1);
        WindowContainer.AddWindow(Window2);


        UpdateTable;

        if WindowContainer.Count > 0 then
        begin
          ShowMessage('Экземпляр окна был добавлен в контейнер.'
            + IntToStr(WindowContainer.Count));
        end;
        if WindowContainer.Count = 0 then
        begin
          ShowMessage('Контейнер пустой');
        end;

        RectWindowDeselected(Self);
        Window1.OnWindowSelected := @RectWindowSelected;
        Window2.OnWindowSelected := @RectWindowSelected;
        Window1.OnWindowDeselected := @RectWindowDeselected;
        Window2.OnWindowDeselected := @RectWindowDeselected;

        Image1.Canvas.Brush.Color := clWhite;
        Image1.Canvas.FillRect(Image1.ClientRect);
        DrawWindows;

      end;
    end;
  end;
end;


{******** ДОБАВЛЕНИЕ ГОРИЗОНТАЛЬНОГО ИМПОСТА **********}
procedure TForm1.HorizontalImpost(HorizImpost: integer);
var
  NewCol: integer;
  WindowIndex: integer;
  Window, Window1, Window2: TRectWindow;
begin
  // Находим индекс окна, которое нужно разделить
  WindowIndex := WindowContainer.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(WindowContainer.GetWindow(WindowIndex));
    if Assigned(Window) then
    begin
      if ((HorizImpost >= (Window.GetSize.X - 450)) or (HorizImpost <= 450)) then
      begin
        ShowMessage(
          'Размеры импоста больше или меньше критически допустимых');
      end
      else
      begin
        // Разделяем окно на два новых экземпляра
        Window1 := TRectWindow.Create(Window.GetRow, Window.GetColumn,
          HorizImpost, Window.GetWidth, Image1, Window.GetXOtstup,
          Window.GetYOtstup, ComboBox1.ItemIndex, false);

        NewCol := UpdateIndexes(2, Window.GetRow + 1, Window.GetColumn,
          Window.GetXOtstup);

        Window2 := TRectWindow.Create(Window.GetRow + 1, NewCol,
          Window.GetSize.X - HorizImpost, Window.GetWidth, Image1,
          Window.GetXOtstup, Window.GetYOtstup + HorizImpost, ComboBox1.ItemIndex, false);

        // Удаляем исходное окно из контейнера
        WindowContainer.RemoveWindow(WindowIndex);

        // Добавляем два новых окна в контейнер
        WindowContainer.AddWindow(Window1);
        WindowContainer.AddWindow(Window2);


        UpdateTable;

        if WindowContainer.Count > 0 then
        begin
          ShowMessage('Экземпляр окна был добавлен в контейнер.'
            + IntToStr(WindowContainer.Count));
        end;
        if WindowContainer.Count = 0 then
        begin
          ShowMessage('Контейнер пустой');
        end;

        RectWindowDeselected(Self);
        Window1.OnWindowSelected := @RectWindowSelected;
        Window2.OnWindowSelected := @RectWindowSelected;
        Window1.OnWindowDeselected := @RectWindowDeselected;
        Window2.OnWindowDeselected := @RectWindowDeselected;

        Image1.Canvas.Brush.Color := clWhite;
        Image1.Canvas.FillRect(Image1.ClientRect);
        DrawWindows;

      end;
    end;
  end;
end;


{******** УДАЛЕНИЕ ВЕРТИКАЛЬНОГО ИМПОСТА **********}
procedure TForm1.DeleteVerticalImpost(Sender: TObject);
var
  Window: TRectWindow;
  LeftWindow: TRectWindow;
  WindowIndex, Index, NewCol: integer;
begin
  // Находим индекс окна, которое нужно разделить
  WindowIndex := WindowContainer.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(WindowContainer.GetWindow(WindowIndex));
    if Assigned(Window) then
    begin
      // Проверяем высоту окна
      if (Window.GetXOtstup > 0) then
      begin
        for Index := 0 to WindowContainer.Count - 1 do
        begin
          LeftWindow := TRectWindow(WindowContainer.GetWindow(Index));
          if Assigned(Window) and (LeftWindow.GetXOtstup =
            (Window.GetXOtstup - LeftWindow.GetWidth)) and
            (LeftWindow.GetHeight = Window.GetHeight) then
          begin

            // Удаляем 1 окно из контейнера, а размеры второго изменяем
            LeftWindow.SetWidth(LeftWindow.GetWidth + Window.GetWidth);
            NewCol := UpdateIndexes(1, Window.GetRow, Window.GetColumn,
              Window.GetXOtstup);


            WindowContainer.RemoveWindow(WindowContainer.IndexOf(Window));


            UpdateTable;
            // Изменяем текст ширину окна

            RectWindowDeselected(Self);
            Image1.Canvas.Brush.Color := clWhite;
            Image1.Canvas.FillRect(Image1.ClientRect);
            ShowMessage('Размер массива' + IntToStr(WindowContainer.Count));
            DrawWindows;
            Break;

          end;
        end;
      end
      else
      begin
        // Если высота окна меньше 600, сообщаем об ошибке
        ShowMessage(
          'Возможно вы выбрали крайнее левое окно или же у окна присутствует горизонтальный импост');
      end;
    end;
  end;
end;


{******** УДАЛЕНИЕ ГОРИЗОНТАЛЬНОГО ИМПОСТА **********}
procedure TForm1.DeleteHorizontalImpost(Sender: TObject);
var
  Window: TRectWindow;
  UpWindow: TRectWindow;
  WindowIndex, Index, NewCol: integer;
begin
  // Находим индекс окна, которое нужно разделить
  WindowIndex := WindowContainer.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(WindowContainer.GetWindow(WindowIndex));
    if Assigned(Window) then
    begin
      // Проверяем высоту окна
      if (Window.GetYOtstup > 0) then
      begin
        for Index := 0 to WindowContainer.Count - 1 do
        begin
          UpWindow := TRectWindow(WindowContainer.GetWindow(Index));
          if Assigned(Window) and (UpWindow.GetYOtstup =
            (Window.GetYOtstup - UpWindow.GetHeight)) and
            (UpWindow.GetWidth = Window.GetWidth) then
          begin

            // Удаляем 1 окно из контейнера, а размеры второго изменяем
            UpWindow.SetHeight(UpWindow.GetHeight + Window.GetHeight);
            NewCol := UpdateIndexes(3, Window.GetRow, Window.GetColumn,
              Window.GetXOtstup);


            WindowContainer.RemoveWindow(WindowContainer.IndexOf(Window));

            UpdateTable;

            RectWindowDeselected(Self);
            Image1.Canvas.Brush.Color := clWhite;
            Image1.Canvas.FillRect(Image1.ClientRect);
            ShowMessage('Размер массива' + IntToStr(WindowContainer.Count));
            DrawWindows;
            Break;

          end;
        end;
      end
      else
      begin
        ShowMessage(
          'Возможно вы выбрали самое верхнее окно');
      end;
    end;
  end;
end;


{******** ОБНОВЛЕНИЕ ИНДЕКСОВ **********}
function TForm1.UpdateIndexes(OperationNum, NewRow, NewCol, NewOtstup: integer): integer;
var
  Window: TRectWindow;
  CountWin, RightWins, i: integer;
begin
  // Добавление вертикального импоста
  if (OperationNum = 0) then
  begin
    for i := 0 to WindowContainer.Count - 1 do
    begin
      Window := TRectWindow(WindowContainer.GetWindow(i));
      if ((Window.GetRow = NewRow) and (Window.GetColumn >= NewCol)) then
      begin
        Window.SetColumn(Window.GetColumn + 1);
        UpdateTable;
        // Добавляем текст из индекс окна
      end;
    end;
    Result := 0;
  end;
  // Удаление вертикального импоста
  if (OperationNum = 1) then
  begin
    for i := 0 to WindowContainer.Count - 1 do
    begin
      Window := TRectWindow(WindowContainer.GetWindow(i));
      if ((Window.GetRow = NewRow) and (Window.GetColumn > NewCol)) then
      begin
        Window.SetColumn(Window.GetColumn - 1);
        UpdateTable;
        // Добавляем текст из индекс окна
      end;
    end;
    Result := 0;
  end;
  // Добавление горизонтального импоста
  if (OperationNum = 2) then
  begin
    CountWin := 0;
    RightWins := 0;
    for i := 0 to WindowContainer.Count - 1 do
    begin
      Window := TRectWindow(WindowContainer.GetWindow(i));
      if (Window.GetRow = NewRow) then
      begin
        CountWin := CountWin + 1;
        if (Window.GetXOtstup >= NewOtstup) then
        begin
          Window.SetColumn(Window.GetColumn + 1);
          UpdateTable;
          // Добавляем текст из индекс окна
          RightWins := RightWins + 1;
        end;
      end;
    end;
    Result := CountWin - RightWins + 1;
  end;
  // Удаление горизонтального импоста
  if (OperationNum = 3) then
  begin
    for i := 0 to WindowContainer.Count - 1 do
    begin
      Window := TRectWindow(WindowContainer.GetWindow(i));
      if (Window.GetRow = NewRow) and (Window.GetColumn > NewCol) then
      begin
        Window.SetColumn(Window.GetColumn - 1);
        UpdateTable;
        // Добавляем текст из индекс окна
      end;
    end;
    Result := 0;
  end;
end;

{******** ОБРАБОТЧИК КЛИКОВ **********}
// Обработчик клика на изображении
procedure TForm1.CanvasClickHandler(Sender: TObject);
var
  ClickX, ClickY: integer;
  Window: TRectWindow;
  WindowIndex: integer;
begin

  ClickX := Mouse.CursorPos.X;
  ClickY := Mouse.CursorPos.Y;

  //получаем координаты клика
  ClickX := Image1.ScreenToClient(Point(ClickX, ClickY)).X;
  ClickY := Image1.ScreenToClient(Point(ClickX, ClickY)).Y;


  // Проверяем, принадлежит ли клик какому-либо окну в контейнере
  WindowIndex := WindowContainer.FindWindow(ClickX, ClickY);
  // Если клик попадает в окно
  if (WindowIndex >= 0) then
  begin
    // Получаем выбранное окно
    Window := TRectWindow(WindowContainer.GetWindow(WindowIndex));
    if (CheckSelectionWindows = False or Window.GetSelection = True) then
    begin
      // Устанавливаем новое выбранное окно
      // Вызываем обработчик события OnWindowSelected
      Window.Select(Self);
      Window.OnWindowSelected := @RectWindowSelected;
      Window.OnWindowDeselected := @RectWindowDeselected;
      if (WindowContainer.GetSelectedIndex <> WindowContainer.IndexOf(Window)) then
      begin
        DrawWindows;
      end;
    end;
  end;
end;

{******** ОТРИСОВКА ВСЕЙ КОНСТРУКЦИИ **********}
procedure TForm1.DrawWindows;
var
  MaxRow, MaxCol, i, row, col: integer;
  Window: TRectWindow;
begin
  MaxRow := -1;
  MaxCol := -1;
  for i := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(i));
    if (Window.GetRow > MaxRow) then
      MaxRow := Window.GetRow;
    if (Window.GetColumn > MaxCol) then
      MaxCol := Window.GetColumn;
  end;

  for row := 1 to MaxRow do
  begin
    for col := 1 to MaxCol do
    begin
      // Находим окно по индексу строки и столбца
      for i := 0 to WindowContainer.Count - 1 do
      begin
        Window := TRectWindow(WindowContainer.GetWindow(i));
        if (Window.GetRow = row) and (Window.GetColumn = col) then
        begin
          // Отрисовываем окно
          Window.SetZoomIndex(DrawingIndex);
          Window.DrawWindow;
          //Window.DrawImposts(FRectWidth, FRectHeight);
          // Прерываем внутренний цикл, чтобы не отображать одно окно несколько раз
          Break;
        end;
      end;
    end;
  end;
  PaintSizes;
end;

{******** ПРОВЕРКА ВЫДЕЛЕНИЯ ОКНА **********}
function TForm1.CheckSelectionWindows: boolean;
var
  i: integer;
  Window: TRectWindow;
begin
  Result := False; // Initialize the result to False

  for i := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(i));
    if Window.GetSelection then
      // Use the getter method to check if the window is selected
    begin
      Result := True; // Set the result to True if any window is selected
      {ShowMessage('Индекс выбранного окна ' +
        IntToStr(WindowContainer.IndexOf(Window)));
        }
      {ShowMessage('Индекс окна' + IntToStr(Window.GetRow) +
        '.' + IntToStr(Window.GetColumn)); }
      Exit; // Exit the loop since we found a selected window
    end;
  end;
end;

{******** ПРОВЕРКА ИЗМЕНЕНИЯ ВЫСОТЫ **********}
function TForm1.CheckHeightChange: boolean;
var
  Window: TRectWindow;
  Diff, I: integer;
begin
  for I := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(I));
    if (Window.GetYOtstup = 0) then
    begin
      Diff := StrToInt(Edit3.Text) - FRectHeight;
      if ((Window.GetHeight + Diff) <= 450) then
      begin
        Result := False;
        Exit;
      end
      else
        Result := True;
    end;
  end;
end;

{******** ПРОВЕРКА ИЗМЕНЕНИЯ ШИРИНЫ **********}
function TForm1.CheckWidthChange: boolean;
var
  Window: TRectWindow;
  Diff, I: integer;
begin
  for I := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(I));
    if (Window.GetXOtstup = 0) then
    begin
      Diff := StrToInt(Edit4.Text) - FRectWidth;
      if ((Window.GetWidth + Diff) <= 450) then
      begin
        Result := False;
        Exit;
      end
      else
        Result := True;
    end;
  end;
end;

{******** ОБНОВЛЕНИЕ ТАБЛИЦЫ **********}
procedure TForm1.UpdateTable;
var
  i, j: integer;
  TempString: string;
  WindowList: TStringList;
begin
  // Создаем список окон с их индексами
  WindowList := TStringList.Create;
  try
    for i := 0 to WindowContainer.Count - 1 do
    begin
      WindowList.Add(IntToStr(WindowContainer.GetWindow(i).GetRow) + '.' +
                     IntToStr(WindowContainer.GetWindow(i).GetColumn) + '|' + IntToStr(i));
    end;

    // Сортируем список окон
    WindowList.Sort;

    // Очищаем существующие строки
    StringGrid1.RowCount := 1;

    // Устанавливаем количество строк равное количеству окон
    StringGrid1.RowCount := WindowContainer.Count + 1;

    // Добавляем отсортированные окна в StringGrid
    for i := 0 to WindowList.Count - 1 do
    begin
      j := StrToInt(Copy(WindowList[i], Pos('|', WindowList[i]) + 1, Length(WindowList[i])));

      TempString := Copy(WindowList[i], 1, Pos('|', WindowList[i]) - 1);
      StringGrid1.Cells[0, i + 1] := TempString;
      StringGrid1.Cells[1, i + 1] := IntToStr(WindowContainer.GetWindow(j).GetHeight);
      StringGrid1.Cells[2, i + 1] := IntToStr(WindowContainer.GetWindow(j).GetWidth);
      StringGrid1.Cells[3, i + 1] := ComboBox1.Items[WindowContainer.GetWindow(j).GetType];
    end;
  finally
    WindowList.Free;
  end;
end;



end.
