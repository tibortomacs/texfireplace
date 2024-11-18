unit install;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Process, FileUtil;

type

  { TFormInstall }

  TFormInstall = class(TForm)
    ButtonInstall: TButton;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    CheckBoxTexstudio: TCheckBox;
    CheckBoxMiktex: TCheckBox;
    CheckBoxPython: TCheckBox;
    ImageCheckPython: TImage;
    ImageCheckTexstudio: TImage;
    ImageCheckRemove: TImage;
    ImageCheckMiktex: TImage;
    ImageCheckPerl: TImage;
    ImageCheckCompletion: TImage;
    ImageWelcome: TImage;
    LabelCompletion: TLabel;
    LabelTexstudio: TLabel;
    LabelPython: TLabel;
    LabelPerl: TLabel;
    LabelMiktex: TLabel;
    LabelRemove: TLabel;
    LabelClick: TLabel;
    LabelInstall: TLabel;
    LabelSetup: TLabel;
    LabelWelcome: TLabel;
    MemoWelcome: TMemo;
    NotebookInstall: TNotebook;
    PageInstall: TPage;
    PageSetup: TPage;
    PageWelcome: TPage;
    ProgressBarInstall: TProgressBar;
    RadioButtonReg: TRadioButton;
    RadioButtonTxsvbs: TRadioButton;
    RadioButtonTxsini: TRadioButton;
    RadioButtonStrawberry: TRadioButton;
    RadioButtonTlperl: TRadioButton;
    RadioGroupPath: TRadioGroup;
    RadioGroupPerl: TRadioGroup;
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonInstallClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure CheckBoxMiktexClick(Sender: TObject);
    procedure CheckBoxTexstudioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

  public

  end;

var
  FormInstall: TFormInstall;

implementation

{$R *.lfm}

{ TFormInstall }

// -----------------------------------------------------
// FORM ACTIVATE
// -----------------------------------------------------

procedure TFormInstall.FormActivate(Sender: TObject);
begin
  FormInstall.ActiveControl := ButtonNext;
  ButtonInstall.Left := ButtonNext.Left;

  if (FindDefaultExecutablePath('perl.exe') <> '') and (Pos('texfireplace',LowerCase(FindDefaultExecutablePath('perl.exe'))) = 0) then begin
    RadioGroupPerl.Enabled := false;
    RadioButtonTlperl.Checked := false;
    RadioButtonStrawberry.Checked := false;
    RadioGroupPerl.Hint := RadioGroupPerl.Hint + #10 + StringReplace(FindDefaultExecutablePath('perl.exe'),'\perl.exe','',[rfReplaceAll]);
    RadioGroupPerl.ShowHint := true;
  end;

  if (FindDefaultExecutablePath('python.exe') <> '') and (Pos('texfireplace',LowerCase(FindDefaultExecutablePath('python.exe'))) = 0) then begin
    CheckBoxPython.Enabled := false;
    CheckBoxPython.Checked := false;
    CheckBoxPython.Hint := CheckBoxPython.Hint + #10 + StringReplace(FindDefaultExecutablePath('python.exe'),'\python.exe','',[rfReplaceAll]);
    CheckBoxPython.ShowHint := true;
  end;

  if (FindDefaultExecutablePath('pdflatex.exe') <> '') and (Pos('texfireplace',LowerCase(FindDefaultExecutablePath('pdflatex.exe'))) = 0) then begin
    RadioButtonTxsini.Checked := false;
    RadioButtonTxsvbs.Checked := true;
    RadioButtonReg.Checked := false;
    RadioButtonTxsini.Enabled := false;
    RadioButtonReg.Enabled := false;
    RadioGroupPath.Hint := RadioGroupPath.Hint + #10 + StringReplace(FindDefaultExecutablePath('pdflatex.exe'),'\pdflatex.exe','',[rfReplaceAll]);
    RadioGroupPath.ShowHint := true;
  end;
end;

// -----------------------------------------------------
// CLOSE QUERY
// -----------------------------------------------------

procedure TFormInstall.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not ButtonCancel.Enabled then CanClose := false;
  if (ButtonCancel.Caption = 'Cancel') and (MessageDlg('Are you sure you want to quit the TeXfireplace installer?',mtWarning,[mbYes,mbNo],0) = mrNo) then CanClose := false;
