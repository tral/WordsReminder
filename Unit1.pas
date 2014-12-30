unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShellAPI,
  StdCtrls, ExtCtrls, IniFiles, Menus, SQLite3, sqlite3udf, SQLiteWrap, Registry;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    cm_winautoload: TMenuItem;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure cm_winautoloadClick(Sender: TObject);
  private

    procedure ShowNextTooltip(remember_card:boolean);
    procedure ShowBalloonTips(s1,s2:UTF8String);

  public

    words : TSQLiteDatabase; //база данных SQLite
    procedure ReloadAndApplySettings();

   procedure MyRegWriteString(dwRootKey: DWord; const Key, Param, Val :String);
   procedure MyRegDelete(dwRootKey: DWord; const Key, Param :String);
   function MyRegReadString(dwRootKey: DWord; const Key, Param :String):String;
   function MyRegReadInteger(dwRootKey: DWord; const Key, Param :String):Integer;

  end;

var
  Form1: TForm1;
  remembered_card : longint;

  const
    AppName = 'WordsRemindeer';

implementation

uses Unit2;

{$R *.dfm}


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ShowNextTooltip(true);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  ShowNextTooltip(false);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  words.Free;
end;


function TForm1.MyRegReadString(dwRootKey: DWord; const Key, Param :String):String;
 var Res : String;
     Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key,True);
  Res := Reg.ReadString(Param);
  Reg.Free;
  Result := Res;
end;

function TForm1.MyRegReadInteger(dwRootKey: DWord; const Key, Param :String):Integer;
 var Res : Integer;
     Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key,True);
  try
    Res := Reg.ReadInteger(Param);
  except
    Res := 0;
  end;
  Reg.Free;
  Result := Res;
end;

procedure TForm1.MyRegWriteString(dwRootKey: DWord; const Key, Param, Val :String);
 var Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key,True);
  Reg.WriteString(Param, Val);
  Reg.Free;
end;

procedure TForm1.MyRegDelete(dwRootKey: DWord; const Key, Param :String);
 var Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key,True);
  Reg.DeleteValue(Param);
  Reg.Free;
end;


procedure TForm1.N1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Form2.Show;
  Form2.StringGrid1.ColWidths[0] := 30;
  Form2.StringGrid1.ColWidths[1] := 250;
  Form2.StringGrid1.ColWidths[2] := 250;
  Form2.StringGrid1.Cells[0,0] := 'id';
  Form2.StringGrid1.Cells[1,0] := 'Иностранный';
  Form2.StringGrid1.Cells[2,0] := 'Родной';
  Form2.Edit1.Text:='';
end;

procedure TForm1.ReloadAndApplySettings;
begin
   // При первом запуске выставляем автозагрузку, прописываем автообновления
  if (length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName, 'NotFirstLaunch')) < 1)
    then
    begin
       MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName, 'NotFirstLaunch', 'Yes');
//       MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName, 'AutoUpdates', 'Yes');
       //Reg_WriteDateTime(HKEY_CURRENT_USER, '\Software\' + AppName, 'LastUpdate', Now());
       MyRegWriteString(HKEY_LOCAL_MACHINE, '\Software\Microsoft\Windows\CurrentVersion\Run', AppName, Application.ExeName);
    end;

  // Проверяем настройку автозапуска
  if (length(MyRegReadString(HKEY_LOCAL_MACHINE, '\Software\Microsoft\Windows\CurrentVersion\Run', AppName)) > 0)
    then cm_winautoload.Checked := true
    else cm_winautoload.Checked := false;



end;

procedure TForm1.ShowBalloonTips(s1,s2:UTF8String);
begin
  TrayIcon1.BalloonHint := s1;
  TrayIcon1.BalloonTitle := s2;
  TrayIcon1.ShowBalloonHint();
end;

procedure TForm1.ShowNextTooltip(remember_card:boolean);
  var SQLite_table: TSQLiteTable;
      sql: UTF8String;
begin

 if (remembered_card > -1) and (remember_card=false) then
   sql := 'select id, fore, nati from words where id='+IntToStr(remembered_card)+' LIMIT 1'
 else
   sql := 'select id, fore, nati from words ORDER BY RANDOM() LIMIT 1';

//  showmessage(sql);
  SQLite_table := words.GetTable(sql);

  ShowBalloonTips(SQLite_table.FieldAsString(2), SQLite_table.FieldAsString(1) );

  if (remember_card) then
    remembered_card := SQLite_table.FieldAsInteger(0)
  else
    remembered_card := -1;

  SQLite_table.Destroy;

end;


procedure TForm1.cm_winautoloadClick(Sender: TObject);
begin
  if (length(MyRegReadString(HKEY_LOCAL_MACHINE, '\Software\Microsoft\Windows\CurrentVersion\Run', AppName)) > 0)
  then
  begin
    MyRegDelete(HKEY_LOCAL_MACHINE, '\Software\Microsoft\Windows\CurrentVersion\Run', AppName);
    cm_winautoload.Checked := false;
  end
  else
    begin
      MyRegWriteString(HKEY_LOCAL_MACHINE, '\Software\Microsoft\Windows\CurrentVersion\Run', AppName, Application.ExeName);
      cm_winautoload.Checked := true;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var Ini: Tinifile;
//  myFile : TextFile;
//  t1,t2   : UTF8string;
begin

  ReloadAndApplySettings();

  remembered_card := -1;

  words := TSQLiteDatabase.Create(extractfilepath(paramstr(0))+'words.db'); //указываем файл БД

  // настройки
  Ini := TiniFile.Create(extractfilepath(paramstr(0))+'WordsReminder.ini');
  Timer1.Interval := Ini.ReadInteger('Settings','IntervalMins', 15) * 60 * 1000;

 {
  // Попытка открыть файл Test.txt для записи
  AssignFile(myFile, extractfilepath(paramstr(0))+'words.txt');
  Reset(myFile);


  // Показ содержимого файла
  while not Eof(myFile) do
  begin
    ReadLn(myFile, t1);
    ReadLn(myFile, t2);


     t1 := StringReplace(t1, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  t1 := StringReplace(t1, '''', ' ', [rfReplaceAll, rfIgnoreCase]);
  t2 := StringReplace(t2, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  t2 := StringReplace(t2, '''', ' ', [rfReplaceAll, rfIgnoreCase]);



    try
      Form1.words.ExecSQL(' INSERT INTO words(fore, nati) VALUES(TRIM("'+t1+'"), TRIM("'+t2+'"));');
    except on E:Exception do
     begin
      ShowMessage('Запрос не выполнен! ' +#13#10 +
                  'SQL: ' +
                  'Ошибка: ' + E.Message);
     end;
    end;
  end;
}


end;



end.
