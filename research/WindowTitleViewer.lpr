program WindowTitleViewer;

{$mode objfpc}{$H+}

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils;

var
  CurrentWindowTitle: string;

{$IFDEF WINDOWS}
function GetActiveWindowTitle: string;
var
  ActiveWindowHandle: HWND;
  TitleLength: Integer;
begin
  Result := '';
  ActiveWindowHandle := GetForegroundWindow;
  if ActiveWindowHandle <> 0 then
  begin
    TitleLength := GetWindowTextLength(ActiveWindowHandle);
    SetLength(Result, TitleLength);
    GetWindowText(ActiveWindowHandle, PChar(Result), TitleLength + 1);
  end;
end;
{$ENDIF}

procedure UpdateWindowTitle;
begin
  {$IFDEF WINDOWS}
  CurrentWindowTitle := GetActiveWindowTitle;
  {$ENDIF}
end;

begin
  repeat
    UpdateWindowTitle;
    Writeln('Current Window Title: ', CurrentWindowTitle);
    Sleep(1000); // Warte 1 Sekunde, bevor den Titel erneut abzufragen
  until False;
end.

