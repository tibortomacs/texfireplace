unit InstallRootUtils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function GetUninstallValueHKCU(const SubKey, ValueName: string; out Value: string): Boolean;
function ExtractFirstToken(const S: string): string;
function TokenLooksLikePath(const Token: string): Boolean;
function ExpandEnvVars(const S: string): string;
function GetInstallRootFromUninstallString(const UninstallString: string; ExpandEnvironment: Boolean = False): string;
function GetInstallRootFromRegistry(const SubKey: string; out Root: string;

ExpandEnvironment: Boolean = False; CheckExists: Boolean = False): Boolean;

implementation

uses
  Registry, Windows;

function GetUninstallValueHKCU(const SubKey, ValueName: string; out Value: string): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Value := '';
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly(SubKey) then
    begin
      if Reg.ValueExists(ValueName) then
      begin
        try
          Value := Reg.ReadString(ValueName);
          Result := True;
        except
          Result := False;
        end;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function ExtractFirstToken(const S: string): string;
var
  i, L: Integer;
begin
  Result := '';
  L := Length(S);
  i := 1;
  while (i <= L) and (S[i] <= ' ') do Inc(i);
  if i > L then Exit;
  if S[i] = '"' then
  begin
    Inc(i);
    while (i <= L) and (S[i] <> '"') do
    begin
      Result := Result + S[i];
      Inc(i);
    end;
  end
  else
  begin
    while (i <= L) and not (S[i] <= ' ') do
    begin
      Result := Result + S[i];
      Inc(i);
    end;
  end;
end;

function TokenLooksLikePath(const Token: string): Boolean;
begin
  Result := False;
  if Length(Token) >= 3 then
    if (UpCase(Token[1]) in ['A'..'Z']) and (Token[2] = ':') and ((Token[3] = '\') or (Token[3] = '/')) then
      Exit(True);
  if Length(Token) >= 2 then
    if Copy(Token, 1, 2) = '\\' then
      Exit(True);
end;

function ExpandEnvVars(const S: string): string;
var
  Need: DWORD;
  Buf: PChar;
begin
  Result := S;
  if S = '' then Exit;
  Need := ExpandEnvironmentStrings(PChar(S), nil, 0);
  if Need = 0 then Exit;
  GetMem(Buf, Need * SizeOf(Char));
  try
    if ExpandEnvironmentStrings(PChar(S), Buf, Need) <> 0 then
      Result := StrPas(Buf);
  finally
    FreeMem(Buf);
  end;
end;

function GetInstallRootFromUninstallString(const UninstallString: string; ExpandEnvironment: Boolean = False): string;
var
  token, maybeDir: string;
begin
  Result := '';
  if UninstallString = '' then Exit;
  token := ExtractFirstToken(UninstallString);
  if token = '' then Exit;

  if ExpandEnvironment then
    token := ExpandEnvVars(token);

  if TokenLooksLikePath(token) then
  begin
    maybeDir := ExtractFilePath(token);
    if maybeDir = '' then
      Result := token
    else
      Result := maybeDir;
  end
  else
    Result := token;
end;

function GetInstallRootFromRegistry(const SubKey: string; out Root: string;
  ExpandEnvironment: Boolean = False; CheckExists: Boolean = False): Boolean;
var
  val: string;
  tmp: string;
begin
  Root := '';
  Result := False;
  if not GetUninstallValueHKCU(SubKey, 'UninstallString', val) then Exit;
  tmp := GetInstallRootFromUninstallString(val, ExpandEnvironment);
  if tmp = '' then Exit;
  if TokenLooksLikePath(tmp) then
  begin
    if (tmp[Length(tmp)] <> '\') and (tmp[Length(tmp)] <> '/') then tmp := tmp;
  end;
  if CheckExists and TokenLooksLikePath(tmp) then
  begin
    if not DirectoryExists(tmp) then Exit(False);
  end;
  Root := tmp;
  Result := True;
end;

end.
