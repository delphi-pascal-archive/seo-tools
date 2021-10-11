////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Unit Name : Dictionary
//  * Purpose   : Набор классов для работы с индексированным списком поиска
//  * Author    : Александр Багель
//  * Copyright : Центр Гранд 2001 - 2004 г.
//  * Version   : 1.00
//  ****************************************************************************
//

unit Dictionary;

interface

uses
  Windows, Classes, SysUtils{, FullTextGetter};

type
  // Класс отвечающий за создание словаря уникальных слов
  TDictionaryFounder = class
  private
    FDict: TList;
    FDictMem: array of String;
    FDictMemCount: Integer;
  protected
    function GetPos(const Value: String): Integer; virtual;
    procedure Insert(Value: String; Position: Integer); virtual;
    function Prepare(const Value: String): String; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddData(Value: String); //overload;
   // procedure AddData(ObjText: IFullTextGetter); overload;
    procedure SaveToStream(var AStream: TMemoryStream);
  end;

  // Класс осуществляющий поиск в словаре
  // полученном от TDictionaryFounder
  TDictionaryFinder = class
  private
    FDict: array of ShortString;
    FDictLength: Cardinal;
  protected
    function GetPos(const Value: ShortString;
      const SubStr: Boolean = False): Boolean; virtual;
  public
    destructor Destroy; override;
    procedure LoadFromStream(const AStream: TMemoryStream);
    function Find(const Value: String;
      const SubStr: Boolean = False): Boolean;
  end;

implementation

{ TDictionaryFounder }

//
//  Добавление информации для построения массива индексов
// =============================================================================
procedure TDictionaryFounder.AddData(Value: String);
var
  Tmp: String;
  Position, I: Integer;
  S: TStringList;
begin
  Value := Prepare(Value);
  S := TStringList.Create;
  try
    S.Text := Value;
    for I := 0 to S.Count - 1 do
    begin
      Tmp := S[I];
      if Tmp = '' then Continue;
      if FDict.Count = 0 then
        Insert(Tmp, 0)
      else
      begin
        Position := GetPos(Tmp);
        if (Position >= 0) then
          if FDict.Count > Position then
          begin
            if String(FDict.Items[Position]) <> Tmp then
              Insert(Tmp, Position);
          end
          else
            Insert(Tmp, Position);
      end;
    end;
  finally
    S.Free;
  end;
end;

//
//  Добавление информации для построения массива индексов
//  Информация приходит из интерфейса
// =============================================================================
{procedure TDictionaryFounder.AddData(ObjText: IFullTextGetter);
var
  S: String;
begin
  if ObjText = nil then
    raise Exception.Create('IFullTextGetter is empty.');
  S := ObjText.GetText;
  AddData(S);
end;   }

constructor TDictionaryFounder.Create;
begin
  FDict := TList.Create;
end;

destructor TDictionaryFounder.Destroy;
begin
  FDict.Free;
  FDictMemCount := 0;
  SetLength(FDictMem, FDictMemCount);
  inherited;
end;

//
//  Возвращает номер позиции где находится слово, или должно находится...
//  Поиск методом половинного деления...
// =============================================================================
function TDictionaryFounder.GetPos(const Value: String): Integer;
var
  FLeft, FRight, FCurrent: Cardinal;
begin
  if FDict.Count = 0 then
  begin
    Result := 0;
    Exit;
  end;
  FLeft := 0;
  FRight := FDict.Count - 1;
  FCurrent := (FRight + FLeft) div 2;
  if String(FDict.Items[FLeft]) > Value then
  begin
    Result := 0;
    Exit;
  end;
  if String(FDict.Items[FRight]) < Value then
  begin
    Result := FRight + 1;
    Exit;
  end;
  repeat
    if String(FDict.Items[FCurrent]) = Value then
    begin
      Result := FCurrent;
      Exit;
    end;
    if String(FDict.Items[FCurrent]) < Value then
      FLeft := FCurrent
    else
      FRight := FCurrent;
    FCurrent := (FRight + FLeft) div 2;
  until FLeft = FCurrent;
  if String(FDict.Items[FCurrent]) < Value then Inc(FCurrent);
  Result := FCurrent;
end;

//
//  Добавление нового индекса в массив индексов
// =============================================================================
procedure TDictionaryFounder.Insert(Value: String; Position: Integer);
begin
  if FDictMemCount < FDict.Count + 1 then
  begin
    Inc(FDictMemCount, FDict.Count + 1);
    SetLength(FDictMem, FDictMemCount);
  end;
  FDictMem[FDict.Count] := Value;
  FDict.Insert(Position, @FDictMem[FDict.Count][1]);
