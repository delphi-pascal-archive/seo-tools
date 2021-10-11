unit dist_list;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IniFiles, OleCtrls, SHDocVw, ExtCtrls,
  MSHTML_TLB, ActiveX, Menus, ShellApi, Buttons, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, WinInet;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    ListBox1: TListBox;
    Memo2: TMemo;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    StatusBar1: TStatusBar;
    Edit2: TEdit;
    Label7: TLabel;
    Button3: TButton;
    TabSheet3: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    Memo3: TMemo;
    ListView1: TListView;
    OpenDialog1: TOpenDialog;
    PopupMenu2: TPopupMenu;
    SelectAll1: TMenuItem;
    Clear1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Deletekeyword1: TMenuItem;
    Button4: TButton;
    Button5: TButton;
    CheckBox2: TCheckBox;
    ComboBox3: TComboBox;
    Button6: TButton;
    Button7: TButton;
    Label14: TLabel;
    Label15: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Button8: TButton;
    SaveDialog1: TSaveDialog;
    Label13: TLabel;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Button10: TButton;
    ProgressBar2: TProgressBar;
    RichEdit2: TRichEdit;
    TabSheet6: TTabSheet;
    Edit6: TEdit;
    Button11: TButton;
    Memo4: TMemo;
    ListView2: TListView;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    GroupBox2: TGroupBox;
    Button12: TButton;
    Edit5: TEdit;
    Button9: TButton;
    CheckBox3: TCheckBox;
    Button13: TButton;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label8: TLabel;
    Label16: TLabel;
    Button14: TButton;
    Edit10: TEdit;
    Label17: TLabel;
    PageControl2: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    WebBrowser1: TWebBrowser;
    RichEdit1: TRichEdit;
    TabSheet9: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    ListBox2: TListBox;
    Button15: TButton;
    TabSheet10: TTabSheet;
    RichEdit3: TRichEdit;
    PopupMenu3: TPopupMenu;
    GetfrombrowserPlaintext1: TMenuItem;
    PopupMenu4: TPopupMenu;
    GetfrombrowserPlaintext2: TMenuItem;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    IdHTTP1: TIdHTTP;
    ListBox3: TListBox;
    CheckBox4: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowser1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Deletekeyword1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure GetfrombrowserPlaintext1Click(Sender: TObject);
    procedure GetfrombrowserPlaintext2Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure ListBox3DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function End_points(lbl: TLabel): string;
    function FlorenthExtractTextWords(const Text: string): TStringList;    
  end;

var
  Form1: TForm1;
  path: string;

implementation

uses webbrowser_functs, Dictionary, SmartCompare;

{$R *.dfm}

// добавление "..." в конец строки
function TForm1.End_points(lbl: TLabel): string;
var
 s: string;
 i: integer;
begin
 s:=lbl.Hint;
 //
 if lbl.Canvas.TextWidth(s)<=lbl.Width
 then
  begin
   result:=s;
   lbl.ShowHint:=false;
   Exit;
  end;
 //
 lbl.Caption:='';
 //
 for i:=1 to Length(s) do
  begin
   lbl.Caption:=lbl.Caption+s[i];
   if (lbl.Canvas.TextWidth(lbl.Caption)+22>=lbl.Width)
   then
    begin
     result:=lbl.Caption+'...';
     lbl.ShowHint:=true;
     Break;
    end;
  end;
end;

procedure DistinctList(AllList: TStrings);
var
 Filtered: TStringList;
begin
 Filtered:=TStringList.Create;
 Filtered.Duplicates:=dupIgnore;
 Filtered.BeginUpdate;
 Filtered.Sorted:=true;
 Filtered.AddStrings(AllList);
 AllList.Clear;
 AllList.Assign(Filtered);
 Filtered.EndUpdate;
 Filtered.Free;
end;

procedure TForm1.TabSheet1Show(Sender: TObject);
begin
 Memo1.OnChange(Sender);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 ListBox1.Clear;
 Memo2.Clear;

 ListBox1.Items.Text:=Memo1.Text;
 DistinctList(ListBox1.Items);
 Memo2.Text:=ListBox1.Items.Text;

 Label2.Caption:=Format('Result strings (%d):',[Memo2.Lines.Count]);
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
 i: integer;
 s,ss: string;
