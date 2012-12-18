program HtmlDemo;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  HtmlCtrl in 'HtmlCtrl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
