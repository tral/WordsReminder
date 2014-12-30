unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,  SQLite3, sqlite3udf, SQLiteWrap;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure SavePhrase();
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1, Unit2;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  SavePhrase();
  Form2.ClearCounter();
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm3.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ( Key = VK_Return ) and ( ssCtrl in Shift ) then
  Begin
    SavePhrase();
    Memo1.Lines.Clear ;
    Key := 0 ;
  End;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

procedure TForm3.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm3.Memo1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ( Key = VK_Return ) and ( ssCtrl in Shift ) then
  Begin
    SavePhrase();
    Memo1.Lines.Clear ;
    Key := 0 ;
  End;
end;

procedure TForm3.SavePhrase;
var sql, fore, nati: UTF8String;
    i:integer;
begin

  if (Memo1.Lines.Count < 1) then
    begin
      showmessage('Введите фразу на родном языке!');
      Exit;
    end;

  if (Length(Edit1.Text) < 1) then
    begin
      showmessage('Введите фразу на иностранном языке!');
      Exit;
    end;

    nati := Memo1.Lines[0];
    for i := 1 to Memo1.Lines.Count - 1 do
      nati := nati+#13+#10+Memo1.Lines[i];

    fore := Edit1.Text;


  fore := StringReplace(fore, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  fore := StringReplace(fore, '''', ' ', [rfReplaceAll, rfIgnoreCase]);
  nati := StringReplace(nati, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  nati := StringReplace(nati, '''', ' ', [rfReplaceAll, rfIgnoreCase]);

  Form2.Edit1.Text := fore; // Сразу покажем добавленную фразу в поиске

  sql := ' INSERT INTO words(fore, nati) VALUES(TRIM("'+fore+'"), TRIM("'+nati+'"));';

  try
    Form1.words.ExecSQL(sql);
  except on E:Exception do
   begin
    ShowMessage('Запрос не выполнен! ' +#13#10 +
                'SQL: ' + sql +#13#10 +
                'Ошибка: ' + E.Message);
   end;
  end;

  Form2.SearchPhrase();
  Form3.Close;

end;

end.
