program Intelis_Necessary_Tools;

uses
  Forms,
  dist_list in 'dist_list.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