begin
 for i:=0 to ListBox1.Items.Count-1 do
  begin
   if CheckBox1.Checked
   then
    begin
     s:=AnsiLowerCase(ListBox1.Items.Strings[i]);
     ss:=AnsiLowerCase(Edit1.Text);
    end
   else
    begin
     s:=ListBox1.Items.Strings[i];
     ss:=Edit1.Text;
    end;

   if pos(ss,s)<>0
   then
    begin
     Memo1.SelStart:=Memo1.Perform(EM_LINEINDEX, i, 0);
     Memo1.SelLength:=Length(Memo1.Lines[i]);
     Break;
    end
   else Memo1.SelLength:=0;
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
 ListBox1.Items.Text:=Memo1.Text;
 Label1.Caption:=Format('Source strings (%d):',[Memo1.Lines.Count]);
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var 
 s: string;
 i: integer;
 htmlDoc: IHtmlDocument2;
 // PersistFile: IPersistFile;
begin
 ComboBox2.Enabled:=true;

 Label13.Hint:=Webbrowser1.OleObject.Document.Title;
 s:=End_points(Label13);
 Label13.Caption:='"'+s+'"';

 RichEdit1.Clear;
 WB_GetHTMLCode(Webbrowser1, RichEdit1.Lines);

 // Label4.Caption:='Internal links: '+IntToStr(Webbrowser1.OleObject.Document.links.Length);
 // Label8.Caption:=WebBrowser1.OleObject.Document.All.Tags('title').Value;

 // внешние ссылки
 Listbox2.Items.Clear;
 for i:=0 to Webbrowser1.OleObject.Document.Links.Length-1 do
  Listbox2.Items.Add(Webbrowser1.OleObject.Document.Links.Item(i));
 DistinctList(Listbox2.Items);
 Label4.Caption:='Internal links: '+IntToStr(Listbox2.Items.Count);
 // Сохранить html код без тегов
 // htmlDoc:=WebBrowser1.document as IHtmlDocument2;
 // PersistFile:=HTMLDoc as IPersistFile;
 // PersistFile.Save(StringToOleStr(ExtractFilePath(Application.ExeName)+'clear_text.txt'), true);

 htmlDoc:=IHTMLDocument2(WebBrowser1.Document);
 // WebBrowser1.ControlInterface.Document.QueryInterface(IHtmlDocument2,iDoc);
 // Memo5.Text:=htmlDoc.body.innerHTML; // без Body
 // Memo5.Text:=htmlDoc.body.outerHTML; // с Body
 // Memo5.Text:=htmlDoc.body.innerText;
 RichEdit3.Text:=htmlDoc.body.outerText;
 //
 // s:=WebBrowser1.LocationURL+' || '+
 //   ((pDisp as IWebBrowser).Document as IHtmlDocument2).URL;
 //
 // Shows the URL of the current page displayed
 ComboBox1.Text:=WebBrowser1.OleObject.Document.Url;
 // Shows the Title of the current page displayed
 // ShowMessage('Page Title: '+WebBrowser1.OleObject.Document.title);
 // Show the document referrer 
 // ShowMessage('Referer: '+WebBrowser1.OleObject.Document.referrer);
end;

procedure TForm1.WebBrowser1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
 if ProgressMax=0
 then
  begin
   StatusBar1.SimpleText:='Progress: 100% loaded...';
   ProgressBar1.Position:=0;
   Exit;
  end;

 try
  if (Progress<>-1) and (Progress<=ProgressMax)
  then
   begin
    StatusBar1.SimpleText:='Progress: '+IntToStr((Progress*100) div ProgressMax)+'% loaded...';
    ProgressBar1.Position:=(Progress*100) div ProgressMax;
   end
  else
   begin
    StatusBar1.SimpleText:='Progress: 100% loaded...';
    ProgressBar1.Position:=ProgressBar1.Max;
   end; 
 except
  on EDivByZero do
   Exit;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Webbrowser1.Stop;
 ProgressBar1.Max:=0;
 if Trim(Combobox1.Text)<>''
 then Webbrowser1.Navigate(Combobox1.Text);
