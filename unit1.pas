unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, Menus, RectWindow, WindowContainer, Unit2,
  PlasticDoorImpost, ImpostsContainer, FullContainer,
  LCLType, Grids, ActnList, Generics.Collections;

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
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;



    procedure AlignWidth(Sender: TObject);
    procedure AlignForSun(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure DrawFullConstruction(Sender: TObject);
    procedure DeleteConstr(Sender: TObject);
    procedure ChooseTypeOfNewConstr(Sender: TObject);
    procedure ChooseTypeOfAddingConstr(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure CreateNewFullConstr(Sender: TObject; IsPlasticDoor: boolean);
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
    function DrawingFullConstrIndex: double;
    function ChooseProfileOtstup(Row, Col: integer): integer;
    procedure ResetAllWindowSelections;




  private
    { Private declarations }
    RectWindow: TRectWindow;
    FRectHeight, FRectWidth: integer;
    WindowContainer: TWindowContainer;
    FullContainer: TFullContainer;
    CurrentContainer: integer;
    FullConstrHeight: integer;
    FullConstrWidth: integer;
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
  DiffXOtstup, I, DiffX, DiffY, maxHeight: integer;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
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
      if (CurrCont.GetWindow(0).GetForm = 1) then
      begin
        if (StrToInt(Edit3.Text) <> StrToInt(Edit4.Text)) then
        begin
          if (StrToInt(Edit3.Text) > StrToInt(Edit4.Text)) then
          begin
            Edit4.Text := Edit3.Text;
          end
          else
            Edit3.Text := Edit4.Text;
        end;
        CurrCont.GetWindow(0).SetHeight(StrToInt(Edit3.Text));
        CurrCont.GetWindow(0).SetWidth(StrToInt(Edit4.Text));
      end
      else
      begin
        if (StrToInt(Edit3.Text) > FullConstrHeight) then
        begin
          FullConstrHeight := StrToInt(Edit3.Text);
          ShowMessage('Высота всего изделия увеличена!');
        end;
        if ((CurrCont.GetConstrHeight = FullConstrHeight) and
          (StrToInt(Edit3.Text) < FullConstrHeight)) then
        begin
          maxHeight := 0;
          CurrCont.SetConstrHeight(CurrCont.GetConstrHeight - StrToInt(Edit3.Text));
          for I := 0 to FullContainer.Count - 1 do
          begin
            if (FullContainer.GetContainer(I).GetConstrHeight > maxHeight) then
              maxHeight := FullContainer.GetContainer(I).GetConstrHeight;
          end;
          FullConstrHeight := maxHeight;
          ShowMessage('Высота всего изделия могла быть уменьшена!');
        end;
        if ((StrToInt(Edit4.Text) <> CurrCont.GetConstrWidth) and
          (FullContainer.Count > 1)) then
        begin
          DiffXOtstup := StrToInt(Edit4.Text) - CurrCont.GetConstrWidth;
          for I := FullContainer.IndexOfContainer(CurrCont) +
            1 to FullContainer.Count - 1 do
          begin
            FullContainer.GetContainer(I).SetCommonXOtstup(
              FullContainer.GetContainer(I).GetCommonXOtstup + DiffXOtstup);
          end;
          FullConstrWidth := FullConstrWidth + DiffXOtstup;
        end;
        if ((StrToInt(Edit4.Text) <> CurrCont.GetConstrWidth) and
          (FullContainer.Count = 1)) then
        begin
          DiffXOtstup := StrToInt(Edit4.Text) - CurrCont.GetConstrWidth;
          FullConstrWidth := FullConstrWidth + DiffXOtstup;
        end;
        for I := 0 to CurrCont.Count - 1 do
        begin
          Window := TRectWindow(CurrCont.GetWindow(I));
          DiffY := StrToInt(Edit3.Text) - FRectHeight;
          DiffX := StrToInt(Edit4.Text) - FRectWidth;
          if (Window.GetYOtstup = 0) then
          begin
            Window.SetHeight(Window.GetHeight + DiffY);
          end
          else
          begin
            Window.SetYOtstup(Window.GetYOtstup + DiffY);
          end;
          if (Window.GetXOtstup = 0) then
          begin
            Window.SetWidth(Window.GetWidth + DiffX);
          end
          else
          begin
            Window.SetXOtstup(Window.GetXOtstup + DiffX);
          end;
        end;
      end;
    end;
    FRectHeight := StrToInt(Edit3.Text);
    FRectWidth := StrToInt(Edit4.Text);
    CurrCont.SetConstrWidth(FRectWidth);
    CurrCont.SetConstrHeight(FRectHeight);
    Edit1.Text := '0';
    Edit2.Text := '0';
    Panel1.Enabled := False;
    Panel3.Visible := False;
  end;
  ResetAllWindowSelections;
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
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  for i := 0 to CurrCont.Count - 1 do
  begin
    Window := TRectWindow(CurrCont.GetWindow(i));
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
            for a := 0 to CurrCont.Count - 1 do
            begin
              NearWindow := TRectWindow(CurrCont.GetWindow(a));

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
                ChangedWindow := TRectWindow(CurrCont.GetWindow(ind));
                ChangedWindow.SetHeight(ChangedWindow.GetHeight + DiffY);
                ChangedWindow.SetYOtstup(ChangedWindow.GetYOtstup - DiffY);

              end;
            end
            else if (WidthUp = Window.GetWidth) then
            begin
              Window.SetHeight(Window.GetHeight - DiffY);
              Window.SetYOtstup(Window.GetYOtstup + DiffY);

              for a := 0 to WUpCont.Count - 1 do
              begin
                ind := integer(WUpCont.Items[a]);
                ChangedWindow := TRectWindow(CurrCont.GetWindow(ind));
                ChangedWindow.SetHeight(ChangedWindow.GetHeight + DiffY);

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
            for a := 0 to CurrCont.Count - 1 do
            begin
              NearWindow := TRectWindow(CurrCont.GetWindow(a));

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

              for a := 0 to HRightCont.Count - 1 do
              begin
                ind := integer(HRightCont.Items[a]);
                ChangedWindow := TRectWindow(CurrCont.GetWindow(ind));
                ChangedWindow.SetWidth(ChangedWindow.GetWidth + DiffX);
                ChangedWindow.SetXOtstup(ChangedWindow.GetXOtstup - DiffX);
              end;
            end
            else if (HeightLeft = Window.GetHeight) then
            begin
              Window.SetWidth(Window.GetWidth - DiffX);
              Window.SetXOtstup(Window.GetXOtstup + DiffX);

              for a := 0 to HLeftCont.Count - 1 do
              begin
                ind := integer(HLeftCont.Items[a]);
                ChangedWindow := TRectWindow(CurrCont.GetWindow(ind));
                ChangedWindow.SetWidth(ChangedWindow.GetWidth + DiffX);

              end;
            end
            else
              ShowMessage(
                'ШИРИНУ окна НЕ удалось изменить. Возможно размеры СОСЕДНИХ окон становятся МЕНЬШЕ минимально допустимых при изменении размеров данного.');
          end;
        end;
        Window.Select(Self);
        ResetAllWindowSelections;
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
  CurrCont: TWindowContainer;
  Window: TRectWindow;
  ImpostsContainer: TImpostsContainer;
  j: integer;
begin
  Window := TRectWindow(Sender);
  if Assigned(Window) then
  begin
    Panel1.Enabled := True;
    Panel3.Enabled := True;
    Edit1.Text := IntToStr(Window.GetHeight);
    Edit2.Text := IntToStr(Window.GetWidth);
    MenuItem2.Enabled := True;
    MenuItem2.Visible := True;
    MenuItem3.Enabled := True;
    MenuItem5.Enabled := True;
    MenuItem5.Visible := True;
    MenuItem6.Enabled := True;
    ComboBox1.Enabled := True;
    ComboBox1.Visible := True;
    Label7.Visible := True;
    Panel3.Visible := True;
    Label11.Visible := True;
    ComboBox4.Visible := True;
    ComboBox1.ItemIndex := Window.GetType;
    ComboBox4.ItemIndex := Window.GetForm;
    if (Window.GetType <> 0) then
    begin
      CheckBox1.Visible := True;
      CheckBox1.Checked := Window.GetMoskit;
      Label8.Visible := True;
    end
    else
    begin
      CheckBox1.Visible := False;
      Label8.Visible := False;
    end;
  end;
  if (Window.GetIsDoor = True) then
  begin
    MenuItem2.Visible := False;
    MenuItem5.Visible := False;
    CheckBox1.Visible := False;
    Label11.Visible := False;
    ComboBox4.Visible := False;
    Label8.Visible := False;
    ComboBox2.Clear;
    ImpostsContainer := Window.GetImpostsContainer;
    if (ImpostsContainer.Count > 0) then
    begin
      for j := 0 to ImpostsContainer.Count - 1 do
      begin
        // Добавляем каждый импост в ComboBox2
        ComboBox2.Items.Add(Format('Импост : %d мм',
          [ImpostsContainer.GetImpost(j).GetFImpYOtstup]));
      end;
    end;
  end
  else if (Window.GetIsDoor = False) then
  begin
    ComboBox1.Items[0] := 'Глухая';
    ComboBox1.Items[3] := 'Откидная';
    ComboBox2.Visible := False;
    Label9.Visible := False;
  end;
  if (Window.GetForm = 1) then
  begin
    MenuItem2.Enabled := False;
    MenuItem5.Enabled := False;
    ComboBox1.Visible := False;
    Label7.Visible := False;
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
  Panel3.Visible := False;
  ComboBox1.Enabled := False;
  CheckBox1.Visible := False;
  Label8.Visible := False;

end;


{******** ИЗМЕНЕНИЕ ТИПА ОКНА **********}
procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i: integer;
  Window, NearWin: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  if (FRectHeight <> 0) and (FRectWidth <> 0) then
  begin
    Window := TRectWindow(CurrCont.GetWindow(CurrCont.GetSelectedIndex));
    if Assigned(Window) then
    begin
      Window.SetType(ComboBox1.ItemIndex);

      if ((ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2)) then
      begin
        for i := 0 to CurrCont.Count - 1 do
        begin
          NearWin := CurrCont.GetWindow(i);
          if ((NearWin.GetXOtstup + NearWin.GetWidth = Window.GetXOtstup) and
            ((NearWin.GetType = 4) or (NearWin.GetType = 5)) and
            (((Window.GetYOtstup <= NearWin.GetYOtstup) and
            (Window.GetYOtstup + Window.GetWidth > NearWin.GetYOtstup)) or
            ((NearWin.GetYOtstup < Window.GetYOtstup) and
            (NearWin.GetYOtstup + NearWin.GetWidth > Window.GetYOtstup)))) then
          begin
            Window.SetType(0);
            ComboBox1.ItemIndex := 0;
            ShowMessage(
              'Предупреждение: Невозможно установить данный тип открывания, так как окно слева уже имеет крепежи на данном импосте.');
            Break;
          end;
        end;
      end;
      if ((ComboBox1.ItemIndex = 4) or (ComboBox1.ItemIndex = 5)) then
      begin
        for i := 0 to CurrCont.Count - 1 do
        begin
          NearWin := CurrCont.GetWindow(i);
          if ((Window.GetXOtstup + Window.GetWidth = NearWin.GetXOtstup) and
            ((NearWin.GetType = 1) or (NearWin.GetType = 2)) and
            (((Window.GetYOtstup <= NearWin.GetYOtstup) and
            (Window.GetYOtstup + Window.GetWidth > NearWin.GetYOtstup)) or
            ((NearWin.GetYOtstup < Window.GetYOtstup) and
            (NearWin.GetYOtstup + NearWin.GetWidth > Window.GetYOtstup)))) then
          begin
            Window.SetType(0);
            ComboBox1.ItemIndex := 0;
            ShowMessage(
              'Предупреждение: Невозможно установить данный тип открывания, так как окно справа уже имеет крепежи на данном импосте.');
            Break;
          end;
        end;
      end;

      if (ComboBox1.ItemIndex <> 0) then
      begin
        CheckBox1.Visible := True;
        CheckBox1.Checked := Window.GetMoskit;
        Label8.Visible := True;
      end
      else
      begin
        CheckBox1.Visible := False;
        Label8.Visible := False;
        Window.SetMoskit(False);
      end;
      if (Window.GetIsDoor = True) then
      begin
        if (ComboBox1.ItemIndex = 0) or (ComboBox1.ItemIndex = 3) then
        begin
          ShowMessage('Этот элемент недоступен.');
          ComboBox1.ItemIndex := 1; // Сбрасываем выбор
          Window.SetType(1);
        end;
        CheckBox1.Visible := False;
        Label8.Visible := False;
      end;
      Window.SetZoomIndex(DrawingIndex);
      Window.DrawWindow;
    end;
  end;
end;



{******** ПОДСЧЕТ ИНДЕКСА ОТРИСОВКИ **********}
function TForm1.DrawingIndex: double;
var
  DIndex: double;
begin
  if ((FrectHeight < 1300) and (FRectWidth < 1895)) then
    DIndex := 0.24
  else if ((FrectHeight < 1800) and (FRectWidth < 2625)) then
    DIndex := 0.17
  else if ((FrectHeight < 2101) and (FRectWidth < 3062)) then
    DIndex := 0.15
  else if ((FrectHeight >= 2101) or (FRectWidth >= 3062)) then
    DIndex := 0.13;
  Result := DIndex;
end;

function TForm1.DrawingFullConstrIndex: double;
var
  DIndex: double;
begin
  if ((FullConstrWidth < 9000)) then
    DIndex := 0.10;
  Result := DIndex;
end;

{******** ИЗМЕНЕНИЕ НАЛИЧИЯ МОСКИТНОЙ СЕТКИ **********}
procedure TForm1.CheckBox1Change(Sender: TObject);
var
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  if (FRectHeight <> 0) and (FRectWidth <> 0) then
  begin
    Window := TRectWindow(CurrCont.GetWindow(CurrCont.GetSelectedIndex));
    if Assigned(Window) then
    begin
      if (CheckBox1.Checked) then
      begin
        Window.SetMoskit(True);

        Window.SetZoomIndex(DrawingIndex);
        Window.DrawWindow;
      end
      else
      begin
        Window.SetMoskit(False);

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
var
  Window: TRectWindow;
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
  Width := Round(Screen.Width);
  Height := Round(Screen.Height);
  WindowState := wsMaximized;
  Left := 0;
  // Устанавливаем положение формы в левый верхний угол
  Top := 0;
  // Устанавливаем положение формы в верхний угол
  // Настройка панелей и элементов управления
  Panel1.Enabled := False;
  Panel2.Enabled := False;
  Panel3.Visible := False;
  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
  MenuItem5.Enabled := False;
  MenuItem6.Enabled := False;
  CheckBox1.Visible := False;
  Label8.Visible := False;
  Button2.Visible := False;
  Button3.Visible := False;
  Combobox3.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;

end;



{******** ОТРИСОВКА СТАРТОВОЙ КОНСТРУКЦИИ **********}
procedure TForm1.CreateNewFullConstr(Sender: TObject; IsPlasticDoor: boolean);
var
  RectWidth, RectHeight: integer;
begin

  MenuItem2.Enabled := False;
  MenuItem3.Enabled := False;
  MenuItem5.Enabled := False;
  MenuItem6.Enabled := False;
  Panel2.Enabled := True;
  Panel3.Enabled := True;
  Bitbtn3.Enabled := False;

  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Image1.ClientRect);


  ComboBox1.Enabled := False;
  ComboBox1.ItemIndex := 0;
  CheckBox1.Visible := False;
  Label8.Visible := False;
  Button2.Visible := True;
  Button3.Visible := True;

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
  Combobox3.Enabled := True;

  WindowContainer := TWindowContainer.Create;
  FullContainer.AddContainer(WindowContainer);
  CurrentContainer := FullContainer.IndexOfContainer(WindowContainer);
  // Добавляем новый элемент в ComboBox3
  ComboBox3.Items.Add('WindowContainer ' + IntToStr(FullContainer.Count));

  // Делаем добавленный элемент текущим выбранным
  ComboBox3.ItemIndex := ComboBox3.Items.Count - 1;
  Button4.Enabled := True;
  Button5.Enabled := True;
  Button6.Enabled := True;

  if (isPlasticDoor = False) then
  begin

    if ((FullConstrHeight < 1000)) then
      FullConstrHeight := 1000;

    WindowContainer.SetCommonXOtstup(FullConstrWidth);
    FullConstrWidth := FullConstrWidth + 1000;

    Edit3.Text := IntToStr(FullConstrHeight);
    Edit4.Text := IntToStr(1000);

    // Получение значений из Edit3 и Edit4
    RectHeight := StrToInt(Edit3.Text);
    RectWidth := StrToInt(Edit4.Text);

    FRectWidth := RectWidth;
    FRectHeight := RectHeight;
    WindowContainer.SetConstrWidth(FRectWidth);
    WindowContainer.SetConstrHeight(FRectHeight);

    ComboBox1.Items[0] := 'Глухая';
    ComboBox1.Items[3] := 'Откидная';
    ComboBox2.Visible := False;
    Label9.Visible := False;


    RectWindow := TRectWindow.Create(1, 1, RectHeight, RectWidth,
      Image1, 0, 0, ComboBox1.ItemIndex, 0, False);
    RectWindow.SetIsDoor(False);
  end


  else if (isPlasticDoor = True) then
  begin
    if (FullConstrHeight < 2100) then
      FullConstrHeight := 2100;

    WindowContainer.SetCommonXOtstup(FullConstrWidth);
    FullConstrWidth := FullConstrWidth + 600;

    Edit3.Text := IntToStr(FullConstrHeight);
    Edit4.Text := IntToStr(600);

    // Получение значений из Edit3 и Edit4
    RectHeight := StrToInt(Edit3.Text);
    RectWidth := StrToInt(Edit4.Text);

    FRectWidth := RectWidth;
    FRectHeight := RectHeight;
    WindowContainer.SetConstrWidth(FRectWidth);
    WindowContainer.SetConstrHeight(FRectHeight);

    ComboBox1.Items[0] := '(недоступно)';
    ComboBox1.Items[3] := '(недоступно)';
    ComboBox2.Visible := True;
    Label9.Visible := True;
    ComboBox2.Clear;
    // Инициализация окна
    RectWindow := TRectWindow.Create(1, 1, RectHeight, RectWidth,
      Image1, 0, 0, 1, 0, False);
    RectWindow.SetIsDoor(True);
  end;

  WindowContainer.AddWindow(RectWindow);



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




procedure TForm1.ChooseTypeOfNewConstr(Sender: TObject);
begin
  // Проверяем, существует ли уже FullContainer
  if Assigned(FullContainer) then
  begin
    // Если существует, освобождаем память
    FullContainer.Free;
    FullContainer := nil;
    // Обнуляем ссылку для безопасности
    Combobox3.Clear;
    FullConstrHeight := 0;
    FullConstrWidth := 0;
  end;

  // Создаем новый экземпляр FullContainer
  FullContainer := TFullContainer.Create;

  // Открываем Form2 как модальное окно
  Form2 := TForm2.Create(Self); // Создаем экземпляр Form2
  try
    Form2.ShowModal; // Показываем Form2
  finally
    Form2.Free; // Освобождаем память после закрытия Form2
  end;

  Image2.Canvas.Brush.Color := clWhite;
  Image2.Canvas.FillRect(Image2.ClientRect);
end;


procedure TForm1.ChooseTypeOfAddingConstr(Sender: TObject);
begin
  if (FullContainer.GetContainer(CurrentContainer).GetWindow(0).GetForm = 1) then
    ShowMessage(
      'В изделии с КРУГЛЫМ окном не может быть больше одной конструкции')
  else
  begin
    // Открываем Form2 как модальное окно
    Form2 := TForm2.Create(Self); // Создаем экземпляр Form2
    try
      Form2.ShowModal; // Показываем Form2
    finally
      Form2.Free; // Освобождаем память после закрытия Form2
    end;

  end;
end;

procedure TForm1.DeleteConstr(Sender: TObject);
var
  SelectedIndex: integer;
  i, maxHeight: integer;
  CurrCont: TWindowContainer;
  CurrWin: TRectWindow;
begin
  // Get the selected index from ComboBox3
  SelectedIndex := ComboBox3.ItemIndex;

  // Check if an item is selected
  if SelectedIndex <> -1 then
  begin
    // Check if only one construction is left
    if FullContainer.Count = 1 then
    begin
      ShowMessage('Невозможно удалить последнюю конструкцию');
      Exit;
    end;
    CurrCont := FullContainer.GetContainer(SelectedIndex);
    if (CurrCont.GetConstrHeight = FullConstrHeight) then
    begin
      maxHeight := 0;
      for I := 0 to FullContainer.Count - 1 do
      begin
        if ((FullContainer.GetContainer(I).GetConstrHeight > maxHeight) and
          (I <> SelectedIndex)) then
          maxHeight := FullContainer.GetContainer(I).GetConstrHeight;
      end;
      FullConstrHeight := maxHeight;
      ShowMessage('Высота всего изделия могла быть уменьшена!');
    end;
    if ((FullContainer.Count > 1) and (FullContainer.IndexOfContainer(CurrCont) <>
      FullContainer.Count - 1)) then
    begin
      for I := FullContainer.IndexOfContainer(CurrCont) +
        1 to FullContainer.Count - 1 do
      begin
        FullContainer.GetContainer(I).SetCommonXOtstup(
          FullContainer.GetContainer(I).GetCommonXOtstup - CurrCont.GetConstrWidth);
      end;
    end;
    FullConstrWidth := FullConstrWidth - CurrCont.GetConstrWidth;
    // Remove the container from FullContainer
    FullContainer.RemoveContainer(SelectedIndex);

    // Clear and repopulate ComboBox3
    ComboBox3.Clear;
    for i := 0 to FullContainer.Count - 1 do
    begin
      ComboBox3.Items.Add('WindowContainer ' + IntToStr(i + 1));
      // Update the items with new indices
    end;

    // Reset the selected index to the last item or -1 if there are no items left
    if ComboBox3.Items.Count > 0 then
      ComboBox3.ItemIndex := ComboBox3.Items.Count - 1
    else
      ComboBox3.ItemIndex := -1;
  end
  else
  begin
    ShowMessage('Выберите конструкцию для удаления');
    // Inform the user if nothing is selected
  end;

  // Clear the canvas
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Image1.ClientRect);

  // Update the UI if there are remaining items
  if (ComboBox3.ItemIndex >= 0) then
  begin
    CurrentContainer := ComboBox3.ItemIndex;
    CurrCont := FullContainer.GetContainer(CurrentContainer);
    FRectHeight := CurrCont.GetConstrHeight;
    FRectWidth := CurrCont.GetConstrWidth;
    Edit3.Text := IntToStr(CurrCont.GetConstrHeight);
    Edit4.Text := IntToStr(CurrCont.GetConstrWidth);
    Panel1.Enabled := False;
    Panel3.Enabled := False;
    if (CurrCont.GetWindow(0).GetIsDoor) then
    begin
      ComboBox1.Items[0] := '(недоступно)';
      ComboBox1.Items[3] := '(недоступно)';
    end;

    if Assigned(CurrCont) and (CurrCont.Count > 0) then
    begin
      for i := 0 to CurrCont.Count - 1 do
      begin
        CurrWin := CurrCont.GetWindow(i);
        CurrWin.OnWindowSelected := @RectWindowSelected;
        CurrWin.OnWindowDeselected := @RectWindowDeselected;
      end;
    end;
    ResetAllWindowSelections;
    DrawWindows;
  end;

  // Reset additional UI elements
  Edit1.Text := '0';
  Edit2.Text := '0';
  Panel3.Visible := False;
