unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

{$IFDEF WINDOWS}
function EnumWindowsProc(Wnd: HWND; lParam: LPARAM): BOOL; stdcall;
{$ENDIF}

procedure EnumerateWindows;

implementation

{$R *.lfm}

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
      Form1.Label1.Caption := 'Netzwerkdatenbank gefunden!';
      Application.ProcessMessages; // Aktualisiere das UI
    end
    else
    begin
      Form1.Label1.Caption := 'Netzwerkdatenbank nicht gefunden!';
      Application.ProcessMessages; // Aktualisiere das UI
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

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  EnumerateWindows;
end;

end.

