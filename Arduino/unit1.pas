unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,Serial,Synaser;

type
  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    LabelStatus: TLabel;
    Timer1: TTimer;
    SerialPort: TBlockSerial;
    TrayIcon1: TTrayIcon;
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
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
  begin
    Form1.LabelStatus.Caption := 'Netzwerkdatenbank gefunden!' ;
    Form1.Edit1.Text := 'Ja';
  end
  else
  begin
    Form1.LabelStatus.Caption := 'Netzwerkdatenbank nicht gefunden!';
    Form1.Edit1.Text := 'Nein'
  end;
end;

procedure TForm1.Timer1StartTimer(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    // Öffnen Sie die serielle Schnittstelle (angepasst an Ihren Arduino-Port und Baudrate)
  SerialPort := TBlockSerial.Create;
  SerialPort.Connect('COM3'); // Beispiel COM1, bitte anpassen
  SerialPort.Config(9600, 8, 'N', SB1, False, False);
  Application.ShowMainForm := False;
  TrayIcon1.Visible := True; // Zeige das Tray-Icon an
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if Edit1.Text='Ja' then
    SerialPort.SendString('J')
    else
        SerialPort.SendString('N');

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    TrayIcon1.Visible := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    SerialPort.Free;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
   if Form1.WindowState = wsMinimized
     then
     begin
     Application.ShowMainForm := False;
     Form1.visible:=False;
     end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FoundNetworkDatabase := False;
  EnumerateWindows;
  UpdateStatusLabel;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Form1.visible:=True;
end;



end.

