program texfireplace;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, install
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Install TeXfireplace';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormInstall, FormInstall);
  Application.Run;
end.

