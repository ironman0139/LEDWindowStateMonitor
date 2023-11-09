unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Serial;

type
  { TForm1 }

  TForm1 = class(TForm)
    LabelStatus: TLabel;
    Timer1: TTimer;
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    FoundNetworkDatabase: Boolean;
  end;

var
  Form1: TForm1;

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
      Form1.FoundNetworkDatabase := True;
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

procedure UpdateStatusLabel;
begin
  if Form1.FoundNetworkDatabase then
    Form1.LabelStatus.Caption := 'Netzwerkdatenbank gefunden!'
  else
    Form1.LabelStatus.Caption := 'Netzwerkdatenbank nicht gefunden!';
end;

procedure TForm1.Timer1StartTimer(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FoundNetworkDatabase := False;
  EnumerateWindows;
  UpdateStatusLabel;
end;



end.
