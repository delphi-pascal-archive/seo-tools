unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, HTMLPars, Unit2, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    RichEdit1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure LabelClick(Sender:TObject);
    procedure OnHTMLParseError(const Info, Raw: string);
  public
    HTMLParser:THTMLParser;
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

const MiniHTMLViewer = 'MiniHTMLViewer';

procedure TForm1.OnHTMLParseError(const Info,Raw: String);
begin
  MessageBox(Handle,PChar(Raw),PChar(Info),MB_OK);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 s:string;
 j,i:integer;
 obj:TObject;
 HTMLTag:THTMLTag;
 HTMLParam:THTMLParam;
begin
  if not OpenDialog1.Execute
  then Exit;

  RichEdit1.Clear;
  RichEdit1.Lines.BeginUpdate;

  if HTMLParser = nil then
    HTMLParser:=THTMLParser.Create;
  HTMLParser.OnHTMLParseError := OnHTMLParseError;
  HTMLParser.Memory.LoadFromFile(OpenDialog1.FileName);
  HTMLParser.Execute;

  for i:= 1 to HTMLParser.parsed.count do
  begin
   obj:=HTMLParser.parsed[i-1];

   if obj.classtype=THTMLTag then
    begin
     HTMLTag:=THTMLTag(obj);
     s:='ТЕГ: <'+HTMLTag.Name;
     if (HTMLTag.Params = nil) or (HTMLTag.Params.count=0)
     then RichEdit1.Lines.add(s+'>')
     else
     begin
      RichEdit1.Lines.add(s);
      for j:= 1 to HTMLTag.Params.count do
       begin
        HTMLParam:=HTMLTag.Params[j-1];
        s:='  P:   '+HTMLParam.key;
        if HTMLParam.value<>''
        then s:=s+'='+HTMLParam.value;
        if j=HTMLTag.Params.count
        then s:=s+'>';
        RichEdit1.Lines.add(s);
       end;
     end;
    end;

   if obj.classtype=THTMLText
   then RichEdit1.Lines.add('Текст: '+THTMLText(obj).Text);

   if obj.classtype=THTMLComment
   then RichEdit1.Lines.add('Комментарии: '+THTMLComment(obj).Comment);

   if obj.classtype=THTMLServerScript
   then RichEdit1.Lines.add('Скрипт: '+THTMLServerScript(obj).Script);
  end;

  RichEdit1.Lines.EndUpdate;
  Button2.Enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 s:string;
 j,i:integer;
 obj:TObject;
 HTMLTag:THTMLTag;
 HTMLParam:THTMLParam;
 CurrentFont:TFont;
 label1:Tlabel;
 x,y:integer;
 OldFont:TFont;
 ignore:boolean;
 isTitle:boolean;
 isLink:boolean;
 Link:string;
 lastHeight:integer;
 Shape:TShape;
 PreFont:boolean;
begin
 Form2.updating:=true;

 Form2.Caption:=MiniHTMLViewer;
 isTitle:=false;
 isLink:=false;
 PreFont:=false;

 // Clear Page
 for i:= form2.ComponentCount downto 1 do
  form2.Components[i-1].Free;

 //form2.show;

 // set Default font
 CurrentFont:=TFont.Create;
 CurrentFont.Name:='Times New Roman';
 CurrentFont.Size:=12;
 OldFont:=TFont.Create;
 LastHeight:=abs(CurrentFont.Height);

  x:=2;
  y:=2;
  ignore:=true;

  for i:= 0 to HTMLParser.parsed.count - 1 do
  begin
   obj:=HTMLParser.parsed[i];

   if obj.classtype=THTMLTag then
    begin
     HTMLTag:=THTMLTag(obj);

     if SameText(HTMLTag.Name,'H1')
     then
      begin
       OldFont.assign(CurrentFont);
       CurrentFont.Size:=24;CurrentFont.Style:=[fsBold];
       LastHeight:=abs(CurrentFont.Height);
      end;
     if SameText(HTMLTag.Name,'/H1')
     then
      begin
       y:=y+LastHeight;x:=2;
       CurrentFont.assign(OldFont);
       y:=y+abs(CurrentFont.Height);
       lastHeight:=abs(CurrentFont.Height);
      end;
     if SameText(HTMLTag.Name,'BR')
     then
      begin
       y:=y+LastHeight;
       lastHeight:=abs(CurrentFont.Height);
       x:=2;
      end;
     if SameText(HTMLTag.Name,'B')
     then CurrentFont.style:=CurrentFont.style+[fsBold];
     if SameText(HTMLTag.Name,'/B')
     then CurrentFont.style:=CurrentFont.style-[fsBold];

     if SameText(HTMLTag.Name,'TITLE')
     then isTitle:=true;
     if SameText(HTMLTag.Name,'/TITLE')
     then isTitle:=false;

     if SameText(HTMLTag.Name,'HR') then
      begin
       y:=y+LastHeight+Lastheight div 2;
       x:=2;
       LastHeight:=abs(CurrentFont.Height);

       Shape:=TShape.Create(form2);
       Shape.Top:=y;
       Shape.Parent:=Form2;
       shape.Left:=x;
       Shape.Height:=3;
       Shape.Width:=form2.clientwidth-20;
       Shape.Pen.Color:=clGray;
       y:=y+SHape.Height+Lastheight div 2;
      end;