end;

procedure TForm1.DrawFullConstruction(Sender: TObject);
var
  i, j, k: integer;
  CurrCont: TWindowContainer;
  CurrWin: TRectWindow;
begin
  ResetAllWindowSelections;
  Image2.Canvas.Brush.Color := clWhite;
  Image2.Canvas.FillRect(Image2.ClientRect);
  for i := 0 to FullContainer.Count - 1 do
  begin
    CurrCont := FullContainer.GetContainer(i);
    for j := 0 to CurrCont.Count - 1 do
    begin
      CurrWin := CurrCont.GetWindow(j);
      CurrWin.SetImage(Image2);
      CurrWin.SetXOtstup(CurrWin.GetXOtstup + CurrCont.GetCommonXOtstup);
      CurrWin.SetZoomIndex(DrawingFullConstrIndex);
      if (CurrWin.GetIsDoor) then
      begin
        for k := 0 to CurrWin.GetImpostsContainer.Count - 1 do
        begin
          CurrWin.GetImpostsContainer.GetImpost(k).SetImage(Image2);
        end;
      end;
      CurrWin.DrawWindow;
    end;
  end;

  for i := 0 to FullContainer.Count - 1 do
  begin
    CurrCont := FullContainer.GetContainer(i);
    for j := 0 to CurrCont.Count - 1 do
    begin
      CurrWin := CurrCont.GetWindow(j);
      CurrWin.SetImage(Image1);
      CurrWin.SetXOtstup(CurrWin.GetXOtstup - CurrCont.GetCommonXOtstup);
      CurrWin.SetZoomIndex(DrawingIndex);
      if (CurrWin.GetIsDoor) then
      begin
        for k := 0 to CurrWin.GetImpostsContainer.Count - 1 do
        begin
          CurrWin.GetImpostsContainer.GetImpost(k).SetImage(Image1);
        end;
      end;
    end;
  end;
  ComboBox3Change(Self);
