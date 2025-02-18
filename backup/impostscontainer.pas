unit ImpostsContainer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PlasticDoorImpost;

type
  TImpostsContainer = class
  private
    FImpostsList: TList; // Список для хранения экземпляров TPlasticDoorImpost
  public
    constructor Create; // Конструктор
    destructor Destroy; override; // Деструктор для освобождения памяти

    procedure AddImpost(AImpost: TPlasticDoorImpost); // Метод добавления
    procedure RemoveImpost(AImpost: TPlasticDoorImpost); // Метод удаления
    function GetImpost(Index: Integer): TPlasticDoorImpost; // Получение импоста по индексу
    function Count: Integer; // Возвращает количество импостов
  end;

implementation

{ TImpostsContainer }

// Конструктор
constructor TImpostsContainer.Create;
begin
  inherited Create;
  FImpostsList := TList.Create; // Создаем список
end;

// Деструктор
destructor TImpostsContainer.Destroy;
var
  I: Integer;
begin
  // Освобождаем память для каждого экземпляра TPlasticDoorImpost
  for I := 0 to FImpostsList.Count - 1 do
    TObject(FImpostsList[I]).Free;

  FImpostsList.Free; // Освобождаем память для списка
  inherited Destroy;
end;

// Метод добавления импоста
procedure TImpostsContainer.AddImpost(AImpost: TPlasticDoorImpost);
begin
  FImpostsList.Add(AImpost);
end;

// Метод удаления импоста
procedure TImpostsContainer.RemoveImpost(AImpost: TPlasticDoorImpost);
var
  Index: Integer;
begin
  Index := FImpostsList.IndexOf(AImpost);
  if Index <> -1 then
  begin
    TObject(FImpostsList[Index]).Free; // Освобождаем память для удаляемого объекта
    FImpostsList.Delete(Index); // Удаляем из списка
  end;
end;

// Метод получения импоста по индексу
function TImpostsContainer.GetImpost(Index: Integer): TPlasticDoorImpost;
begin
  if (Index >= 0) and (Index < FImpostsList.Count) then
    Result := TPlasticDoorImpost(FImpostsList[Index])
  else
    raise Exception.Create('Index out of bounds');
end;

// Метод получения количества импостов
function TImpostsContainer.Count: Integer;
begin
  Result := FImpostsList.Count;
end;

end.
