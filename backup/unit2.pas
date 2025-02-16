unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls; // Добавлен StdCtrls

type

  { TForm2 }

  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure ButtonOkonnyBlockClick(Sender: TObject);
    procedure ButtonBalkonnayaDverClick(Sender: TObject);
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}
 uses
  Unit1; // Access Form1

procedure TForm2.FormCreate(Sender: TObject);
var
  ButtonOkonnyBlock, ButtonBalkonnayaDver: TButton;
begin
  // Create "Оконный блок" button
  ButtonOkonnyBlock := TButton.Create(Self);
  ButtonOkonnyBlock.Parent := Self;
  ButtonOkonnyBlock.Width := 200;
  ButtonOkonnyBlock.Caption := 'Оконный блок';
  ButtonOkonnyBlock.Left := 30;
  ButtonOkonnyBlock.Top := 20;
  ButtonOkonnyBlock.OnClick := @ButtonOkonnyBlockClick;

  // Create "Балконная дверь" button
  ButtonBalkonnayaDver := TButton.Create(Self);
  ButtonBalkonnayaDver.Parent := Self;
  ButtonBalkonnayaDver.Width := 200;
  ButtonBalkonnayaDver.Caption := 'Балконная дверь';
  ButtonBalkonnayaDver.Left := 30;
  ButtonBalkonnayaDver.Top := 70;
  ButtonBalkonnayaDver.OnClick := @ButtonBalkonnayaDverClick;
end;

procedure TForm2.ButtonOkonnyBlockClick(Sender: TObject);
begin
  // Действие для "Оконный блок"
  // Call the procedure from Form1
  Form1.CreateNewFullConstrWin(Self);

  Close; // Закрываем форму
end;

procedure TForm2.ButtonBalkonnayaDverClick(Sender: TObject);
begin
  // Действие для "Балконная дверь"
  ShowMessage('Вы выбрали "Балконная дверь". Выполняется соответствующее действие.');
  Close; // Закрываем форму
end;

end.