end;

procedure TForm1.AlignWidth(Sender: TObject);
var
  CurrIndexes, UsedIndexes: array of array of integer;
  i, t, j, k, l: integer;
  CurrCont: TWindowContainer;
  CountWin, SumWidth, WidthOfWin, Ostatok, OldWidth, DiffOtstup: integer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  SetLength(CurrIndexes, CurrCont.GetMaxRow + 1, CurrCont.GetMaxColumn + 1);
  SetLength(UsedIndexes, CurrCont.GetMaxRow + 1, CurrCont.GetMaxColumn + 1);
  for i := 1 to CurrCont.GetMaxRow do
  begin
    for t := 1 to CurrCont.GetMaxColumn do
    begin
      UsedIndexes[i][t] := -1;
    end;
  end;
  for i := 1 to CurrCont.GetMaxRow do
  begin
    for t := 1 to CurrCont.GetMaxColumn do
    begin

      for l := 1 to CurrCont.GetMaxRow do
      begin
        for k := 1 to CurrCont.GetMaxColumn do
        begin
          CurrIndexes[l][k] := -1;
        end;
      end;

      if ((UsedIndexes[i][t] = -1) and (CurrCont.GetIndexRowColumn(i, t) <> -1)) then
      begin
        CountWin := 1;
        CurrIndexes[i][t] := i;
        UsedIndexes[i][t] := i;
        SumWidth := CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetWidth;

        for j := 1 to CurrCont.GetMaxRow do
        begin
          for k := 1 to CurrCont.GetMaxColumn do
          begin
            if (CurrCont.GetIndexRowColumn(j, k) <> -1) then
            begin
              if ((CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetHeight =
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetHeight) and
                (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetYOtstup =
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetYOtstup) and
                (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetXOtstup =
                SumWidth) and (UsedIndexes[j][k] = -1)) then
              begin
                CountWin := CountWin + 1;
                CurrIndexes[j][k] := j;
                UsedIndexes[j][k] := j;
                SumWidth := SumWidth + CurrCont.GetWindow(
                  CurrCont.GetIndexRowColumn(j, k)).GetWidth;
              end;
            end;
          end;
        end;
        if ((SumWidth <> CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetWidth))
        then
        begin
          WidthOfWin := SumWidth div CountWin;
          Ostatok := SumWidth mod CountWin;
          DiffOtstup := 0;
          for l := 1 to CurrCont.GetMaxRow do
          begin
            for k := 1 to CurrCont.GetMaxColumn do
            begin
              if (CurrIndexes[l][k] <> -1) then
              begin
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetXOtstup(
                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).GetXOtstup +
                  DiffOtstup);
                OldWidth := CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l,
                  k)).GetWidth;

                if (Ostatok > 0) then
                begin
                  Ostatok := Ostatok - 1;
                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetWidth(
                    WidthOfWin + 1);
                  DiffOtstup := DiffOtstup + WidthOfWin - OldWidth + 1;
                end
                else
                begin
                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetWidth(
                    WidthOfWin);
                  DiffOtstup := DiffOtstup + WidthOfWin - OldWidth;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  ResetAllWindowSelections;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Image1.ClientRect);
  DrawWindows;
