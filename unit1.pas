unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, RectWindow;

type
  { TForm1 }
  TForm1 = class(TForm)
    Image1: TImage;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;
    Edit1: TEdit;

    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditChange(Sender: TObject);

  private
    { Private declarations }
    WidthEdit, HeightEdit: TEdit;
    OKButton: TButton; // Declare OKButton as a member of the class
    RectWindow: TRectWindow; // Создание экземпляра класса TRectWindow

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParams(AOwner: TComponent; RectW, RectH: Integer; Image2: TImage);
  end;

var
  Form1: TForm1;

implementation

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TForm1.CreateWithParams(AOwner: TComponent; RectW, RectH: Integer; Image2: TImage);
begin
  inherited Create(AOwner);
  RectWindow := TRectWindow.Create(RectW, RectH, Image2);
end;

{$R *.lfm}

{ TForm1 }



procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  WidthLabel, HeightLabel: TLabel;
  InputForm: TForm;
  RectWidth, RectHeight: Integer;
  NewRectWindow: TRectWindow;
begin
  if Assigned(Node) then
  begin
    // Создание формы для ввода данных
    InputForm := TForm.Create(nil);
    InputForm.Caption := 'Введите размеры окна';
    InputForm.Width := 300;
    InputForm.Height := 150;

    // Определение координат для размещения формы
    InputForm.Left := Node.DisplayRect(False).Right + 10; // Расположение справа от элемента списка
    InputForm.Top := Node.DisplayRect(False).Top; // Расположение на уровне элемента списка

    HeightEdit := TEdit.Create(InputForm);
    HeightEdit.Parent := InputForm;
    HeightEdit.Left := 10;
    HeightEdit.Top := 10;
    HeightEdit.Width := 100;
    HeightLabel := TLabel.Create(InputForm);
    HeightLabel.Parent := InputForm;
    HeightLabel.Caption := 'Высота (мм)';
    HeightLabel.Left := 120;
    HeightLabel.Top := 15;
    HeightEdit.OnKeyPress := @EditKeyPress; // Обработчик события нажатия клавиши
    HeightEdit.OnChange := @EditChange; // Обработчик события изменения значения

    // Создание компонентов на форме
    WidthEdit := TEdit.Create(InputForm);
    WidthEdit.Parent := InputForm;
    WidthEdit.Left := 10;
    WidthEdit.Top := 40;
    WidthEdit.Width := 100;
    WidthLabel := TLabel.Create(InputForm);
    WidthLabel.Parent := InputForm;
    WidthLabel.Caption := 'Ширина (мм)';
    WidthLabel.Left := 120;
    WidthLabel.Top := 45;

    WidthEdit.OnKeyPress := @EditKeyPress; // Обработчик события нажатия клавиши
    WidthEdit.OnChange := @EditChange; // Обработчик события изменения значения

    OKButton := TButton.Create(InputForm);
    OKButton.Parent := InputForm;
    OKButton.Left := 10;
    OKButton.Top := 70;
    OKButton.Caption := 'OK';
    OKButton.ModalResult := mrOk;
    OKButton.Enabled := False; // Изначально кнопка OK неактивна


    // Отображение формы и ожидание ввода данных
    if InputForm.ShowModal = mrOk then
    begin

      // Получение введенных значений
      RectWidth := StrToInt(WidthEdit.Text);
      RectHeight := StrToInt(HeightEdit.Text);

      NewRectWindow := TRectWindow.Create(RectHeight, RectWidth, Image1);
      NewRectWindow.DrawWindow;

      // Отрисовка прямоугольника на изображении
      NewRectWindow.DrawWindow;

    end;

    // Отключение события изменения значения для списка после закрытия окна
    Node.Selected := False;

    // Освобождение памяти, занятой экземпляром окна
    NewRectWindow.Free;

    // Освобождение памяти, занятой формой и компонентами
    InputForm.Free;
  end;
end;


procedure TForm1.EditKeyPress(Sender: TObject; var Key: Char);
begin
  // Allow only digits and control keys (e.g., backspace, delete)
  if not (Key in ['0'..'9', #8, #127]) then
    Key := #0; // Discard the key press event
end;

procedure TForm1.EditChange(Sender: TObject);
var
  WidthValue, HeightValue: Integer;
begin
  // Проверка на ввод корректных значений
  if TryStrToInt(WidthEdit.Text, WidthValue) and TryStrToInt(HeightEdit.Text, HeightValue) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (WidthValue >= 450) and (WidthValue <= 3500) and (HeightValue >= 450) and (HeightValue <= 2000) then
      OKButton.Enabled := True
    else
      OKButton.Enabled := False;
  end
  else
    OKButton.Enabled := False;
end;







end.