end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13
 then
  begin
   Key:=#0;
   Button2.Click;
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  try
   // 20 %
   if ComboBox2.Text='20 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.2;
   // 30 %
   if ComboBox2.Text='30 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.3;
   // 40 %
   if ComboBox2.Text='40 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.4;
   // 50 %
   if ComboBox2.Text='50 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.5;
   // 60 %
   if ComboBox2.Text='60 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.6;
   // 70 %
   if ComboBox2.Text='70 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.7;
   // 80 %
   if ComboBox2.Text='80 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.8;
   // 90 %
   if ComboBox2.Text='90 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.9;
   // 100 %
   if ComboBox2.Text='100 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=1;
   // 110 %
   if ComboBox2.Text='110 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.1;
   // 125 %
   if ComboBox2.Text='125 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.25;
    // 150 %
   if ComboBox2.Text='150 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.5;
   // 175 %
   if ComboBox2.Text='175 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.75;
   // 200 %
   if ComboBox2.Text='200 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=2;
   // 250 %
   if ComboBox2.Text='250 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=2.5;
   // 300 %
   if ComboBox2.Text='300 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=3;
   // 400 %
   if ComboBox2.Text='400 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=4;
   // 500 %
   if ComboBox2.Text='500 %'
   then WebBrowser1.OleObject.Document.Body.Style.Zoom:=5;
  except

  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 path:=ExtractFilePath(Application.ExeName);
 ComboBox1.ItemIndex:=0;
 ComboBox2.ItemIndex:=9;
 Combobox3.ItemIndex:=0;
 OpenDialog1.InitialDir:=Paramstr(0);
 SaveDialog1.InitialDir:=OpenDialog1.InitialDir;
 if FileExists(path+'check_keywords.txt')
 then ListBox3.Items.LoadFromFile(path+'check_keywords.txt');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 ComboBox1.Text:='http://www.yandex.ru';
 Button2.Click;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 // SearchAndHighlightText(Edit2.Text);
 WB_SearchAndHighlightText(WebBrowser1, Edit2.Text);
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
 Memo3.SelectAll;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
 Memo3.Clear;
end;

procedure TForm1.Deletekeyword1Click(Sender: TObject);
begin
 if ListView1.ItemIndex<>-1
 then ListView1.Items.Delete(ListView1.ItemIndex);

 Label11.Caption:='Count: '+IntToStr(ListView1.Items.Count);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 if OpenDialog1.Execute
 then
  begin
   Memo3.Lines.LoadFromFile(OpenDialog1.FileName);
   Button5.Click;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
 i: integer;
 s,st: string;
 nitem: TListItem;
begin
 ListView1.Clear;
 for i:=0 to Memo3.Lines.Count-1 do
  begin
   s:=Trim(Memo3.Lines.Strings[i]);
   if s<>''
   then
    begin
     if ComboBox3.ItemIndex<>0
     then
      begin
       if ComboBox3.ItemIndex=1
       then
        begin
         st:=s[1];
         st:=AnsiLowerCase(st);
         s[1]:=st[1];
         end;
       if ComboBox3.ItemIndex=2
       then
        begin
         st:=s[1];
         st:=AnsiUpperCase(st);
         s[1]:=st[1];
         end;
       if ComboBox3.ItemIndex=3
       then s:=AnsiLowerCase(s);
       if ComboBox3.ItemIndex=4
       then s:=AnsiUpperCase(s);
      end;

     if CheckBox2.Checked
     then
      begin
       st:=Copy(s,length(s),1);
       if (st='.') or (st='!') or (st='?')
       then Delete(s,length(s),1);
      end;

     nitem:=ListView1.Items.Add;
     nitem.Caption:=s;
    end;
  end;

 Label11.Caption:='Count: '+IntToStr(ListView1.Items.Count);
end;


procedure TForm1.Button7Click(Sender: TObject);
var
 // i: integer;
 s: string;
begin
 // i:=Memo1.SelStart;
 // s:=Copy(Memo1.Text,i,Memo1.SelLength);
 s:=Memo3.SelText;
 s:='#a#'+s+'#/a#';
 Memo3.SelText:=s;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
 i: integer;
 s,ss: string;
begin
 for i:=0 to ListView1.Items.Count-1 do
  begin
   s:=ListView1.Items.Item[i].Caption;
   if (pos(Edit3.Text,AnsiLowerCase(s))<>0)
     and (ListView1.Items.Item[i].Checked=false)
   then
    begin
     ss:=Copy(s,pos(AnsiLowerCase(Edit1.Text),AnsiLowerCase(s)),6);
     s:=StringReplace(s,Edit3.Text,'#a#'+Edit4.Text+'#/a#',[rfReplaceAll,rfIgnoreCase]);
     ListView1.Items.Item[i].Caption:=s;
    end;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
 i: integer;
 Str: TStringList;