end;


procedure TForm1.AlignForSun(Sender: TObject);
var
  CurrIndexes, UsedIndexes: array of array of integer;
  i, t, j, k, l: integer;
  CurrCont: TWindowContainer;
  CountWin, SumWidth, WidthOfGlass, Ostatok, OldWidth, DiffOtstup, ProfilOtstup: integer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  SetLength(CurrIndexes, CurrCont.GetMaxRow + 1, CurrCont.GetMaxColumn + 1);
  SetLength(UsedIndexes, CurrCont.GetMaxRow + 1, CurrCont.GetMaxColumn + 1);
  for i := 1 to CurrCont.GetMaxRow do
  begin
    for t := 1 to CurrCont.GetMaxColumn do
    begin
      UsedIndexes[i][t] := -1;
    end;
  end;
  for i := 1 to CurrCont.GetMaxRow do
  begin
    for t := 1 to CurrCont.GetMaxColumn do
    begin

      for l := 1 to CurrCont.GetMaxRow do
      begin
        for k := 1 to CurrCont.GetMaxColumn do
        begin
          CurrIndexes[l][k] := -1;
        end;
      end;

      if ((UsedIndexes[i][t] = -1) and (CurrCont.GetIndexRowColumn(i, t) <> -1)) then
      begin
        CountWin := 1;
        CurrIndexes[i][t] := i;
        UsedIndexes[i][t] := i;
        SumWidth := CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetWidth;

        for j := 1 to CurrCont.GetMaxRow do
        begin
          for k := 1 to CurrCont.GetMaxColumn do
          begin
            if (CurrCont.GetIndexRowColumn(j, k) <> -1) then
            begin
              if ((CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetHeight =
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetHeight) and
                (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetYOtstup =
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetYOtstup) and
                (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(j, k)).GetXOtstup =
                SumWidth) and (UsedIndexes[j][k] = -1)) then
              begin
                CountWin := CountWin + 1;
                CurrIndexes[j][k] := j;
                UsedIndexes[j][k] := j;
                SumWidth := SumWidth + CurrCont.GetWindow(
                  CurrCont.GetIndexRowColumn(j, k)).GetWidth;
              end;
            end;
          end;
        end;


        if ((SumWidth <> CurrCont.GetWindow(CurrCont.GetIndexRowColumn(i, t)).GetWidth))
        then
        begin
          for l := 1 to CurrCont.GetMaxRow do
          begin
            for k := 1 to CurrCont.GetMaxColumn do
            begin
              if (CurrIndexes[l][k] <> -1) then
              begin
                ProfilOtstup := ChooseProfileOtstup(l, k);
                SumWidth := SumWidth - ProfilOtstup;
              end;
            end;
          end;


          WidthOfGlass := SumWidth div CountWin;
          Ostatok := SumWidth mod CountWin;
          DiffOtstup := 0;

          for l := 1 to CurrCont.GetMaxRow do
          begin
            for k := 1 to CurrCont.GetMaxColumn do
            begin
              if (CurrIndexes[l][k] <> -1) then
              begin
                ProfilOtstup := ChooseProfileOtstup(l, k);
                CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetXOtstup(
                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).GetXOtstup +
                  DiffOtstup);

                OldWidth := CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l,
                  k)).GetWidth;

                if (Ostatok > 0) then
                begin
                  Ostatok := Ostatok - 1;

                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetWidth(
                    WidthOfGlass + ProfilOtstup + 1);
                  DiffOtstup := DiffOtstup + WidthOfGlass - OldWidth + ProfilOtstup + 1;

                end
                else
                begin
                  CurrCont.GetWindow(CurrCont.GetIndexRowColumn(l, k)).SetWidth(
                    WidthOfGlass + ProfilOtstup);
                  DiffOtstup := DiffOtstup + WidthOfGlass - OldWidth + ProfilOtstup;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  ResetAllWindowSelections;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Image1.ClientRect);
  DrawWindows;
