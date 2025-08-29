unit install;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Process, FileUtil, InstallRootUtils;

type

  { TFormInstall }

  TFormInstall = class(TForm)
    ButtonPortableDirSel: TButton;
    ButtonInfo: TButton;
    ButtonInstall: TButton;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    ButtonNext: TButton;
    CheckBoxPortable: TCheckBox;
    CheckBoxTexstudio: TCheckBox;
    CheckBoxMiktex: TCheckBox;
    CheckBoxPython: TCheckBox;
    PortableDir: TEdit;
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
    SelectPortableDirectoryDialog: TSelectDirectoryDialog;
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonInfoClick(Sender: TObject);
    procedure ButtonPortableDirSelClick(Sender: TObject);
    procedure ButtonInstallClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure CheckBoxMiktexClick(Sender: TObject);
    procedure CheckBoxPortableClick(Sender: TObject);
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
  TempDir, InstallDir, PreviousInstallDir: string;

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

  TempDir := IncludeTrailingPathDelimiter(GetTempDir);
  InstallDir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('LOCALAPPDATA')) + 'TeXfireplace';

  GetInstallRootFromRegistry('Software\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace', PreviousInstallDir, True, True);
  if PreviousInstallDir = '' then GetInstallRootFromRegistry('Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace', PreviousInstallDir, True, True);
  if PreviousInstallDir <> '' then PreviousInstallDir := IncludeTrailingPathDelimiter(PreviousInstallDir);

  PortableDir.Text := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) + 'Documents';
  SelectPortableDirectoryDialog.InitialDir := PortableDir.Text;

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
// PORTABLE CHECKBOX CLICK
// -----------------------------------------------------

procedure TFormInstall.CheckBoxPortableClick(Sender: TObject);
begin
  if CheckBoxPortable.Checked then begin
    PortableDir.Visible := true;
    ButtonPortableDirSel.Visible := true;
    ButtonInfo.Visible := false;
    RadioGroupPath.Visible := false;
  end
  else begin
    PortableDir.Visible := false;
    ButtonPortableDirSel.Visible := false;
    RadioGroupPath.Visible := true;
    if (InfoPerl + InfoTex = '') and ((not CheckBoxPython.Checked) or (InfoPython = '')) then begin
      RadioButtonTxsini.Enabled := true;
      RadioButtonReg.Enabled := true;
      ButtonInfo.Visible := false;
    end
    else begin
      RadioButtonTxsini.Checked := false;
      RadioButtonTxsvbs.Checked := true;
      RadioButtonReg.Checked := false;
      RadioButtonTxsini.Enabled := false;
      RadioButtonReg.Enabled := false;
      ButtonInfo.Visible := true;
    end;
  end;
end;

// -----------------------------------------------------
// PORTABLE DIR SELECTION CLICK
// -----------------------------------------------------

procedure TFormInstall.ButtonPortableDirSelClick(Sender: TObject);
begin
  if SelectPortableDirectoryDialog.Execute then PortableDir.Text := SelectPortableDirectoryDialog.FileName;
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
    if not CheckBoxPortable.Checked then ButtonInfo.Visible := true;
  end;
end;

// -----------------------------------------------------
// INFO BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonInfoClick(Sender: TObject);
var
  Info: string = '';
begin
  if InfoTex <> '' then Info := Info + InfoTex + #10#10;
  if (InfoPython <> '') and  CheckBoxPython.Checked then Info := Info + InfoPython + #10#10;
  if InfoPerl <> '' then Info := Info + InfoPerl + #10#10;
  if InfoPath <> '' then Info := Info + InfoPath;
  MessageDlg(Info,mtInformation,[mbOk],0)
end;

// -----------------------------------------------------
// INSTALL BUTTON
// -----------------------------------------------------

procedure TFormInstall.ButtonInstallClick(Sender: TObject);
var
  perlsystem, python, writepathin, portable: string;
  ProcessInstall, ProcessViewLog: TProcess;
  topcoord: integer = 115;
  diff: integer = 25;