{     disabled because only .BMP files are displayed ;)

      if HTMLTag.Name='IMG' then
      begin
       for j:= 1 to HTMLTag.Params.count do
       begin
        HTMLParam:=HTMLTag.Params[j-1];
         if HTMLParam.Key='SRC' then begin
                                       Image1:=TImage.Create(form2);
                                       Image1.Parent:=Form2;
                                       Image1.Top:=y;
                                       Image1.Left:=x;
                                       Image1.Picture.Loadfromfile('D:\'+HTMLParam.Value);
                                       Image1.Autosize:=true;
                                       x:=x+Image1.Width;
                                      end;
       end;
      end;
}

     if SameText(HTMLTag.Name,'BODY') then
      begin
       ignore:=false;
       if HTMLTag.Params <> nil then
       for j:= 0 to HTMLTag.Params.count - 1 do
       begin
        HTMLParam:=HTMLTag.Params[j];
         if SameText(HTMLParam.Key,'BGCOLOR') then begin
                                          s:=HTMLParam.Value;s[1]:='$';
                                          Form2.Color:=StrToInt(s);
                                         end;
       end;
      end;

     if SameText(HTMLTag.Name,'PRE') then
      begin
       x:=2;
       y:=y+LastHeight;
       PreFont:=true;
      end;

    if SameText(HTMLTag.Name,'/PRE') then
     begin
       x:=2;
       y:=y+LastHeight;
       LastHeight:=abs(CurrentFont.Height);
       PreFont:=false;
     end;

    if SameText(HTMLTag.Name,'A') then
     begin
      isLink:=true;
      Link:='';
      for j:= 0 to HTMLTag.Params.count - 1 do
       begin
        HTMLParam:=HTMLTag.Params[j];
        if SameText(HTMLParam.Key,'HREF') then Link:=HTMLParam.Value;
       end;
      end;

    if SameText(HTMLTag.Name,'/A') then isLink:=false;


     if SameText(HTMLTag.Name,'FONT') then
     begin
       OldFont.assign(CurrentFont);
       for j:= 0 to HTMLTag.Params.count -1 do
       begin
        HTMLParam:=HTMLTag.Params[j];
        if SameText(HTMLParam.Key,'FACE') then CurrentFont.Name:=HTMLParam.Value;
       end;
     end;

     if SameText(HTMLTag.Name,'/FONT') then
      begin
       CurrentFont.assign(OldFont);
      end;

    end;


   if obj.classtype=THTMLText then
   if not ignore then
    begin
     Label1:=TLabel.Create(Form2);
     Label1.Parent:=Form2;
     Label1.WordWrap:=true;
     Label1.Top:=y;
     Label1.Left:=x;
     Label1.Autosize:=false;
     Label1.Width:=Form2.ClientWidth-18;
     Label1.Caption:=THTMLText(obj).Text;
     Label1.Font.assign(CurrentFont);
     //label1.Color:=clgreen;

     if PreFont then
      begin
       Label1.FOnt.Name:='Courier';
       Label1.Font.Size:=10;
       Label1.Caption:=THTMLText(obj).Text;
       Label1.WordWrap:=false;
      end;

     if isLink then
      begin
       Label1.Font.Color:=clBlue;
       Label1.Font.Style:=[fsUnderline];
       Label1.OnClick:=LabelClick;
       Label1.Cursor:=crHandPoint;
       Label1.Hint:=Link;
      end;

     s:=Label1.Caption;
     (*while pos('&',s)>0 do s[pos('&',s)]:=#1;
     while pos(#1,s)>0 do begin
                           insert('&&',s,pos(#1,s));
                           delete(s,pos(#1,s),1);
                          end;*)
     Label1.Caption:=s;

     Label1.Autosize:=true;
     x:=x+Label1.Width;
     LastHeight:=Label1.Height;
    end
   else
   if isTitle then Form2.Caption:=THTMLText(obj).Text+' - ' + MiniHTMLViewer;;
  end;


 form2.updating:=false;
 form2.show;
end;

procedure TForm1.LabelClick(Sender:TObject);
begin
 ShowMessage('Linking to "'+TLabel(Sender).Hint+'"');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if HTMLParser <> nil then HTMLParser.Free;
end;

end.