end;

procedure TForm1.ComboBox4Change(Sender: TObject);
var
  CurrWin: TRectWindow;
  CurrCont: TWindowContainer;
  SelectedIndex: integer;
begin
  SelectedIndex := ComboBox4.ItemIndex;
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  CurrWin := CurrCont.GetWindow(CurrCont.GetSelectedIndex);
  if ((SelectedIndex = 1) and ((FullContainer.Count <> 1) or
    (CurrCont.Count <> 1) or (CurrWin.GetHeight <> CurrWin.GetWidth))) then
  begin
    ComboBox4.ItemIndex := 0;
    ShowMessage('Ошибка: Невозможно поменять форму окна на КРУГ:'
      + #13#10 +
      '- В одной конструкции должно быть только ОДНО окно'
      + #13#10 +
      '- В изделии должна быть только ОДНА конструкция'
      +
      #13#10 +
      '- Ширина и высота окна должны быть ОДИНАКОВЫМИ');
  end;
  CurrWin.SetForm(ComboBox4.ItemIndex);
  if (CurrWin.GetForm = 1) then
  begin
    CurrWin.SetType(0);
    CurrWin.SetMoskit(False);
    Label7.Visible := False;
    Combobox1.Visible := False;
    Label8.Visible := False;
    CheckBox1.Visible := False;
    MenuItem2.Enabled := False;
    MenuItem5.Enabled := False;
    CurrWin.SetCircleWinFramuga(False);
  end
  else
  begin
    Label7.Visible := True;
    Combobox1.Visible := True;
    Combobox1.ItemIndex := 0;
  end;

  DrawWindows;
