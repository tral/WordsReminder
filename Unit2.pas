unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, SQLite3, sqlite3udf, SQLiteWrap, Menus;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    phPopup: TPopupMenu;
    test1: TMenuItem;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SearchPhrase();
    procedure ShowAll();
    procedure ClearCounter();
  end;

var
  Form2: TForm2;

implementation

uses Unit1, Unit3;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form3.Edit1.Text := '';
  Form3.Memo1.Clear;
  Form3.ShowModal;
end;

procedure TForm2.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
ShowAll();

end;

procedure TForm2.ClearCounter;
begin
  Label2.Caption := '';
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  Form2.SearchPhrase();
  ClearCounter();
end;

procedure TForm2.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm2.SearchPhrase;
 var SQLite_table: TSQLiteTable;
      i : integer;
      srch : UTF8String;
begin
  if (Length(Edit1.Text) >=3) then
  begin

    srch := Edit1.Text;

    SQLite_table := Form1.words.GetTable('select id, fore, nati from words where fore like "%'+srch+'%" or nati like "%'+srch+'%" LIMIT 500');

    StringGrid1.Perform(WM_SETREDRAW, 0, 0);

    StringGrid1.RowCount := 1;

    try
        while not SQLite_table.EOF do
        begin
          StringGrid1.RowCount := Form2.StringGrid1.RowCount + 1;
          StringGrid1.Cells[0,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(0);
          StringGrid1.Cells[1,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(1);
          StringGrid1.Cells[2,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(2);
          SQLite_table.Next;
        end;
    finally
      StringGrid1.Perform(WM_SETREDRAW, 1, 0);
      StringGrid1.Invalidate; // important! to force repaint after all
    end;

    SQLite_table.Destroy;
  end;
end;


procedure TForm2.ShowAll;
 var SQLite_table: TSQLiteTable;
      i , max_p: integer;

begin

    max_p := 5000;

    SQLite_table := Form1.words.GetTable('select id, fore, nati from words order by fore LIMIT '+inttostr(max_p));

    StringGrid1.Perform(WM_SETREDRAW, 0, 0);

    StringGrid1.RowCount := 1;

    try
        while not SQLite_table.EOF do
        begin
          StringGrid1.RowCount := Form2.StringGrid1.RowCount + 1;
          StringGrid1.Cells[0,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(0);
          StringGrid1.Cells[1,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(1);
          StringGrid1.Cells[2,StringGrid1.RowCount-1] := SQLite_table.FieldAsString(2);
          SQLite_table.Next;
        end;
    finally
      StringGrid1.Perform(WM_SETREDRAW, 1, 0);
      StringGrid1.Invalidate; // important! to force repaint after all
    end;

    Label2.Caption :='Всего показано фраз: '+inttostr(StringGrid1.RowCount -1) + ' (макс. отображаемых:'+inttostr(max_p)+')';
    SQLite_table.Destroy;
end;

procedure TForm2.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TForm2.test1Click(Sender: TObject);
 var
      i : integer;
      sql, cond : UTF8String;
begin

cond := '';

for I := StringGrid1.Selection.Top to StringGrid1.Selection.Bottom do
begin
  if i >0  then
   begin

       if (cond <> '') then  cond := cond + ', ';

      cond := cond + StringGrid1.Cells[0,i]
   end;
end;

if (cond <> '') then
  begin
    if MessageDlg('Удалить фразу(ы) с id = '+cond+' ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin

         sql := ' DELETE FROM WORDS where id in (' + cond + ')';
//         showmessage(sql);
         try
           Form1.words.ExecSQL(sql);
         except on E:Exception do
          begin
           ShowMessage('Запрос не выполнен! ' +#13#10 +
                       'SQL: ' + sql +#13#10 +
                       'Ошибка: ' + E.Message);
          end;
         end;

         ShowAll();


      end;
  end
  else showmessage('Выбарите хотя бы одну фразу');

end;

end.
