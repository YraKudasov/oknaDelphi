unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, Menus, RectWindow, WindowContainer, LCLType;

type
  { TForm1 }
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;

    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure EditKeyPress(Sender: TObject; var Key: char);
    procedure EditChange(Sender: TObject);
    procedure RectWindowSelected(Sender: TObject);
    procedure RectWindowDeselected(Sender: TObject);
    procedure VerticalImpost(Sender: TObject);
    procedure CanvasClickHandler(Sender: TObject);
    procedure DrawWindows;
    function CheckSelectionWindows: Boolean;





  private
    { Private declarations }
    RectWindow: TRectWindow;
    FRectHeight, FRectWidth: integer;
    WindowContainer: TWindowContainer; // Добавляем экземпляр WindowContainer


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



procedure TForm1.BitBtn1Click(Sender: TObject);
var
  RectWidth, RectHeight: Integer;
begin

  WindowContainer := TWindowContainer.Create; // Создаем экземпляр WindowContainer

  // Получение значений из Edit1 и Edit2
  RectWidth := StrToInt(Edit1.Text);
  RectHeight := StrToInt(Edit2.Text);

  FRectWidth := RectWidth;
  FRectHeight := RectHeight;
  // Инициализация окна
  RectWindow := TRectWindow.Create(RectHeight, RectWidth, Image1, False, 0);
  WindowContainer.AddWindow(RectWindow);

  if WindowContainer.Count > 0 then
  begin
     ShowMessage('Экземпляр окна был добавлен в контейнер.' + IntToStr(WindowContainer.Count));
  end;
  if WindowContainer.Count = 0 then
  begin
     ShowMessage('Контейнер пустой');
  end;

  RectWindow.SetSize(TPoint.Create(RectHeight, RectWidth));

  // Отрисовка окна на изображении
  RectWindow.DrawWindow;

  Image1.OnClick := @CanvasClickHandler;


  // Присоединяем обработчик события OnWindowSelected

  RectWindowDeselected(Self);
  RectWindow.OnWindowSelected := @RectWindowSelected;
  RectWindow.OnWindowDeselected := @RectWindowDeselected;

  MenuItem3.OnClick := @RectWindow.AddHorizontalImpost;

end;


procedure TForm1.RectWindowSelected(Sender: TObject);
var
  Window: TRectWindow;
begin
  Window := TRectWindow(Sender);
  if Assigned(Window) then
  begin
    Edit1.Text := IntToStr(Window.GetHeight);
    Edit2.Text := IntToStr(Window.GetWidth);
    MenuItem2.Enabled := True;
    MenuItem3.Enabled := True;
  end;
end;

procedure TForm1.RectWindowDeselected(Sender: TObject);
begin
  Edit1.Text := '0';
  Edit2.Text := '0';
  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
end;


procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(FRectWidth);
  Edit2.Text := IntToStr(FRectHeight);
end;





procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.Enabled := False;
  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
end;





procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin

  if Assigned(Node) then
  begin
    MenuItem2.Enabled := False;
    Panel1.Enabled := True;
    Bitbtn1.Enabled := False;

    Image1.Canvas.Brush.Color := clWhite;
    Image1.Canvas.FillRect(Image1.ClientRect);

    // Сохраните старые значения
    FRectHeight := 0;
    FRectWidth := 0;

    Edit1.Text := IntToStr(FRectWidth);
    Edit2.Text := IntToStr(FRectHeight);

    Edit1.OnKeyPress := @EditKeyPress;
    // Обработчик события нажатия клавиши
    Edit1.OnChange := @EditChange;
    // Обработчик события изменения значения

    // Обработчик события нажатия клавиши
    Edit2.OnKeyPress := @EditKeyPress;
    // Обработчик события изменения значения
    Edit2.OnChange := @EditChange;



    // Отключение события изменения значения для списка после закрытия окна
    Node.Selected := False;

     // Сброс обработчика событий
    Image1.OnClick := nil;
  end;
end;



procedure TForm1.EditKeyPress(Sender: TObject; var Key: char);
begin
  // Allow only digits and control keys (e.g., backspace, delete)
  if not (Key in ['0'..'9', #8, #127]) then
    Key := #0; // Discard the key press event
end;

procedure TForm1.EditChange(Sender: TObject);
var
  WidthValue, HeightValue: integer;
begin
  // Проверка на ввод корректных значений
  if TryStrToInt(Edit1.Text, WidthValue) and TryStrToInt(Edit2.Text, HeightValue) then
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


procedure TForm1.VerticalImpost(Sender: TObject);
var
  WindowIndex, Otstup: Integer;
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

      Otstup := Window.GetOtstup;

      // Разделяем окно на два новых экземпляра
      Window1 := TRectWindow.Create(Window.GetSize.X, Window.GetSize.Y div 2, Image1, False, Otstup);
      Window2 := TRectWindow.Create(Window.GetSize.X, Window.GetSize.Y div 2, Image1, True, Otstup + Window.GetSize.Y div 2);


      // Удаляем исходное окно из контейнера
      WindowContainer.RemoveWindow(WindowIndex);

      // Добавляем два новых окна в контейнер
      WindowContainer.AddWindow(Window1);
      WindowContainer.AddWindow(Window2);

        if WindowContainer.Count > 0 then
  begin
     ShowMessage('Экземпляр окна был добавлен в контейнер.' + IntToStr(WindowContainer.Count));
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


      // Перерисовываем окна
      Window1.DrawWindow;
      Window2.DrawWindow;

    end;
  end;
end;

// Обработчик клика на изображении
procedure TForm1.CanvasClickHandler(Sender: TObject);
var
ClickX, ClickY: Integer;
Window: TRectWindow;
WindowIndex: Integer;
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
DrawWindows;
 end;
end;
end;

procedure TForm1.DrawWindows;
var
i: Integer;
Window: TRectWindow;
begin
     for i := 0 to WindowContainer.Count - 1 do
 begin
   Window := TRectWindow(WindowContainer.GetWindow(i));
   Window.DrawWindow;
 end;
end;

function TForm1.CheckSelectionWindows: Boolean;
var
  i: Integer;
  Window: TRectWindow;
begin
  Result := False; // Initialize the result to False

  for i := 0 to WindowContainer.Count - 1 do
  begin
    Window := TRectWindow(WindowContainer.GetWindow(i));
    if Window.GetSelection then // Use the getter method to check if the window is selected
    begin
      Result := True; // Set the result to True if any window is selected
      Exit; // Exit the loop since we found a selected window
    end;
  end;
end;

end.
