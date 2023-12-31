unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, XMLPropStorage, ComCtrls, Serial, Synaser;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    LabelSelectedColor: TLabel;
    LabelStatus: TLabel;
    Timer1: TTimer;
    SerialPort: TBlockSerial;
    TrayIcon1: TTrayIcon;
    XMLPropStorage1: TXMLPropStorage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
  XMLPropStorage1.Restore;
  SerialPort := TBlockSerial.Create;
  SerialPort.Connect(ComboBox1.Text); // Beispiel COM1, bitte anpassen
  //Label1.Caption := ComboBox1.Text;
  SerialPort.Config(9600, 8, 'N', SB1, False, False);
  Application.ShowMainForm := False;
  TrayIcon1.Visible := True; // Zeige das Tray-Icon an
  TrayIcon1.ShowBalloonHint;
  sleep(500);
  SerialPort.SendString('N ' + Edit2.Text);
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if Edit1.Text='Ja' then
    SerialPort.SendString('J')
    else
        SerialPort.SendString('N ' + Edit2.Text);

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Port: string;
begin
  // Finden Sie alle verfügbaren COM-Ports und fügen Sie sie zur ComboBox hinzu
  Port := GetSerialPortNames;
    //ComboBox1.Items.Add(Port);
    ShowMessage(Port);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ColorDialog: TColorDialog;
  SelectedColor: TColor;
  R, G, B: Byte;
begin
  ColorDialog := TColorDialog.Create(Self);

  try
    // Einstellungen für den Dialog (optional)
    ColorDialog.Color := LabelSelectedColor.Font.Color;

    // Dialog anzeigen und prüfen, ob der Benutzer OK geklickt hat
    if ColorDialog.Execute then
    begin
      // Die ausgewählte Farbe verwenden
      SelectedColor := ColorDialog.Color;
      LabelSelectedColor.Font.Color := SelectedColor;

      // Anzeige in Label
      LabelSelectedColor.Caption := Format('Ausgewählte Farbe: %d %d %d', [Red(SelectedColor), Green(SelectedColor), Blue(SelectedColor)]);

      // Anzeige in Edit2
      Edit2.Text := Format('%d %d %d', [Red(SelectedColor), Green(SelectedColor), Blue(SelectedColor)]);
      SerialPort.SendString('N ' + Edit2.Text);
    end;
  finally
    ColorDialog.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   SerialPort.SendString('N 0 0 0');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   SerialPort.SendString('N '+ Edit2.Text);
end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    TrayIcon1.Visible := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    SerialPort.SendString('N 0 0 0');
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