end;

function TForm1.ChooseProfileOtstup(Row, Col: integer): integer;
var
  ProfilOtstup: integer;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  if (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(Row, Col)).GetType = 0) then
  begin
    if ((CurrCont.GetWindow(CurrCont.GetIndexRowColumn(Row, Col)).GetColumn = 1) or
      (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(Row, Col)).GetColumn =
      CurrCont.GetMaxColumn)) then
      ProfilOtstup := 71
    else
      ProfilOtstup := 52;
  end
  else
  begin
    if ((CurrCont.GetWindow(CurrCont.GetIndexRowColumn(Row, Col)).GetColumn = 1) or
      (CurrCont.GetWindow(CurrCont.GetIndexRowColumn(Row, Col)).GetColumn =
      CurrCont.GetMaxColumn)) then
      ProfilOtstup := 169
    else
      ProfilOtstup := 150;
  end;

  Result := ProfilOtstup;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var
  SelectedIndex, i, j: integer;
  SelectedContainer: TWindowContainer;
  SelectedWindow: TRectWindow;
  ImpostsContainer: TImpostsContainer;
begin
  ResetAllWindowSelections;
  RectWindowDeselected(Self);
  // Получаем индекс выбранного элемента в ComboBox3
  SelectedIndex := ComboBox3.ItemIndex;

  // Проверяем, что индекс корректен
  if (SelectedIndex >= 0) and (SelectedIndex < FullContainer.Count) then
  begin
    // Получаем выбранный контейнер через метод GetContainer
    SelectedContainer := FullContainer.GetContainer(SelectedIndex);
    CurrentContainer := FullContainer.IndexOfContainer(SelectedContainer);
    Edit3.Text := IntToStr(SelectedContainer.GetConstrHeight);
    Edit4.Text := IntToStr(SelectedContainer.GetConstrWidth);
    Edit1.Text := '0';
    Edit2.Text := '0';
    // Очищаем холст перед отрисовкой
    Image1.Canvas.Brush.Color := clWhite;
    Image1.Canvas.FillRect(Image1.ClientRect);
    Panel1.Enabled := False;
    Panel3.Enabled := False;


    // Проверяем, есть ли окна в контейнере
    if Assigned(SelectedContainer) and (SelectedContainer.Count > 0) then
    begin
      // Проходим по всем окнам в контейнере и отрисовываем их
      for i := 0 to SelectedContainer.Count - 1 do
      begin
        SelectedWindow := SelectedContainer.GetWindow(i);
        RectWindow := SelectedWindow;
        if (RectWindow.GetIsDoor = False) then
        begin
          ComboBox1.Items[0] := 'Глухая';
          ComboBox1.Items[3] := 'Откидная';
          ComboBox2.Visible := False;
          Label9.Visible := False;
          CheckBox1.Visible := True;
          Label8.Visible := True;
        end
        else if (RectWindow.GetIsDoor = True) then
        begin
          ImpostsContainer := RectWindow.GetImpostsContainer;
          ComboBox1.Items[0] := '(недоступно)';
          ComboBox1.Items[3] := '(недоступно)';
          ComboBox2.Visible := True;
          Label9.Visible := True;
          ComboBox2.Clear;
          CheckBox1.Visible := False;
          Label8.Visible := False;
          if Assigned(ImpostsContainer) then
          begin
            for j := 0 to ImpostsContainer.Count - 1 do
            begin
              ComboBox2.Items.Add(Format('%d мм',
                [ImpostsContainer.GetImpost(j).GetFImpYOtstup]));
            end;
          end;

        end;
        if RectWindow.GetSelection then
          RectWindowDeselected(RectWindow);

        // Подключаем функции выделения
        RectWindow.OnWindowSelected := @RectWindowSelected;
        RectWindow.OnWindowDeselected := @RectWindowDeselected;

        // Отрисовываем окно
        RectWindow.SetZoomIndex(DrawingIndex);
        FRectWidth := SelectedContainer.GetConstrWidth;
        FRectHeight := SelectedContainer.GetConstrHeight;
      end;

    end;
    DrawWindows;
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
      (HeightValue <= 2400) and (WidthValue * HeightValue <= 6000000) then
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
  Window: TRectWindow;
  NoOneHeight, NoOneWidth: boolean;
  i: integer;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  KoefPaint := DrawingIndex;
  ScaledWidth := Round((KoefPaint) * CurrCont.GetConstrWidth);
  ScaledHeight := Round((KoefPaint) * CurrCont.GetConstrHeight);
  Image1.Canvas.Pen.Width := 1;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Font.Size := 11;
  Image1.Canvas.Brush.Style := bsClear;
  //Линия высоты
  Image1.Canvas.MoveTo(ScaledWidth + 45, 3);
  Image1.Canvas.LineTo(ScaledWidth + 45, ScaledHeight);
  Image1.Canvas.TextOut(ScaledWidth + 65, ScaledHeight div 2 - 10,
    IntToStr(CurrCont.GetConstrHeight));
  //Маленькая линия высоты (сверху)
  Image1.Canvas.MoveTo(ScaledWidth, 3);
  Image1.Canvas.LineTo(ScaledWidth + 55, 3);
  //Маленькая линия высоты (снизу)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth + 55, ScaledHeight);


  //Линия ширины
  Image1.Canvas.MoveTo(3, ScaledHeight + 30);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight + 30);
  Image1.Canvas.TextOut(ScaledWidth div 2 - 10, ScaledHeight + 42,
    IntToStr(CurrCont.GetConstrWidth));
  //Маленькая линия ширины (слева)
  Image1.Canvas.MoveTo(3, ScaledHeight);
  Image1.Canvas.LineTo(3, ScaledHeight + 35);
  //Маленькая линия ширины (справа)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight + 35);

  if (CurrCont.Count > 1) then
  begin
    for i := 0 to CurrCont.Count - 1 do
    begin
      NoOneHeight := False;
      NoOneWidth := False;
      Window := TRectWindow(CurrCont.GetWindow(i));
      if (Window.GetWidth <> FRectWidth) then
        NoOneWidth := True;
      if (Window.GetHeight <> FRectHeight) then
        NoOneHeight := True;
      Window.PaintSize(ScaledWidth, ScaledHeight, Round(Window.GetXOtstup * KoefPaint),
        Round(Window.GetYOtstup * KoefPaint), NoOneWidth, NoOneHeight);
    end;
  end;
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
  WindowIndex: integer;
  Window: TRectWindow;
  DoorImpost: TPlasticDoorImpost;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  Number := '0';
  WindowIndex := CurrCont.GetSelectedIndex;
  Window := TRectWindow(CurrCont.GetWindow(WindowIndex));
  if (Window.GetForm = 1) then
  begin
    Window.SetCircleWinFramuga(True);
    DrawWindows;
  end
  else
  begin
    // Создаем диалог для ввода числа
    if InputQuery('Размер горизонтального импоста',
      'Расстояние от верхней границы окна (мм):',
      Number) then
    begin
      if TryStrToInt(Number, HorizImpost) then
      begin
        if (Window.GetIsDoor = True) then
        begin
          DoorImpost := TPlasticDoorImpost.Create(HorizImpost, Image1);
          Window.GetImpostsContainer.AddImpost(DoorImpost);
          ComboBox2.Items.Add(Format('%d мм', [HorizImpost]));
          ComboBox2.ItemIndex := ComboBox2.Items.Count - 1;
          DrawWindows;
        end
        else
          HorizontalImpost(HorizImpost);
      end
      else
      begin
        ShowMessage('Некорректный ввод числа');
      end;
    end;
  end;
