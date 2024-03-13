unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, RectWindow, WindowContainer;

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
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;

    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure EditKeyPress(Sender: TObject; var Key: char);
    procedure EditChange(Sender: TObject);
    procedure RectWindowWindowSelected(Sender: TObject);



  private
    { Private declarations }
    RectWindow: TRectWindow;
    FRectHeight, FRectWidth: integer;
    WindowContainer: TWindowContainer; // Добавляем экземпляр WindowContainer


  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParams(AOwner: TComponent; RectW, RectH: integer;
      Image2: TImage);
  end;

var
  Form1: TForm1;

implementation

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WindowContainer := TWindowContainer.Create; // Создаем экземпляр WindowContainer
end;

constructor TForm1.CreateWithParams(AOwner: TComponent; RectW, RectH: integer;
  Image2: TImage);
begin
  inherited Create(AOwner);
  RectWindow := TRectWindow.Create(RectW, RectH, Image2);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  RectWidth, RectHeight: integer;
begin
  // Получение значений из Edit1 и Edit2
  RectWidth := StrToInt(Edit1.Text);
  RectHeight := StrToInt(Edit2.Text);

  FRectWidth := RectWidth;
  FRectHeight := RectHeight;
  // Инициализация окна
  RectWindow := TRectWindow.Create(RectHeight, RectWidth, Image1);
  WindowContainer.AddWindow(RectWindow);

  // Присоединяем обработчик события OnWindowSelected
  RectWindow.OnWindowSelected := @RectWindowWindowSelected;

  // Отрисовка окна на изображении
  RectWindow.DrawWindow;
  Image1.OnClick := @RectWindow.CanvasClickHandler;
end;


procedure TForm1.RectWindowWindowSelected(Sender: TObject);
begin
  Edit1.Text := IntToStr(FRectWidth);
  Edit2.Text := IntToStr(FRectHeight);
end;


procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(FRectWidth);
  Edit2.Text := IntToStr(FRectHeight);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.Enabled := False;
end;


procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin

  if Assigned(Node) then
  begin
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

    Edit2.OnKeyPress := @EditKeyPress;
    // Обработчик события нажатия клавиши
    Edit2.OnChange := @EditChange;
    // Обработчик события изменения значения


    // Отключение события изменения значения для списка после закрытия окна
    Node.Selected := False;

    if Assigned(RectWindow) then
    begin
      RectWindow.Free;
      RectWindow := nil;
    end;
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



end.
