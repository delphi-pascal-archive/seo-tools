unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    procedure FormResize(Sender: TObject);
  private
  public
    updating:boolean;
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm2.FormResize(Sender: TObject);
begin
 if not updating then
  Form1.Button2Click(Sender);
end;

end.
 