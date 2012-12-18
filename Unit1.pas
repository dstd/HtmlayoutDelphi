unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HtmlConst, HtmlTypes, HtmlCtrl, HtmlDll, HtmlDom, ComCtrls;

type
  TForm1 = class(TForm, IHtmlBehaviorListener)
    StatusBar1: TStatusBar;
    TabControl1: TTabControl;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    Html: THtmlControl;
    btn1, area1: HtmlElement;
    function OnHtmlLoadData(Sender: THtmlControl; Uri: PWideChar; element: HtmlElement): LRESULT;
    procedure OnHtmlDocumentComplete(Sender: THtmlControl);

    function OnBehaviorDraw(he: HtmlElement; params: pBehaviorDrawParams): Boolean;
    function OnBehaviorEvent(he: HtmlElement; params: pBehaviorEventParams): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Html := THtmlControl.Create(TabControl1);
  Html.Parent := TabControl1;
  Html.Align := alClient;
  Html.OnLoadData := OnHtmlLoadData;
  Html.OnDocumentComplete := OnHtmlDocumentComplete;
  Html.Visible := True;
  Html.LoadHtml('index.htm');
end;

function AppendHtmlElement(parent: HtmlElement; html: WideString): HtmlElement;
var
  e: HtmlElement;
begin
  e := HtmlElement.Create('div');
  parent.Insert(e, INSERT_AT_END);
  e.SetHtml(html, SOH_REPLACE);
  Result := e;
end;
procedure AddMessage(root: HtmlElement; from, ava, time, msg: WideString; incoming: Boolean);
var
  t: WideString;
  html: WideString;
begin
  if incoming then begin
    t := 'incoming';
  end else begin
    t := 'outgoing';
  end;
  html := WideFormat(
    '<div class="bubble message %s" sendercolor="color: hsl(21, 100%%, 40%%);">'+
    '<div class="indicator">'+
    '<p class="pseudo"><span class="sender">%s<span class="time"> - %s</span></span></p>'+
    '<p class="message %s" title="%s">'+
    '<img width=32 height=32 src="skin://%s"/>'+
    ' <span class="ib-msg-txt">%s</span></p>'+
    '</div>',
    [t, from, time, t, time, ava, msg]);
  AppendHtmlElement(root, html);
end;

function TForm1.OnBehaviorDraw(he: HtmlElement; params: pBehaviorDrawParams): Boolean;
var
  cnv: TCanvas;
begin
  Result := False;
  if he <> area1 then Exit;

  cnv := TCanvas.Create;

  cnv.Handle := params^.dc;
  cnv.Brush.Color := RGB(Random(255),Random(255),Random(255));
  cnv.FillRect(params^.area);

  cnv.TextOut(params^.area.Left + Random(10), params^.area.Top + Random(10) + 20, 'Some text!');

  cnv.Free;

  Result := True;
end;

function TForm1.OnBehaviorEvent(he: HtmlElement; params: pBehaviorEventParams): Boolean;
begin
  if (he = btn1) and (params^.Cmd = BUTTON_CLICK) then
    MessageBox(0, 'event!', nil, 0);
  Result := False;
end;

procedure TForm1.OnHtmlDocumentComplete(Sender: THtmlControl);
var
  root: HtmlELement;
  i: integer;
begin
  root := sender.GetRootElement();
  root := root.FindFirst('#chat');

  AppendHtmlElement(root, '<button id="du1">click me!</button>');
  btn1 := root.FindFirst('#du1');
  btn1.SetBehaviorHandler(self);

  AppendHtmlElement(root,'<widget id="du2" width=128 height=48 />');
  area1 := root.FindFirst('#du2');
  area1.SetBehaviorHandler(self);

  for i := 1 to 100 do
    AddMessage(root, 'username', WideFormat('ava%d.jpg', [Random(5)+1]), '12:12', IntToStr(i) + ', Ho-ho-hoooly shit!', Random(2) = 1);
end;

function TForm1.OnHtmlLoadData(Sender: THtmlControl; Uri: PWideChar; element: HtmlElement): LRESULT;
var
  s: TStream;
  filename: WideString;
  buf: Pointer;
  size: DWORD;
  i: Integer;
begin
  Result := LOAD_OK;
  if Pos('skin://', Uri) <> 1 then
    Exit;
  I := Length(Uri);
  if( Uri[I-1] = '/' ) then
    filename := Copy(Uri, 8, I-1-7)
  else
    filename := Uri+7;
  try
    s := TFileStream.Create(filename, fmOpenRead);
  except
    Result := LOAD_DISCARD;
    Exit;
  end;
  buf := nil;
  try
    size := s.Size;
    GetMem(buf, size);
    s.Read(buf^, size);
    s.Free;
    Sender.OnDataReady(Uri, buf, size);
    FreeMem(buf);
    Result := LOAD_DISCARD;
  except
  end;
end;

end.
