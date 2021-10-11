unit webbrowser_functs;

interface

uses
  Classes, SHDocVw, MSHTML_TLB, ActiveX; 

  procedure SearchAndHighlightText(aText: string);
  procedure WB_SearchAndHighlightText(WB: TWebbrowser; aText: string);

  function WB_GetHTMLCode(WebBrowser: TWebBrowser; ACode: TStrings): Boolean;

implementation

uses dist_list;

procedure SearchAndHighlightText(aText: string);
var
 i: integer;
begin
 for i:=0 to Form1.WebBrowser1.OleObject.Document.All.Length-1 do
  begin
   if pos(aText, Form1.WebBrowser1.OleObject.Document.All.Item(i).InnerText)<>0
   then
    begin
     Form1.WebBrowser1.OleObject.Document.All.Item(i).Style.Color:='#FFFF00';
     Form1.WebBrowser1.OleObject.Document.All.Item(i).ScrollIntoView(true);
    end;
  end;
end;

procedure WB_SearchAndHighlightText(WB: TWebbrowser; aText: string);
var
 tr: IHTMLTxtRange; // TextRange Object
begin
 if not (WB.Busy) and (WB.Document<>nil)
 then
  begin
   if Length(aText)>0
   then
    begin
     tr:=((WB.Document as IHTMLDocument2).Body as IHTMLBodyElement).CreateTextRange;
     // Get a body with IHTMLDocument2 Interface and then a TextRang obj. with IHTMLBodyElement Intf.
     while tr.findText(aText, 1, 0) do // while we have result
      begin
       tr.pasteHTML('<span style="background-color: yellow; font-weight: bolder;">' +
       tr.htmlText+'</span>');
       // Set the highlight, now background color will be yellow
       // tr.scrollIntoView(True);
      end;
    end;
  end;
end;

function WB_GetHTMLCode(WebBrowser: TWebBrowser; ACode: TStrings): Boolean;
var
 s: string;
 sa: IStream;
 ss: TStringStream;
 ps: IPersistStreamInit;
begin
 ps:=WebBrowser.Document as IPersistStreamInit;
 s:='';
 ss:=TStringStream.Create(s);
 try
  sa:=TStreamAdapter.Create(ss, soReference) as IStream;
  Result:=Succeeded(ps.Save(sa, True));
  if Result
  then ACode.Add(ss.Datastring);
 finally
  ss.Free;
 end;
end;

end.