begin
 if SaveDialog1.Execute
 then
  begin
   Str:=TStringList.Create;

   for i:=0 to ListView1.Items.Count-1 do
    Str.Add(ListView1.Items.Item[i].Caption);

   Str.SaveToFile(SaveDialog1.FileName);
   Str.Free;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
 s: string;
begin
 if Trim(Edit5.Text)=''
 then Exit;

 if CheckBox4.Checked=true
 then s:='&rd=0'
 else s:='';

 if CheckBox3.Checked=false
 then Webbrowser1.Navigate('http://www.yandex.ru/yandsearch?text='+PChar(Edit5.Text)+s)
 else Webbrowser1.Navigate('http://www.yandex.ru/yandsearch?text=%22'+PChar(Edit5.Text)+'%22'+s);
 // http://www.yahoo.com - link:http://www.1c.ru/ -site:1c.ru
 Pagecontrol1.ActivePageIndex:=0;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
 i: Integer;
 S: TStringList;
 M: TMemoryStream;
 SH: TDictionaryFounder;
begin
 RichEdit2.Lines.SaveToFile('dict_text.txt');

 S:=TStringList.Create;
 try
  S.LoadFromFile('dict_text.txt');
  ProgressBar2.Position:=0;
  ProgressBar2.Max:=S.Count;
  SH:=TDictionaryFounder.Create;
  try
   for i:=0 to S.Count-1 do
    begin
     SH.AddData(S.Strings[i]);
     ProgressBar2.Position:=i;
     Sleep(10);
    end;
   M:=TMemoryStream.Create;
   try
    SH.SaveToStream(M);
    M.SaveToFile('dict_words.txt');
    ProgressBar2.Position:=0;
   finally
    M.Free;
   end;
  finally
   SH.Free;
  end;
 finally
  S.Free;
 end;

 RichEdit2.Lines.LoadFromFile('dict_words.txt');
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
 Panel2.Caption:=Format('   Minimum percents: %d%%',[TrackBar1.Position]);
end;

function CustomSortProc(Item1,Item2:TListItem;ParamSort:Integer):Integer;stdcall;
begin
 if Single(Item1.Data)>Single(Item2.Data)
 then Result:=1
 else Result:=-1;
end;

function TForm1.FlorenthExtractTextWords(const Text: string): TStringList;
var
 Word: string;
 PText, WDeb: PChar;
