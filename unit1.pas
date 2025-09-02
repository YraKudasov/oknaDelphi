unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Buttons, Menus, RectWindow, WindowContainer, Unit2, Unit3,
  PlasticDoorImpost, ImpostsContainer, FullContainer,ImpostBetweenWindows,
  LCLType, Grids, ActnList, Generics.Collections, SQLite3, SQLite3Conn, SQLDB;

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
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
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
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;



    procedure AlignWidth(Sender: TObject);
    procedure AlignForSun(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure DrawFullConstruction(Sender: TObject);
    procedure DeleteConstr(Sender: TObject);
    procedure ChooseTypeOfNewConstr(Sender: TObject);
    procedure ChooseTypeOfAddingConstr(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure CreateNewFullConstr(Sender: TObject; IsPlasticDoor: boolean);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure UpperTrianglePoint(Sender: TObject);
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
    procedure SaveWindowsToDatabase;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    function IsDataModified: boolean;
    procedure DownTrianglePoint(Sender: TObject);
    procedure Form3ComboBoxChangeHandler(Sender: TObject);




  private
    { Private declarations }
    RectWindow: TRectWindow;
    FRectHeight, FRectWidth: integer;
    WindowContainer: TWindowContainer;
    FullContainer: TFullContainer;
    CurrentContainer: integer;
    FullConstrHeight: integer;
    FullConstrWidth: integer;
    CurrentContainerID: integer;
    FDatabase: TSQLite3Connection; // Database connection
    FTransaction: TSQLTransaction;
    FSelectedWindow: TRectWindow;// Transaction object //



  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParams(AOwner: TComponent);
    property FullContainerProperty: TFullContainer read FullContainer;
    property CurrentContainerProperty: integer read CurrentContainer;

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
        if (CurrCont.GetWindow(0).GetImpostsContainer.Count = 1) then
          CurrCont.GetWindow(0).GetImpostsContainer.GetImpost(
            0).SetImpYOtstup(CurrCont.GetWindow(0).GetHeight div 2);
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
          if (Window.GetForm = 2) then
            Window.SetType(0);
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
                if (ChangedWindow.GetForm = 2) then
                  ChangedWindow.SetType(0);
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
                if (ChangedWindow.GetForm = 2) then
                  ChangedWindow.SetType(0);
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
                if (ChangedWindow.GetForm = 2) then
                  ChangedWindow.SetType(0);
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
                if (ChangedWindow.GetForm = 2) then
                  ChangedWindow.SetType(0);
              end;
            end
            else
              ShowMessage(
                'ШИРИНУ окна НЕ удалось изменить. Возможно размеры СОСЕДНИХ окон становятся МЕНЬШЕ минимально допустимых при изменении размеров данного.');
          end;
        end;
        if (Window.GetForm = 2) then
          Window.SetType(0);
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
  Window: TRectWindow;
  ImpostsContainer: TImpostsContainer;
  j: integer;
begin
  Window := TRectWindow(Sender);
  FSelectedWindow := Window;
  if Assigned(Window) then
  begin
    Panel1.Enabled := True;
    Panel3.Enabled := True;
    Edit1.Text := IntToStr(Window.GetHeight);
    Edit2.Text := IntToStr(Window.GetWidth);
      MenuItem1.Enabled := True;
        MenuItem4.Enabled := True;
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
    Label8.Visible := False;
    CheckBox1.Visible := False;
  end;
    if (Window.GetForm = 2) then
  begin
     MenuItem1.Enabled:=False;
    MenuItem4.Enabled:=False;
  end;
  if (Window.GetForm = 3) then
  begin
    MenuItem1.Enabled:=False;
    MenuItem4.Enabled:=False;
    Panel5.Visible := True;
    BitBtn5.Enabled := False;
  end;
  if (Window.GetForm = 4) then
  begin
  MenuItem1.Enabled:=False;
    MenuItem4.Enabled:=False;
    if not Assigned(Form3) then
      Application.CreateForm(TForm3, Form3);
    // создаём форму, если ещё не создана
    Form3.Edit1.Text := '';
    Form3.Edit2.Text := '';
    Form3.Edit3.Text := '';
    Form3.Edit4.Text := '';
    ComboBox1.Enabled := False;
    Panel1.Enabled := False;
    Panel2.Enabled := False;
    Form3.ShowModal;  // показываем форму немодально
  end;
end;

// Обработчик изменения ComboBox1 на Form3
procedure TForm1.Form3ComboBoxChangeHandler(Sender: TObject);
begin
  if Assigned(FSelectedWindow) and Assigned(Form3) then
  begin
    Form3.ComboBox1Change(Sender);
    FSelectedWindow.DrawWindow;
    FSelectedWindow.DrawTrapeciaPoint(Form3.GetCurrPoint);
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
  Panel5.Visible := False;
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
      if (Window.GetForm = 1) or (Window.GetForm = 2) or (Window.GetForm = 3) then
      begin
        if (ComboBox1.ItemIndex = 1) or (ComboBox1.ItemIndex = 2) or
          (ComboBox1.ItemIndex = 4) or (ComboBox1.ItemIndex = 5) then
        begin
          ShowMessage('Этот элемент недоступен.');
          ComboBox1.ItemIndex := 0; // Сбрасываем выбор
          Window.SetType(0);
          CheckBox1.Visible := False;
          Label8.Visible := False;
        end
        else if (ComboBox1.ItemIndex = 3) and
          (Window.GetImpostsContainer.Count <> 0) then
        begin
          Window.SetType(0);
          ComboBox1.ItemIndex := 0;
          ShowMessage(
            'Предупреждение: На окно уже добавлен импост. Уберите его перед добавлением створки');
        end
        else if ((Window.GetForm = 2) and (ComboBox1.ItemIndex = 3)) then
        begin
          if ((Window.GetWidth div Window.GetHeight <> 2) or
            (Window.GetWidth mod Window.GetHeight <> 0)) then
          begin
            Window.SetType(0);
            ComboBox1.ItemIndex := 0;
            ShowMessage(
              'Предупреждение: Для добавления створки ВЫСОТА арки должны быть равна ПОЛОВИНЕ ШИРИНЫ');
          end;

        end;
        Label8.Visible := False;
        CheckBox1.Visible := False;

      end;
      Window.SetZoomIndex(DrawingIndex);
      DrawWindows;
      PaintSizes;
    end;
  end;
end;

procedure TForm1.UpperTrianglePoint(Sender: TObject);
var
  IntEdit: integer;
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  Window := CurrCont.GetWindow(CurrCont.GetSelectedIndex);

  // Попытка преобразовать текст в целое число, если не удается, устанавливаем 0
  if not TryStrToInt(Edit5.Text, IntEdit) then
    IntEdit := 0;

  // Проверка на ввод корректных значений
  if (IntEdit <> Window.GetUpperPoint) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (IntEdit >= 0) and (IntEdit <= Window.GetWidth) then
      BitBtn5.Enabled := True
    else
      BitBtn5.Enabled := False;
  end
  else
    BitBtn5.Enabled := False;

  if (Edit5.Caption = '') then
    BitBtn5.Enabled := False;
end;

procedure TForm1.DownTrianglePoint(Sender: TObject);
var
  IntEdit: integer;
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  Window := CurrCont.GetWindow(CurrCont.GetSelectedIndex);

  // Попытка преобразовать текст в целое число, если не удается, устанавливаем 0
  if not TryStrToInt(Edit6.Text, IntEdit) then
    IntEdit := 0;

  // Проверка на ввод корректных значений
  if (IntEdit <> Window.GetDownPoint) then
  begin
    // Проверка на минимальное и максимальное значение для длины и ширины
    if (IntEdit >= 0) and (IntEdit <= Window.GetHeight) then
      BitBtn5.Enabled := True
    else
      BitBtn5.Enabled := False;
  end
  else
    BitBtn5.Enabled := False;

  if (Edit6.Caption = '') then
    BitBtn5.Enabled := False;
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
  Button7.Enabled := False;
  Panel5.Visible := False;

  FDatabase := TSQLite3Connection.Create(Self);
  FTransaction := TSQLTransaction.Create(Self);
  // Создаем объект транзакции
  FDatabase.Transaction := FTransaction;
  // Присваиваем транзакцию соединению с базой данных

  FDatabase.DatabaseName := 'WinDB.db';
  // Устанавливаем имя базы данных
  try
    FDatabase.Connected := True; // Подключаемся к базе данных
  except
    on E: Exception do
    begin
      ShowMessage('Ошибка подключения к базе данных: ' +
        E.Message);
      Exit; // Выходим, если подключение не удалось
    end;
  end;

  // Создаем таблицы, если они не существуют
  FDatabase.ExecuteDirect(
    'CREATE TABLE IF NOT EXISTS Containers (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT)');

  FDatabase.ExecuteDirect(
    'CREATE TABLE IF NOT EXISTS Constructions (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'ContainerID INTEGER, ' +
    'FOREIGN KEY(ContainerID) REFERENCES Containers(ID))');

  FDatabase.ExecuteDirect(
    'CREATE TABLE IF NOT EXISTS Windows (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + 'ConstructionID INTEGER, ' +
    'Height INTEGER, ' + 'Width INTEGER, ' +
    'FOREIGN KEY(ContainerID) REFERENCES Constructions(ID))');

  CurrentContainerID := 0;

end;

function TForm1.IsDataModified: boolean;
var
  Query: TSQLQuery;
  i, j, dbHeight, dbWidth: integer;
  Container: TWindowContainer;
  Window: TRectWindow;
begin
  Result := False;
  if CurrentContainerID = 0 then Exit;
  // Нет сохранённых данных для сравнения

  Query := TSQLQuery.Create(nil);
  try
    Query.SQLConnection := FDatabase;

    // Загружаем конструкции, связанные с текущим контейнером
    Query.SQL.Text :=
      'SELECT ID FROM Constructions WHERE ContainerID = :ContainerID ORDER BY ID';
    Query.ParamByName('ContainerID').AsInteger := CurrentContainerID;
    Query.Open;

    if Query.RecordCount <> FullContainer.Count then
    begin
      Result := True;
      Exit;
    end;

    i := 0;
    while not Query.EOF do
    begin
      Container := TWindowContainer(FullContainer.GetContainer(i));

      // Загружаем окна для каждой конструкции
      with TSQLQuery.Create(nil) do
      try
        SQLConnection := FDatabase;
        SQL.Text :=
          'SELECT Height, Width FROM Windows WHERE ConstructionID = :CID ORDER BY ID';
        ParamByName('CID').AsInteger := Query.Fields[0].AsInteger;
        Open;

        if RecordCount <> Container.Count then
        begin
          Result := True;
          Free;
          Exit;
        end;

        j := 0;
        while not EOF do
        begin
          Window := Container.GetWindow(j);
          dbHeight := FieldByName('Height').AsInteger;
          dbWidth := FieldByName('Width').AsInteger;

          if (dbHeight <> Window.GetHeight) or (dbWidth <> Window.GetWidth) then
          begin
            Result := True;
            Free;
            Exit;
          end;

          Inc(j);
          Next;
        end;
        Free;
      except
        on E: Exception do
        begin
          Free;
          raise;
        end;
      end;

      Inc(i);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  // Если данные не были сохранены (ID = 0) или изменены — выдаём предупреждение
  if (CurrentContainerID = 0) or IsDataModified then
  begin
    if MessageDlg(
      'Обнаружены несохранённые изменения. Закрыть программу без сохранения?',
      mtWarning, [mbYes, mbNo], 0) = mrNo then
    begin
      CanClose := False;
      Exit;
    end;
  end;

  CanClose := True;
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

  Edit5.OnKeyPress := @EditKeyPress;
  Edit6.OnKeyPress := @EditKeyPress;

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
  Button7.Enabled := True;

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
    MenuItem1.Enabled:=True;
    MenuItem2.Enabled:=True;
    MenuItem3.Enabled:=True;
    MenuItem4.Enabled:=True;
    MenuItem5.Enabled:=True;
    MenuItem6.Enabled:=True;
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
  MenuItem1.Enabled:=True;
    MenuItem2.Enabled:=True;
    MenuItem3.Enabled:=True;
    MenuItem4.Enabled:=True;
    MenuItem5.Enabled:=True;
    MenuItem6.Enabled:=True;
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
      MenuItem1.Enabled:=True;
    MenuItem2.Enabled:=True;
    MenuItem3.Enabled:=True;
    MenuItem4.Enabled:=True;
    MenuItem5.Enabled:=True;
    MenuItem6.Enabled:=True;
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
      if ((CurrWin.GetIsDoor) or (CurrWin.GetForm = 1)) then
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
      if ((CurrWin.GetIsDoor) or (CurrWin.GetForm = 1)) then
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

procedure TForm1.BitBtn5Click(Sender: TObject);
var
  UpperPointEdit, DownPointEdit: integer;
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  Window := CurrCont.GetWindow(CurrCont.GetSelectedIndex);
  UpperPointEdit := StrToInt(Edit5.Text);
  DownPointEdit := StrToInt(Edit6.Text);
  Window.SetUpperPoint(UpperPointEdit);
  Window.SetDownPoint(DownPointEdit);
  DrawWindows;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
var
  Window: TRectWindow;
  CurrCont: TWindowContainer;
begin
  CurrCont := FullContainer.GetContainer(CurrentContainer);
  Window := CurrCont.GetWindow(CurrCont.GetSelectedIndex);
  Edit5.Caption := IntToStr(Window.GetUpperPoint);
  Edit6.Caption := IntToStr(Window.GetDownPoint);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  SaveWindowsToDatabase;
end;



procedure TForm1.ComboBox4Change(Sender: TObject);
var
  CurrWin: TRectWindow;
  CurrCont: TWindowContainer;
  SelectedIndex: integer;
  ScaledWidth, ScaledHeight: integer;
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
  if (((SelectedIndex = 2) or (SelectedIndex = 3)) and (CurrWin.GetYOtstup <> 0)) then
  begin
    ComboBox4.ItemIndex := 0;
    ShowMessage('Ошибка: Невозможно поменять форму окна:'
      + #13#10 +
      'Выбранное вами окно имеет отступ сверху больше 0');
  end;
  if((SelectedIndex = 4)and((CurrWin.GetYOtstup <> 0)or(CurrWin.GetXOtstup <> 0)))then
  begin
        ComboBox4.ItemIndex := 0;
    ShowMessage('Ошибка: Невозможно поменять форму окна:'
      + #13#10 +
      'Выбранное вами окно имеет отступ сверху или слева больше 0');
  end;
  CurrWin.SetForm(ComboBox4.ItemIndex);
  if ((SelectedIndex = 4)and(CurrWin.GetYOtstup = 0)and(CurrWin.GetXOtstup = 0)) then
    begin
      if not Assigned(Form3) then
        Application.CreateForm(TForm3, Form3);
      // создаём форму, если ещё не создана
        ScaledWidth := Round((DrawingIndex) * CurrCont.GetConstrWidth);
  ScaledHeight := Round((DrawingIndex) * CurrCont.GetConstrHeight);
      CurrWin.FillPolygonIfEmpty;
      Form3.LoadWindow(CurrWin);
      CurrWin.LoadSizeConstr(ScaledHeight, ScaledWidth);
      Form3.ComboBox1.OnChange := @Form3ComboBoxChangeHandler;
      Form3.Edit1.Text := '';
      Form3.Edit2.Text := '';
      Form3.Edit3.Text := '';
      Form3.Edit4.Text := '';
      DrawWindows;
      Form3.ShowModal;  // показываем форму модально
    end;
  if ((CurrWin.GetForm = 1) or (CurrWin.GetForm = 2) or (CurrWin.GetForm = 3) or
    (CurrWin.GetForm = 4)) then
  begin
    if (CurrWin.GetForm = 4) then
    begin
      ComboBox1.Enabled := False;
      Panel1.Enabled := False;
      Panel2.Enabled := False;
    end
    else
    begin
      ComboBox1.Enabled := True;
      Panel1.Enabled := True;
      Panel2.Enabled := True;
    end;
    if (CurrWin.GetForm <> 1) then
    begin
      MenuItem1.Enabled := False;
      MenuItem4.Enabled := False;
    end
    else
    begin
      MenuItem1.Enabled := True;
      MenuItem4.Enabled := True;
    end;
    ComboBox1.ItemIndex := 0;
    CurrWin.SetType(0);
    CurrWin.SetMoskit(False);
    Label7.Visible := True;
    Combobox1.Visible := True;
    Label8.Visible := False;
    CheckBox1.Visible := False;
    MenuItem2.Enabled := False;
    ComboBox1.Items[1] := '(недоступно)';
    ComboBox1.Items[2] := '(недоступно)';
    ComboBox1.Items[4] := '(недоступно)';
    ComboBox1.Items[5] := '(недоступно)';
    MenuItem5.Enabled := False;
    if (CurrWin.GetForm = 3) then
    begin
      if (CurrWin.GetUpperPoint = 0) then
        CurrWin.SetUpperPoint(CurrWin.GetWidth div 2);
      if (CurrWin.GetDownPoint = 0) then
        CurrWin.SetDownPoint(CurrWin.GetHeight);
    end;
    Edit5.Caption := IntToStr(CurrWin.GetUpperPoint);
    Edit6.Caption := IntToStr(CurrWin.GetDownPoint);
    Panel5.Visible := True;
  end
  else
  begin
    ComboBox1.Enabled := True;
    Panel1.Enabled := True;
    Panel2.Enabled := True;
    MenuItem1.Enabled := True;
    MenuItem2.Enabled := True;
    MenuItem3.Enabled := True;
    MenuItem4.Enabled := True;
    MenuItem5.Enabled := True;
    MenuItem6.Enabled := True;
    ComboBox1.Items[1] := 'Лев. п/о';
    ComboBox1.Items[2] := 'Лев. повор.';
    ComboBox1.Items[4] := 'Прав. п/о';
    ComboBox1.Items[5] := 'Прав. повор.';
    Label7.Visible := True;
    Combobox1.Visible := True;
    Combobox1.ItemIndex := 0;
    if (CurrWin.GetImpostsContainer.Count = 1) then
      CurrWin.GetImpostsContainer.RemoveImpostByIndex(0);
  end;
  if (CurrWin.GetForm <> 3) then
  begin
    CurrWin.SetUpperPoint(0);
    CurrWin.SetDownPoint(0);
    Panel5.Visible := False;
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
        MenuItem1.Enabled:=True;
    MenuItem2.Enabled:=True;
    MenuItem3.Enabled:=True;
    MenuItem4.Enabled:=True;
    MenuItem5.Enabled:=True;
    MenuItem6.Enabled:=True;
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
  Image1.Canvas.MoveTo(ScaledWidth + 55, 3);
  Image1.Canvas.LineTo(ScaledWidth + 55, ScaledHeight);
  Image1.Canvas.TextOut(ScaledWidth + 75, ScaledHeight div 2 - 10,
    IntToStr(CurrCont.GetConstrHeight));
  //Маленькая линия высоты (сверху)
  Image1.Canvas.MoveTo(ScaledWidth, 3);
  Image1.Canvas.LineTo(ScaledWidth + 65, 3);
  //Маленькая линия высоты (снизу)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth + 65, ScaledHeight);


  //Линия ширины
  Image1.Canvas.MoveTo(3, ScaledHeight + 40);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight + 40);
  Image1.Canvas.TextOut(ScaledWidth div 2 - 10, ScaledHeight + 52,
    IntToStr(CurrCont.GetConstrWidth));
  //Маленькая линия ширины (слева)
  Image1.Canvas.MoveTo(3, ScaledHeight);
  Image1.Canvas.LineTo(3, ScaledHeight + 45);
  //Маленькая линия ширины (справа)
  Image1.Canvas.MoveTo(ScaledWidth, ScaledHeight);
  Image1.Canvas.LineTo(ScaledWidth, ScaledHeight + 45);
  Window := TRectWindow(CurrCont.GetWindow(0));
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
    if ((Window.GetImpostsContainer.Count = 0) and (Window.GetType <> 3)) then
    begin
      DoorImpost := TPlasticDoorImpost.Create(Window.GetHeight div 2, Image1);
      Window.GetImpostsContainer.AddImpost(DoorImpost);
      DrawWindows;
    end
    else
      ShowMessage(
        'Импост или створка уже добавлены. Уберите это перед добавлением створки');
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
  if WindowIndex >= 0 then
  begin
    if (Window.GetForm = 1) then
    begin
      if (Window.GetImpostsContainer.Count = 1) then
        Window.GetImpostsContainer.RemoveImpostByIndex(0);
      DrawWindows;
    end
    else
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
    CurCont.DrawBorder(Image1, DrawingIndex);
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


procedure TForm1.SaveWindowsToDatabase;
var
  i, j: integer;
  Container: TWindowContainer;
  Window: TRectWindow;
  Query: TSQLQuery;
  NewConstructionID: integer;
begin
  Query := TSQLQuery.Create(nil);
  try
    Query.SQLConnection := FDatabase;

    if not Assigned(FDatabase) or not FDatabase.Connected then
    begin
      ShowMessage('Database connection is not initialized or not connected.');
      Exit;
    end;

    try
      if not FTransaction.Active then
        FTransaction.StartTransaction;

      // Удаляем старые данные только для текущего контейнера
      if CurrentContainerID > 0 then
      begin
        Query.SQL.Text :=
          'DELETE FROM Windows WHERE ConstructionID IN (SELECT ID FROM Constructions WHERE ContainerID = :ContainerID);';
        Query.ParamByName('ContainerID').AsInteger := CurrentContainerID;
        Query.ExecSQL;

        Query.SQL.Text := 'DELETE FROM Constructions WHERE ContainerID = :ContainerID;';
        Query.ParamByName('ContainerID').AsInteger := CurrentContainerID;
        Query.ExecSQL;
      end;

      // Итерация по контейнерам (должен быть только один, если мы обновляем)
      for i := 0 to FullContainer.Count - 1 do
      begin
        Container := TWindowContainer(FullContainer.GetContainer(i));

        // Если ID контейнера еще не задан, создаем новую запись
        if CurrentContainerID = 0 then
        begin
          // Вставляем контейнер и получаем его ID
          Query.SQL.Text := 'INSERT INTO Containers DEFAULT VALUES';
          Query.ExecSQL;

          // Получаем ID последнего вставленного контейнера
          Query.SQL.Text := 'SELECT LAST_INSERT_ROWID()';
          Query.Open;
          CurrentContainerID := Query.Fields[0].AsInteger;
          Query.Close;
        end;

        // Вставляем конструкцию для контейнера
        Query.SQL.Text :=
          'INSERT INTO Constructions (ContainerID) VALUES (:ContainerID)';
        Query.ParamByName('ContainerID').AsInteger := CurrentContainerID;
        Query.ExecSQL;

        // Получаем ID последней конструкции
        Query.SQL.Text := 'SELECT LAST_INSERT_ROWID()';
        Query.Open;
        NewConstructionID := Query.Fields[0].AsInteger;
        Query.Close;

        // Вставляем окна для этой конструкции
        for j := 0 to Container.Count - 1 do
        begin
          Window := Container.GetWindow(j);

          // Исправлено название столбца на ConstructionID
          Query.SQL.Text := 'INSERT INTO Windows (ConstructionID, Height, Width) ' +
            'VALUES (:ConstructionID, :Height, :Width)';
          Query.ParamByName('ConstructionID').AsInteger := NewConstructionID;
          // Используем ID конструкции
          Query.ParamByName('Height').AsInteger := Window.GetHeight;
          Query.ParamByName('Width').AsInteger := Window.GetWidth;
          Query.ExecSQL;
        end;
      end;

      if FTransaction.Active then
        FTransaction.Commit;
      ShowMessage('Данные успешно сохранены!');
    except
      on E: Exception do
      begin
        if FTransaction.Active then
          FTransaction.Rollback;
        ShowMessage('Error saving ' + E.Message);
      end;
    end;
  finally
    Query.Free;
  end;
end;



end.