end;

// -----------------------------------------------------
// CANCEL BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonCancelClick(Sender: TObject);
begin
  close;
end;

// -----------------------------------------------------
// BACK BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonBackClick(Sender: TObject);
begin
  NotebookInstall.PageIndex := NotebookInstall.PageIndex - 1;
  if NotebookInstall.PageIndex = 0 then ButtonBack.Visible := false;
  if NotebookInstall.PageIndex = 1 then begin
    ButtonInstall.Visible := false;
    ButtonNext.Visible := true;
    FormInstall.ActiveControl := ButtonNext;
  end;
end;

// -----------------------------------------------------
// NEXT BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonNextClick(Sender: TObject);
begin
  NotebookInstall.PageIndex := NotebookInstall.PageIndex + 1;
  if NotebookInstall.PageIndex = 1 then ButtonBack.Visible := true;
  if NotebookInstall.PageIndex = 2 then begin
    ButtonNext.Visible := false;
    ButtonInstall.Visible := true;
    FormInstall.ActiveControl := ButtonInstall;
  end;
end;

// -----------------------------------------------------
// MIKTEX CHECKBOX CLICK
// -----------------------------------------------------

procedure TFormInstall.CheckBoxMiktexClick(Sender: TObject);
begin
  CheckBoxMiktex.Checked := true;
end;

// -----------------------------------------------------
// TEXSTUDIO CHECKBOX CLICK
// -----------------------------------------------------

procedure TFormInstall.CheckBoxTexstudioClick(Sender: TObject);
begin
  CheckBoxTexstudio.Checked := true;
end;

// -----------------------------------------------------
// INSTALL BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonInstallClick(Sender: TObject);
var
  perl, python, path: string;
  f: text;
  ProcessDownload, ProcessInstall, ProcessViewLog: TProcess;
  topcoord: integer = 115;
  diff: integer = 25;
