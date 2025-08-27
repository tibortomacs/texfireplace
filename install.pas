unit install;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Process, FileUtil;

type

  { TFormInstall }

  TFormInstall = class(TForm)
    ButtonInfo: TButton;
    ButtonInstall: TButton;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    CheckBoxTexstudio: TCheckBox;
    CheckBoxMiktex: TCheckBox;
    CheckBoxPython: TCheckBox;
    ImageArrow: TImage;
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
    MemoTexstudioIni: TMemo;
    MemoInstallBat: TMemo;
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
    Background: TShape;
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonInfoClick(Sender: TObject);
    procedure ButtonInstallClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure CheckBoxMiktexClick(Sender: TObject);
    procedure CheckBoxPythonClick(Sender: TObject);
    procedure CheckBoxTexstudioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function AnotherInstanceIsRunning: Boolean;
  private

  public

  end;

var
  FormInstall: TFormInstall;
  InfoPerl: string = '';
  InfoPython: string = '';
  InfoTex: string = '';
  InfoPath: string = '';

implementation

{$R *.lfm}

{ TFormInstall }

// -----------------------------------------------------
// FORM ACTIVATE
// -----------------------------------------------------

procedure TFormInstall.FormActivate(Sender: TObject);
var
  progpath: string;
begin
  if AnotherInstanceIsRunning then begin
    MessageDlg('Another instance of TeXfireplace installer is running!',mtWarning,[mbOk],0);
    Halt;
  end;

  ImageCheckMiktex.Picture.Assign(ImageCheckRemove.Picture);
  ImageCheckPerl.Picture.Assign(ImageCheckRemove.Picture);
  ImageCheckPython.Picture.Assign(ImageCheckRemove.Picture);
  ImageCheckTexstudio.Picture.Assign(ImageCheckRemove.Picture);
  ImageCheckCompletion.Picture.Assign(ImageCheckRemove.Picture);

  FormInstall.ActiveControl := ButtonNext;
  ButtonInstall.Left := ButtonNext.Left;

  progpath := FindDefaultExecutablePath('perl.exe');
  if (progpath <> '') and (Pos('texfireplace',LowerCase(progpath)) = 0) and (FileSize(progpath) <> 0) then begin
    InfoPerl := 'Perl is already installed.' + #10 + StringReplace(progpath,'\perl.exe','',[rfReplaceAll]);
    ButtonInfo.Visible := true;
  end;

  progpath := FindDefaultExecutablePath('python.exe');
  if (progpath <> '') and (Pos('texfireplace',LowerCase(progpath)) = 0) and (FileSize(progpath) <> 0) then begin
    InfoPython := 'Python is already installed.' + #10 + StringReplace(progpath,'\python.exe','',[rfReplaceAll]);
    ButtonInfo.Visible := true;
  end;

  progpath := FindDefaultExecutablePath('pdflatex.exe');
  if (progpath <> '') and (Pos('texfireplace',LowerCase(progpath)) = 0) and (FileSize(progpath) <> 0) then begin
    InfoTex := 'TeX-system is already installed.' + #10 + StringReplace(progpath,'\pdflatex.exe','',[rfReplaceAll]);
    ButtonInfo.Visible := true;
  end;

  if ButtonInfo.Visible then begin
    RadioButtonTxsini.Checked := false;
    RadioButtonTxsvbs.Checked := true;
    RadioButtonReg.Checked := false;
    RadioButtonTxsini.Enabled := false;
    RadioButtonReg.Enabled := false;
    InfoPath := 'The PATH can only be written to the texstudio.vbs.';
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
// PYTHON CHECKBOX CLICK
// -----------------------------------------------------

procedure TFormInstall.CheckBoxPythonClick(Sender: TObject);
begin
  if (not CheckBoxPython.Checked) and
     (MessageDlg('Are you sure you will never use the minted package?',mtConfirmation,[mbYes,mbNo],0) = mrNo) then CheckBoxPython.Checked := true;

  if (not CheckBoxPython.Checked) and (InfoPerl + InfoTex = '') then begin
    RadioButtonTxsini.Enabled := true;
    RadioButtonReg.Enabled := true;
    ButtonInfo.Visible := false;
  end;

  if CheckBoxPython.Checked and (InfoPython <> '') then begin
    RadioButtonTxsini.Checked := false;
    RadioButtonTxsvbs.Checked := true;
    RadioButtonReg.Checked := false;
    RadioButtonTxsini.Enabled := false;
    RadioButtonReg.Enabled := false;
    ButtonInfo.Visible := true;
  end;
end;

// -----------------------------------------------------
// INFO BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonInfoClick(Sender: TObject);
var
  Info: string = '';
begin
  if InfoTex <> '' then Info := Info + InfoTex + #10 + #10;
  if (InfoPython <> '') and  CheckBoxPython.Checked then Info := Info + InfoPython + #10 + #10;
  if InfoPerl <> '' then Info := Info + InfoPerl + #10 + #10;
  if InfoPath <> '' then Info := Info + InfoPath;
  MessageDlg(Info,mtInformation,[mbOk],0)
end;