end;

//
//  Сохранение массива индексов в поток
// =============================================================================
procedure TDictionaryFounder.SaveToStream(var AStream: TMemoryStream);
var
  I: Integer;
  S: PChar;
  TmpS: TStringList;
begin
  if AStream = nil then Exit;
  TmpS := TStringList.Create;
  try
    for I := 0 to FDict.Count - 1 do
    begin
      S := FDict.Items[I];
      TmpS.Add(S);
    end;
    AStream.Position := 0;
    AStream.Size := Length(TmpS.Text);
    AStream.Write(TmpS.Text[1], Length(TmpS.Text));
    AStream.Position := 0;
  finally
    TmpS.Free;
  end;
end;

//
//  Подготовка данных к обработке...
//  Удаляются все не буквенные символы, каждое слово начинется с новой строки...
// =============================================================================
function TDictionaryFounder.Prepare(const Value: String): String;
var
  I: Integer;
  Len: Cardinal;
  C: PAnsiChar;
  LastEnter: Boolean;
begin
  SetLength(Result, Length(Value) * 2);
  Len := 0;
  LastEnter := False;
  for I := 1 to Length(Value) do
  begin
    C := CharLower(@Value[I]);
    if C^ in ['a'..'z', 'а'..'я'] then
    begin
      Inc(Len);
      Result[Len] := C^;
      LastEnter := False;
    end
    else
      if not LastEnter then
      begin
        Inc(Len);
        Result[Len] := #13;
        Inc(Len);
        Result[Len] := #10;
        LastEnter := True;
      end;
  end;
  SetLength(Result, Len);
end;

{ TDictionaryFinder }

destructor TDictionaryFinder.Destroy;
begin
  FDictLength := 0;
  SetLength(FDict, FDictLength);
  inherited;
end;

//
//  Поиск введенных слов...
// =============================================================================
function TDictionaryFinder.Find(const Value: String;
  const SubStr: Boolean = False): Boolean;
var
  S: TStringList;
  I: Integer;
begin
  Result := False;
  if Value = '' then Exit;
  S := TStringList.Create;
  try
    S.Text := StringReplace(Value, ' ', #13#10, [rfReplaceAll]);
    S.Text := AnsiLowerCase(S.Text);
    if S.Count = 0 then Exit;
    for I := 0 to S.Count - 1 do
    begin
      Result := GetPos(S.Strings[I], SubStr);
      if not Result then Exit;
    end;
  finally
    S.Free;
  end;
end;

//
//  Поиск каждого слова в массиве индексов
// =============================================================================
function TDictionaryFinder.GetPos(const Value: ShortString;
  const SubStr: Boolean = False): Boolean;
var
  FLeft, FRight, FCurrent, I: Cardinal;
begin
  Result := False;
  if SubStr then
  begin
    for I := 0 to FDictLength - 1 do
      if Pos(Value, FDict[I]) > 0 then
      begin
        Result := True;
        Exit;
      end;
  end
  else
  begin
    if FDictLength = 0 then Exit;
    FLeft := 0;
    FRight := FDictLength - 1;
    FCurrent := (FRight + FLeft) div 2;
    if FDict[FLeft] > Value then Exit;
    if FDict[FRight] < Value then Exit;
    if FDict[FLeft] = Value then
    begin
      Result := True;
      Exit;
    end;
    if FDict[FRight] = Value then
    begin
      Result := True;
      Exit;
    end;
    repeat
      if FDict[FCurrent] = Value then
      begin
        Result := True;
        Exit;
      end;
      if FDict[FCurrent] < Value then
        FLeft := FCurrent
      else
        FRight := FCurrent;
      FCurrent := (FRight + FLeft) div 2;
    until FLeft = FCurrent;
  end;
end;

//
//  Загрузка массива индексов из потока
// =============================================================================
procedure TDictionaryFinder.LoadFromStream(const AStream: TMemoryStream);
var
  S: TStringList;
  I: Integer;
begin
  S := TStringList.Create;
  try
    AStream.Position := 0;
    S.LoadFromStream(AStream);
    FDictLength := S.Count;
    if FDictLength = 0 then Exit;
    SetLength(FDict, FDictLength);
    for I := 0 to FDictLength - 1 do
      FDict[I] := S.Strings[I];
  finally
    S.Free;
  end;
end;

end.
