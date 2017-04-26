program Rainhas;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frRainhas},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '8 Rainhas';
  Application.CreateForm(TfrRainhas, frRainhas);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