begin
  perlsystem := 'tlperl';
  if RadioButtonStrawberry.Checked then perlsystem := 'strawberry';
  python := 'no';
  if CheckBoxPython.Checked then python := 'yes';
  writepathin := 'txsini';
  if RadioButtonTxsvbs.Checked then writepathin := 'txsvbs';
  if RadioButtonReg.Checked then writepathin := 'reg';
  portable := 'no';
  if CheckBoxPortable.Checked then begin
    portable := PortableDir.Text;
    while (portable <> '') and (portable[Length(portable)] = '\') do Delete(portable, Length(portable), 1);
    if not DirectoryExists(portable) then begin
      MessageDlg('The specified directory for the portable version does not exist: ' + portable,mtWarning,[mbOk],0);
      Exit;
    end;
    if DirectoryExists(portable + '\TeXfireplacePortable') then begin
      MessageDlg('The specified directory for the portable version already contains a TeXfireplacePortable subdirectory. Please choose another one!',mtWarning,[mbOk],0);
      Exit;
    end;
  end;

  if (PreviousInstallDir <> '') and (not CheckBoxPortable.Checked) and
     (MessageDlg('TeXfireplace is already installed:' + #10 + PreviousInstallDir + #10#10 + 'Are you sure you want to reinstall it?',mtWarning,[mbYes,mbNo],0) = mrNo) then Halt;

  ButtonBack.Visible := false;
  ButtonInstall.Visible := false;
  ButtonCancel.Enabled := false;
  ButtonCancel.Caption := 'Close';
  LabelClick.Caption := 'Please be patient while the installation of TeXfireplace is in progress.';
  if RadioButtonTlperl.Checked then LabelPerl.Caption := 'TLPerl' else LabelPerl.Caption := 'Strawberry Perl';

  if (PreviousInstallDir <> '') and (not CheckBoxPortable.Checked) then begin
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
      MemoInstallBat.Lines.SaveToFile(TempDir + 'texfireplaceinstall.bat');
      MemoTexstudioIni.Lines.SaveToFile(TempDir + 'texstudio.ini');

      ProcessInstall.InheritHandles := false;
      ProcessInstall.ShowWindow := swoHide;
      ProcessInstall.Executable := 'cmd.exe';
      ProcessInstall.Parameters.Add('/c');
      ProcessInstall.Parameters.Add(TempDir + 'texfireplaceinstall.bat');
      ProcessInstall.Parameters.Add(perlsystem);
      ProcessInstall.Parameters.Add(python);
      ProcessInstall.Parameters.Add(writepathin);
      ProcessInstall.Parameters.Add(portable);
      ProcessInstall.Parameters.Add(PreviousInstallDir);
      ProcessInstall.Execute;

      while ProcessInstall.Running do begin
        if FileExists(TempDir + 'texfireplaceinstall-remove.txt') and (ImageArrow.Top < LabelRemove.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-remove.txt');
          ImageArrow.Top := LabelRemove.Top;
          ImageArrow.Visible := true;
          ImageArrow.Update;
        end;

        if FileExists(TempDir + 'texfireplaceinstall-miktex.txt') and (ImageArrow.Top < LabelMiktex.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-miktex.txt');
          ImageArrow.Top := LabelMiktex.Top;
          if LabelRemove.Visible then begin
            ImageCheckRemove.Visible := true;
            ImageCheckRemove.Update;
          end
          else begin
            ImageArrow.Visible := true;
            ImageArrow.Update;
          end;
        end;

        if FileExists(TempDir + 'texfireplaceinstall-perl.txt') and (ImageArrow.Top < LabelPerl.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-perl.txt');
          ImageArrow.Top := LabelPerl.Top;
          ImageArrow.Update;
          ImageCheckMiktex.Visible := true;
          ImageCheckMiktex.Update;
        end;

        if FileExists(TempDir + 'texfireplaceinstall-python.txt') and (ImageArrow.Top < LabelPython.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-python.txt');
          ImageArrow.Top := LabelPython.Top;
          ImageArrow.Update;
          ImageCheckPerl.Visible := true;
          ImageCheckPerl.Update;
        end;

        if FileExists(TempDir + 'texfireplaceinstall-texstudio.txt') and (ImageArrow.Top < LabelTexstudio.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-texstudio.txt');
          ImageArrow.Top := LabelTexstudio.Top;
          ImageArrow.Update;
          if LabelPython.Visible then ImageCheckPython.Visible := true else ImageCheckPerl.Visible := true;
          ImageCheckPerl.Update;
          ImageCheckPython.Update;
        end;

        if FileExists(TempDir + 'texfireplaceinstall-completion.txt') and (ImageArrow.Top < LabelCompletion.Top) then begin
          DeleteFile(TempDir + 'texfireplaceinstall-completion.txt');
          ImageArrow.Top := LabelCompletion.Top;
          ImageArrow.Update;
          ImageCheckTexstudio.Visible := true;
          ImageCheckTexstudio.Update;
        end;

        sleep(100);
        Application.ProcessMessages;
      end;

      ProcessInstall.WaitOnExit;
      ProgressBarInstall.Visible := false;
      ImageArrow.Visible := false;
      ImageArrow.Update;

      if ProcessInstall.ExitStatus <> 0 then begin
        LabelInstall.Caption := 'TeXfireplace installation failed!';
        LabelClick.Visible := false;
        ProcessViewLog := TProcess.Create(nil);
        if FileExists(TempDir + 'texfireplaceinstall.log') then begin
          try
            ProcessViewLog.Executable := 'notepad.exe';
            ProcessViewLog.Parameters.Add(TempDir + 'texfireplaceinstall.log');
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
        ImageCheckCompletion.Update;
        LabelInstall.Caption := 'TeXfireplace installation completed successfully!';
        if CheckBoxPortable.Checked then LabelClick.Caption := 'Run the texstudio.vbs and happy LaTeXing!' else LabelClick.Caption := 'Run the TeXstudio and happy LaTeXing!';
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

  DeleteFile(TempDir + 'texfireplaceinstall.bat');
  if FileExists(TempDir + 'texstudio.ini') then DeleteFile(TempDir + 'texstudio.ini');
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