begin
  if DirectoryExists(GetEnvironmentVariable('LOCALAPPDATA') + '\TeXfireplace') and
     (MessageDlg('TeXfireplace is already installed. Are you sure you want to reinstall it?',mtWarning,[mbYes,mbNo],0) = mrNo) then Halt;

  ButtonBack.Visible := false;
  ButtonInstall.Visible := false;
  ButtonCancel.Enabled := false;
  ButtonCancel.Caption := 'Close';
  LabelClick.Caption := 'Please be patient while the installation of TeXfireplace is in progress.';
  if RadioButtonTlperl.Checked then LabelPerl.Caption := 'TLPerl' else LabelPerl.Caption := 'Strawberry Perl';

  python := 'no';
  if CheckBoxPython.Checked then python := 'yes';
  perl := 'no';
  if RadioButtonTlperl.Checked then perl := 'tlperl';
  if RadioButtonStrawberry.Checked then perl := 'strawberry';
  path := 'txsini';
  if RadioButtonTxsvbs.Checked then path := 'txsvbs';
  if RadioButtonReg.Checked then path := 'reg';

  ProcessDownload := TProcess.Create(nil);
  try
    ProcessDownload.InheritHandles := false;
    ProcessDownload.ShowWindow := swoHide;
    ProcessDownload.Executable := 'cmd.exe';
    ProcessDownload.Parameters.Add('/c');
    ProcessDownload.Parameters.Add('curl -s -f -L -o texfireplaceinstall.bat --output-dir "%temp%" https://tibortomacs.github.io/texfireplace/texfireplaceinstall.bat');
    ProcessDownload.Execute;
    ProcessDownload.WaitOnExit;
  finally
    ProcessDownload.Free;
  end;

  if not FileExists(GetTempDir + 'texfireplaceinstall.bat') then begin
    assignfile(f,GetTempDir + 'texfireplaceinstall.bat');
    rewrite(f);
    writeln(f,'echo ERROR: %temp%\texfireplaceinstall.bat > "%temp%\texfireplaceinstall.log"');
    writeln(f,'exit /b 1');
    closefile(f);
  end;

  ProcessInstall := TProcess.Create(nil);
  try
    ProcessInstall.InheritHandles := false;
    ProcessInstall.ShowWindow := swoHide;
    ProcessInstall.Executable := 'cmd.exe';
    ProcessInstall.Parameters.Add('/c');
    ProcessInstall.Parameters.Add('"' + GetTempDir + 'texfireplaceinstall.bat"');
    ProcessInstall.Parameters.Add(perl);
    ProcessInstall.Parameters.Add(python);
    ProcessInstall.Parameters.Add(path);
    ProcessInstall.Execute;

    while ProcessInstall.Running do begin
      if FileExists(GetTempDir + 'texfireplaceinstall-remove.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-remove.txt');
        topcoord := topcoord + diff;
        LabelRemove.Top := topcoord;
        LabelRemove.Visible := true;
        ProgressBarInstall.Top := topcoord;
        ProgressBarInstall.Visible := true;
      end;

      if FileExists(GetTempDir + 'texfireplaceinstall-miktex.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-miktex.txt');
        if LabelRemove.Visible then begin
          ImageCheckRemove.Top := topcoord;
          ImageCheckRemove.Visible := true;
        end;
        topcoord := topcoord + diff;
        LabelMiktex.Top := topcoord;
        LabelMiktex.Visible := true;
        ProgressBarInstall.Top := topcoord;
        ProgressBarInstall.Visible := true;
      end;

      if FileExists(GetTempDir + 'texfireplaceinstall-perl.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-perl.txt');
        ImageCheckMiktex.Top := topcoord;
        ImageCheckMiktex.Visible := true;
        topcoord := topcoord + diff;
        LabelPerl.Top := topcoord;
        LabelPerl.Visible := true;
        ProgressBarInstall.Top := topcoord;
      end;

      if FileExists(GetTempDir + 'texfireplaceinstall-python.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-python.txt');
        ImageCheckPerl.Top := topcoord;
        ImageCheckPerl.Visible := true;
        topcoord := topcoord + diff;
        LabelPython.Top := topcoord;
        LabelPython.Visible := true;
        ProgressBarInstall.Top := topcoord;
      end;

      if FileExists(GetTempDir + 'texfireplaceinstall-texstudio.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-texstudio.txt');
        if LabelPython.Visible then begin
          ImageCheckPython.Top := topcoord;
          ImageCheckPython.Visible := true;
        end
        else begin
          ImageCheckPerl.Top := topcoord;
          ImageCheckPerl.Visible := true;
        end;
        topcoord := topcoord + diff;
        LabelTexstudio.Top := topcoord;
        LabelTexstudio.Visible := true;
        ProgressBarInstall.Top := topcoord;
      end;

      if FileExists(GetTempDir + 'texfireplaceinstall-completion.txt') then begin
        DeleteFile(GetTempDir + 'texfireplaceinstall-completion.txt');
        ImageCheckTexstudio.Top := topcoord;
        ImageCheckTexstudio.Visible := true;
        topcoord := topcoord + diff;
        LabelCompletion.Top := topcoord;
        LabelCompletion.Visible := true;
        ProgressBarInstall.Top := topcoord;
      end;

      sleep(50);
      Application.ProcessMessages;
    end;

    ProcessInstall.WaitOnExit;
    ProgressBarInstall.Visible := false;
    LabelClick.Visible := false;

    if ProcessInstall.ExitStatus = 1 then begin
      LabelInstall.Caption := 'TeXfireplace installation failed!';
      ProcessViewLog := TProcess.Create(nil);
      try
        ProcessViewLog.Executable := 'notepad.exe';
        ProcessViewLog.Parameters.Add('"' + GetTempDir + 'texfireplaceinstall.log"');
        ProcessViewLog.Execute;
      finally
        ProcessViewLog.Free;
      end;
    end
    else begin
      ImageCheckCompletion.Top := topcoord;
      ImageCheckCompletion.Visible := true;
      LabelInstall.Caption := 'TeXfireplace installation completed successfully!';
    end;

  finally
    ProcessInstall.Free;
  end;

  DeleteFile(GetTempDir + 'texfireplaceinstall.bat');
  ButtonCancel.Enabled := true;
end;

end.