end;

{******** ДОБАВЛЕНИЕ ВЕРТИКАЛЬНОГО ИМПОСТА **********}
procedure TForm1.VerticalImpost(VertImpost: integer);
var
  WindowIndex, Otstup: integer;
  Window, Window1, Window2: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  // Находим индекс окна, которое нужно разделить
  WindowIndex := CurrCont.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(CurrCont.GetWindow(WindowIndex));
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
          ComboBox1.ItemIndex, 0, False);
        Window2 := TRectWindow.Create(Window.GetRow, Window.GetColumn +
          1, Window.GetSize.X, Window.GetSize.Y - VertImpost, Image1,
          Otstup + VertImpost, Window.GetYOtstup, ComboBox1.ItemIndex, 0, False);

        UpdateIndexes(0, Window.GetRow, Window.GetColumn + 1, Otstup);


        // Удаляем исходное окно из контейнера
        CurrCont.RemoveWindow(WindowIndex);

        // Добавляем два новых окна в контейнер
        CurrCont.AddWindow(Window1);
        CurrCont.AddWindow(Window2);



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
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  // Находим индекс окна, которое нужно разделить
  WindowIndex := CurrCont.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(CurrCont.GetWindow(WindowIndex));
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
          Window.GetYOtstup, ComboBox1.ItemIndex, 0, False);

        NewCol := UpdateIndexes(2, Window.GetRow + 1, Window.GetColumn,
          Window.GetXOtstup);

        Window2 := TRectWindow.Create(Window.GetRow + 1, NewCol,
          Window.GetSize.X - HorizImpost, Window.GetWidth, Image1,
          Window.GetXOtstup, Window.GetYOtstup + HorizImpost,
          ComboBox1.ItemIndex, 0, False);

        // Удаляем исходное окно из контейнера
        CurrCont.RemoveWindow(WindowIndex);

        // Добавляем два новых окна в контейнер
        CurrCont.AddWindow(Window1);
        CurrCont.AddWindow(Window2);


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
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  // Находим индекс окна, которое нужно соединить
  WindowIndex := CurrCont.GetSelectedIndex;
  if WindowIndex >= 0 then
  begin
    // Получаем экземпляр окна
    Window := TRectWindow(CurrCont.GetWindow(WindowIndex));
    if Assigned(Window) then
    begin
      // Проверяем высоту окна
      if (Window.GetXOtstup > 0) then
      begin
        for Index := 0 to CurrCont.Count - 1 do
        begin
          LeftWindow := TRectWindow(CurrCont.GetWindow(Index));
          if Assigned(Window) and (LeftWindow.GetXOtstup =
            (Window.GetXOtstup - LeftWindow.GetWidth)) and
            (LeftWindow.GetHeight = Window.GetHeight) and
            (LeftWindow.GetYOtstup = Window.GetYOtstup) then
          begin

            // Удаляем 1 окно из контейнера, а размеры второго изменяем
            LeftWindow.SetWidth(LeftWindow.GetWidth + Window.GetWidth);
            NewCol := UpdateIndexes(1, Window.GetRow, Window.GetColumn,
              Window.GetXOtstup);


            CurrCont.RemoveWindow(CurrCont.IndexOf(Window));



            // Изменяем текст ширину окна

            RectWindowDeselected(Self);
            Image1.Canvas.Brush.Color := clWhite;
            Image1.Canvas.FillRect(Image1.ClientRect);
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
  WindowIndex, Index: integer;
  SelectedIndex, NewCol: integer;
  ImpostsContainer: TImpostsContainer;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  // Находим индекс окна, которое нужно разделить
  WindowIndex := CurrCont.GetSelectedIndex;
  Window := TRectWindow(CurrCont.GetWindow(WindowIndex));
  if (Window.GetForm = 1) then
  begin
    Window.SetCircleWinFramuga(False);
    DrawWindows;
  end
  else
  begin
  if WindowIndex >= 0 then
  begin
    if Assigned(Window) then
    begin
      if (Window.GetIsDoor = True) then
      begin
        ImpostsContainer := Window.GetImpostsContainer;

        // Check if the container is not empty
        if (ImpostsContainer <> nil) and (ImpostsContainer.Count > 0) then
        begin
          // Get the selected index from ComboBox2
          SelectedIndex := ComboBox2.ItemIndex;

          // Ensure the selected index is valid
          if (SelectedIndex >= 0) and (SelectedIndex < ImpostsContainer.Count) then
          begin
            // Remove the impost at the selected index
            ImpostsContainer.RemoveImpostByIndex(SelectedIndex);

            // Remove the corresponding item from ComboBox2
            ComboBox2.Items.Delete(SelectedIndex);
          end
          else
          begin
            // Handle invalid index (optional)
            ShowMessage('Импост для удаления не найден');
          end;
        end
        else
        begin
          // Handle empty container (optional)
          ShowMessage('Импостов нет');
        end;
        DrawWindows;
      end;
      // Проверяем высоту окна
      if ((Window.GetYOtstup > 0) and (Window.GetIsDoor <> True)) then
      begin
        for Index := 0 to CurrCont.Count - 1 do
        begin
          UpWindow := TRectWindow(CurrCont.GetWindow(Index));
          if Assigned(Window) and (UpWindow.GetYOtstup =
            (Window.GetYOtstup - UpWindow.GetHeight)) and
            (UpWindow.GetWidth = Window.GetWidth) and
            (UpWindow.GetXOtstup = Window.GetXOtstup) then
          begin

            // Удаляем 1 окно из контейнера, а размеры второго изменяем
            UpWindow.SetHeight(UpWindow.GetHeight + Window.GetHeight);
            NewCol := UpdateIndexes(3, Window.GetRow, Window.GetColumn,
              Window.GetXOtstup);


            CurrCont.RemoveWindow(CurrCont.IndexOf(Window));



            RectWindowDeselected(Self);
            Image1.Canvas.Brush.Color := clWhite;
            Image1.Canvas.FillRect(Image1.ClientRect);
            DrawWindows;
            Break;

          end;
        end;
      end
      else
      begin
        if (Window.GetIsDoor <> True) then
          ShowMessage(
            'Возможно вы выбрали самое верхнее окно');
      end;
    end;
  end;
