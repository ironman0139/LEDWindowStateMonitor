program WindowTitleViewer;

{$mode objfpc}{$H+}

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils;

var
  FoundNetworkDatabase: Boolean;

{$IFDEF WINDOWS}
function EnumWindowsProc(Wnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  TitleLength: Integer;
  Title: string;
begin
  TitleLength := GetWindowTextLength(Wnd);
  if TitleLength > 0 then
  begin
    SetLength(Title, TitleLength);
    GetWindowText(Wnd, PChar(Title), TitleLength + 1);
    if Pos('Netzwerkdatenbank', Title) > 0 then
    begin
      Writeln('Netzwerkdatenbank gefunden!');
      FoundNetworkDatabase := True;
    end;
  end;
  Result := True; // Fortsetzen der Enumeration
end;
{$ENDIF}

procedure EnumerateWindows;
begin
  {$IFDEF WINDOWS}
  EnumWindows(@EnumWindowsProc, 0);
  {$ENDIF}
end;

begin
  repeat
    FoundNetworkDatabase := False; // Setze auf False zu Beginn der Überprüfung

    EnumerateWindows;

    if FoundNetworkDatabase then
      Writeln('Netzwerkdatenbank gefunden!')
    else
      Writeln('Netzwerkdatenbank nicht gefunden!');

    Sleep(5000); // Warte 5 Sekunden, bevor die Fenster erneut aufgezählt werden
  until False;

  // Warte auf Benutzereingabe, um das Konsolenfenster offen zu halten
  ReadLn;
end.