// -----------------------------------------------------
// INSTALL BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonInstallClick(Sender: TObject);
var
  perl, python, path: string;
  ProcessInstall, ProcessViewLog: TProcess;
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

  if DirectoryExists(GetEnvironmentVariable('LOCALAPPDATA') + '\TeXfireplace') then begin
    topcoord := topcoord + diff;
    LabelRemove.Top := topcoord;
    LabelRemove.Visible := true;
    ImageCheckRemove.Top := topcoord;
  end;

  topcoord := topcoord + diff;
  LabelMiktex.Top := topcoord;
  LabelMiktex.Visible := true;
  ImageCheckMiktex.Top := topcoord;

  topcoord := topcoord + diff;
  LabelPerl.Top := topcoord;
  LabelPerl.Visible := true;
  ImageCheckPerl.Top := topcoord;

  if CheckBoxPython.Checked then begin
    topcoord := topcoord + diff;
    LabelPython.Top := topcoord;
    LabelPython.Visible := true;
    ImageCheckPython.Top := topcoord;
  end;

  topcoord := topcoord + diff;
  LabelTexstudio.Top := topcoord;
  LabelTexstudio.Visible := true;
  ImageCheckTexstudio.Top := topcoord;

  topcoord := topcoord + diff;
  LabelCompletion.Top := topcoord;
  LabelCompletion.Visible := true;
  ImageCheckCompletion.Top := topcoord;

  ProgressBarInstall.Visible := true;

  ProcessInstall := TProcess.Create(nil);
  try
    try
      MemoInstallBat.Lines.SaveToFile(GetTempDir + 'texfireplaceinstall.bat');
      MemoTexstudioIni.Lines.SaveToFile(GetTempDir + 'texstudio.ini');

      ProcessInstall.InheritHandles := false;
      ProcessInstall.ShowWindow := swoHide;
      ProcessInstall.Executable := 'cmd.exe';
      ProcessInstall.Parameters.Add('/c');
      ProcessInstall.Parameters.Add('"' + GetTempDir + 'texfireplaceinstall.bat"');
      ProcessInstall.Parameters.Add(perl);
      ProcessInstall.Parameters.Add(python);
      ProcessInstall.Parameters.Add(path);
      ProcessInstall.Execute;

      topcoord := 115;

      while ProcessInstall.Running do begin
        if FileExists(GetTempDir + 'texfireplaceinstall-remove.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-remove.txt');
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
          ImageArrow.Visible := true;
        end;

        if FileExists(GetTempDir + 'texfireplaceinstall-miktex.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-miktex.txt');
          if LabelRemove.Visible then ImageCheckRemove.Visible := true;
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
          ImageArrow.Visible := true;
        end;

        if FileExists(GetTempDir + 'texfireplaceinstall-perl.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-perl.txt');
          ImageCheckMiktex.Visible := true;
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
        end;

        if FileExists(GetTempDir + 'texfireplaceinstall-python.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-python.txt');
          ImageCheckPerl.Visible := true;
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
        end;

        if FileExists(GetTempDir + 'texfireplaceinstall-texstudio.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-texstudio.txt');
          if LabelPython.Visible then ImageCheckPython.Visible := true else ImageCheckPerl.Visible := true;
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
        end;

        if FileExists(GetTempDir + 'texfireplaceinstall-completion.txt') then begin
          DeleteFile(GetTempDir + 'texfireplaceinstall-completion.txt');
          ImageCheckTexstudio.Visible := true;
          topcoord := topcoord + diff;
          ImageArrow.Top := topcoord;
        end;

        sleep(50);
        Application.ProcessMessages;
      end;

      ProcessInstall.WaitOnExit;
      ProgressBarInstall.Visible := false;
      ImageArrow.Visible := false;

      if ProcessInstall.ExitStatus <> 0 then begin
        LabelInstall.Caption := 'TeXfireplace installation failed!';
        LabelClick.Visible := false;
        ProcessViewLog := TProcess.Create(nil);
        if FileExists(GetTempDir + 'texfireplaceinstall.log') then begin
          try
            ProcessViewLog.Executable := 'notepad.exe';
            ProcessViewLog.Parameters.Add('"' + GetTempDir + 'texfireplaceinstall.log"');
            ProcessViewLog.Execute;
          finally
            ProcessViewLog.Free;
          end;
        end
        else begin
          MessageDlg('There is no log file for an unknown reason!',mtError,[mbOk],0);
        end;
      end
      else begin
        ImageCheckCompletion.Visible := true;
        LabelInstall.Caption := 'TeXfireplace installation completed successfully!';
        LabelClick.Caption := 'Run the TeXstudio and happy LaTeXing!';
      end;

    except
      on E: Exception do
      begin
        LabelInstall.Caption := 'TeXfireplace installation failed!';
        ProgressBarInstall.Visible := false;
        ImageArrow.Visible := false;
        LabelClick.Visible := false;
        MessageDlg(E.Message,mtError,[mbOk],0);
      end;
    end;

  finally
    ProcessInstall.Free;
  end;

  DeleteFile(GetTempDir + 'texfireplaceinstall.bat');
  if FileExists(GetTempDir + 'texstudio.ini') then DeleteFile(GetTempDir + 'texstudio.ini');
  ButtonCancel.Enabled := true;
end;

// -----------------------------------------------------
// ANOTHER INSTANCE IS RUNNING
// -----------------------------------------------------

function TFormInstall.AnotherInstanceIsRunning: Boolean;
var
  SL: TStringList;
  i,j: Integer;
  outStr: AnsiString;
begin
  Result := false;
  j := 0;
  SL := TStringList.Create;
  try
    if RunCommand('tasklist', ['/FI', 'IMAGENAME eq texfireplace.exe', '/NH'], outStr, [poNoConsole, poUsePipes]) then begin
      SL.Text := string(outStr);
      for i := 0 to SL.Count - 1 do begin
        if Pos('texfireplace.exe', LowerCase(SL[i])) > 0 then j := j + 1;
        if j = 2 then begin Result := true; Break; end;
      end;
    end;
  finally
    SL.Free;
  end;
end;

end.