begin
 Result:=TStringList.Create;
 Result.Sorted:=true;
 Result.Duplicates:=dupIgnore;
 PText:=PChar(Text);
 repeat
  while (PText^<>#0) and not IsCharAlpha(PText^) do
   Inc(PText);
   WDeb := PText;
   repeat
    Inc(PText);
   until not IsCharAlpha(PText^);
   if WDeb<>PText
   then
    begin
     SetLength(Word, PText-WDeb);
     StrLCopy(PChar(Word), WDeb, PText-WDeb);
     Result.Add(AnsiLowerCase(Word));
    end;
  until PText^=#0;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
 r: Single;
 s: string;
 a: integer;
 l: TStringList;
begin
 ListView2.Clear;
 l:=FlorenthExtractTextWords(Memo4.Text);
 ListView2.Items.BeginUpdate;
 try
  s:=Edit6.Text;
  for a:=0 to l.Count-1 do
   begin
    r:=SmartDist(l[a],s);
    if 100*(1-r)>TrackBar1.Position
    then
     with ListView2.Items.Add do
      begin
       Caption:=l[a];
       Data:=Pointer(r);
       SubItems.Add(Format('%f%%',[100*(1-r)]));
      end;
   end;
  ListView2.CustomSort(@CustomSortProc,0);
 finally
  ListView2.Items.EndUpdate;
  l.Destroy;
 end;
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
 Button11.Click;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
 Webbrowser1.Navigate('http://www.yandex.ru/yandsearch?serverurl='+PChar(Edit10.Text)+'"&rd=0');
 Pagecontrol1.ActivePageIndex:=0;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
 Webbrowser1.Navigate('http://www.yandex.ru/yandsearch?serverurl='
  +PChar(Edit8.Text)
  +'&text="'
  +PChar(Edit9.Text)
  +'"&rd=0');
 Pagecontrol1.ActivePageIndex:=0;
end;

// http://www.yahoo.com - link:http://www.1c.ru/ -site:1c.ru
procedure TForm1.Button13Click(Sender: TObject);
var
 s: string;
begin
 s:='http://search.yahoo.com/search?p=link%3Ahttp%3A%2F%2F'
  +Edit7.Text
  +'%2F+-site%3A'
  +Edit7.Text
  +'/&y=Search&rd=r1&meta=vc%3Dru&fr=yfp-t-501&fp_ip=RU&xargs=0&pstart=1&b=11';
 Webbrowser1.Navigate(PChar(s));
 Pagecontrol1.ActivePageIndex:=0;
end;

// текст из таблицы
procedure TForm1.Button15Click(Sender: TObject);
var
 s: string;
 i,j: integer;
 ovTable: Variant;
begin
 ovTable:=WebBrowser1.OleObject.Document.all.tags('table').item(1);
  for i:=0 to (ovTable.Rows.Length-1) do
    for j:=0 to (ovTable.Rows.Item(i).Cells.Length-1) do
     s:=s+ovTable.Rows.Item(i).Cells.Item(j).InnerText;
 RichEdit1.Text:=s;
end;

procedure TForm1.GetfrombrowserPlaintext1Click(Sender: TObject);
begin
 RichEdit2.Text:=RichEdit3.Text;
end;

procedure TForm1.GetfrombrowserPlaintext2Click(Sender: TObject);
begin
 Memo4.Text:=RichEdit3.Text;
end;

procedure TForm1.ListBox2DblClick(Sender: TObject);
var
 s: string;
begin
 if ListBox2.ItemIndex<>-1
 then
  begin
   s:=ListBox2.Items.Strings[ListBox2.ItemIndex];
   ShellExecute(0,'open',PChar(s),'','',SW_SHOW)
  end;
end;

function GetInetFileSize(const FileUrl: string): Int64;
var
 idHTTP_Temp: TidHTTP;
begin
 idHTTP_Temp:=TIdHTTP.Create(nil);
 idHTTP_Temp.Head(FileUrl);
 // размер файла
 Result:=idHTTP_Temp.Response.ContentLength;
 IdHTTP_Temp.Free;
end;

procedure TForm1.Button18Click(Sender: TObject);
var
 s: string;
begin
 idHTTP1.Get('http://www.delphisources.ru/');
 // при этом у файла должен передаваться заголовок
 // "ContentLength", иначе бует результата "-1"
 // s:=IntToStr(GetInetFileSize('http://www.delphisources.ru/'));
 // MessageDlg('Size of "http://www.delphisources.ru" equals '+s+' bytes.', mtInformation, [mbOK],0);
end;

procedure TForm1.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
var
 fs: Int64;
begin
 if AWorkMode = wmRead
 then
  begin
   fs:=AWorkCountMax;
   MessageDlg(Format('Size of "http://www.delphisources.ru" equals %d bytes.',[fs]), mtInformation, [mbOK],0);
  end;
end;

procedure TForm1.ListBox3DblClick(Sender: TObject);
var
 s: string;
begin
 if ListBox3.ItemIndex=-1
 then Exit;

 s:=ListBox3.Items.Strings[ListBox3.ItemIndex];
 Webbrowser1.Navigate('http://www.yandex.ru/yandsearch?text='+PChar(s));
 Pagecontrol1.ActivePageIndex:=0;
end;

end.

{
 for i:=0 to iDoc.all.length-1 do
  begin
   //получаем имя типа тэга
   workstr:=(iDoc.all.item(i, EmptyParam) as IHtmlElement).tagName;
   //получаем аттрибут тэга Name
   name:=(iDoc.all.item(i, EmptyParam) as IHtmlElement).getAttribute('Name',0);
   //получаем свойство тэга Value
   value:=(iDoc.all.item(i, EmptyParam) as IHtmlElement).getAttribute('value',0);
   //получаем свойство тэга Type
   tip:=(iDoc.all.item(i, EmptyParam) as IHtmlElement).getAttribute('type',0);
   //для тэга <textarea> значение надо получать чуть иначе
   value:=(iDoc.all.item(i, EmptyParam) as IHtmlElement).innerText;
  end;
}