end;
 end;

{******** ОБНОВЛЕНИЕ ИНДЕКСОВ **********}
function TForm1.UpdateIndexes(OperationNum, NewRow, NewCol, NewOtstup: integer): integer;
var
  Window: TRectWindow;
  CountWin, RightWins, i: integer;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  // Добавление вертикального импоста
  if (OperationNum = 0) then
  begin
    for i := 0 to CurrCont.Count - 1 do
    begin
      Window := TRectWindow(CurrCont.GetWindow(i));
      if ((Window.GetRow = NewRow) and (Window.GetColumn >= NewCol)) then
      begin
        Window.SetColumn(Window.GetColumn + 1);

        // Добавляем текст из индекс окна
      end;
    end;
    Result := 0;
  end;
  // Удаление вертикального импоста
  if (OperationNum = 1) then
  begin
    for i := 0 to CurrCont.Count - 1 do
    begin
      Window := TRectWindow(CurrCont.GetWindow(i));
      if ((Window.GetRow = NewRow) and (Window.GetColumn > NewCol)) then
      begin
        Window.SetColumn(Window.GetColumn - 1);

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
    for i := 0 to CurrCont.Count - 1 do
    begin
      Window := TRectWindow(CurrCont.GetWindow(i));
      if (Window.GetRow = NewRow) then
      begin
        CountWin := CountWin + 1;
        if (Window.GetXOtstup >= NewOtstup) then
        begin
          Window.SetColumn(Window.GetColumn + 1);

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
    for i := 0 to CurrCont.Count - 1 do
    begin
      Window := TRectWindow(CurrCont.GetWindow(i));
      if (Window.GetRow = NewRow) and (Window.GetColumn > NewCol) then
      begin
        Window.SetColumn(Window.GetColumn - 1);

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
  CurCont: TWindowContainer;
begin

  ClickX := Mouse.CursorPos.X;
  ClickY := Mouse.CursorPos.Y;

  //получаем координаты клика
  ClickX := Image1.ScreenToClient(Point(ClickX, ClickY)).X;
  ClickY := Image1.ScreenToClient(Point(ClickX, ClickY)).Y;


  // Проверяем, принадлежит ли клик какому-либо окну в контейнере
  CurCont := FullContainer.GetContainer(CurrentContainer);
  WindowIndex := CurCont.FindWindow(ClickX, ClickY);
  // Если клик попадает в окно
  if (WindowIndex >= 0) then
  begin
    // Получаем выбранное окно
    Window := TRectWindow(CurCont.GetWindow(WindowIndex));
    if (CheckSelectionWindows = False or Window.GetSelection = True) then
    begin
      // Устанавливаем новое выбранное окно
      // Вызываем обработчик события OnWindowSelected
      Window.Select(Self);
      Window.OnWindowSelected := @RectWindowSelected;
      Window.OnWindowDeselected := @RectWindowDeselected;
      if (CurCont.GetSelectedIndex <> CurCont.IndexOf(Window)) then
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
  CurCont: TWindowContainer;
begin
  MaxRow := -1;
  MaxCol := -1;
  CurCont := FullContainer.GetContainer(CurrentContainer);
  for i := 0 to CurCont.Count - 1 do
  begin
    Window := TRectWindow(CurCont.GetWindow(i));
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
      for i := 0 to CurCont.Count - 1 do
      begin
        Window := TRectWindow(CurCont.GetWindow(i));
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
  CurCont: TWindowContainer;
begin
  Result := False; // Initialize the result to False
  CurCont := FullContainer.GetContainer(CurrentContainer);
  for i := 0 to CurCont.Count - 1 do
  begin
    Window := TRectWindow(CurCont.GetWindow(i));
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
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  for I := 0 to CurrCont.Count - 1 do
  begin
    Window := CurrCont.GetWindow(I);
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
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  for I := 0 to CurrCont.Count - 1 do
  begin
    Window := CurrCont.GetWindow(I);
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

{******** CБРОС ВЫДЕЛЕНИЯ ВСЕХ ОКОН **********}
procedure TForm1.ResetAllWindowSelections;
var
  i, j: integer;
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  for i := 0 to FullContainer.Count - 1 do
  begin
    CurrCont := FullContainer.GetContainer(i);
    // Iterate through all windows in the current container
    for j := 0 to CurrCont.Count - 1 do
    begin
      Window := TRectWindow(CurrCont.GetWindow(j)); // Corrected index to j
      if Assigned(Window) and Window.FSelected then // Check if the window is selected
      begin
        Window.Select(nil); // Call Select to deselect the window
      end;
    end;
  end;
  // Call the existing method to reset UI elements
  RectWindowDeselected(nil);
end;



{******** ОБНОВЛЕНИЕ ТАБЛИЦЫ **********}
procedure TForm1.UpdateTable;
var
  i, j: integer;
  TempString: string;
  WindowList: TStringList;
begin
  {
  // Создаем список окон с их индексами
  WindowList := TStringList.Create;
  try
    for i := 0 to WindowContainer.Count - 1 do
    begin
      WindowList.Add(IntToStr(WindowContainer.GetWindow(i).GetRow) +
        '.' + IntToStr(WindowContainer.GetWindow(i).GetColumn) +
        '|' + IntToStr(i));
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
      j := StrToInt(Copy(WindowList[i], Pos('|', WindowList[i]) + 1,
        Length(WindowList[i])));

      TempString := Copy(WindowList[i], 1, Pos('|', WindowList[i]) - 1);
      StringGrid1.Cells[0, i + 1] := TempString;
      StringGrid1.Cells[1, i + 1] := IntToStr(WindowContainer.GetWindow(j).GetHeight);
      StringGrid1.Cells[2, i + 1] := IntToStr(WindowContainer.GetWindow(j).GetWidth);
      StringGrid1.Cells[3, i + 1] :=
        ComboBox1.Items[WindowContainer.GetWindow(j).GetType];
    end;
  finally
    WindowList.Free;
    }
end;




end.
