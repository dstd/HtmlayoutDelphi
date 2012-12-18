unit HtmlDOM;

interface

uses
  Windows, HtmlConst, HtmlTypes, HtmlDll;

type
  HtmlElement = class;

  IHtmlBehaviorListener = interface
  {
    procedure OnBehaviorAttach(he: HtmlElement; attached: Boolean);
    function OnBehaviorMouse(he: HtmlElement; params: MouseParams): Boolean;
    function OnBehaviorKey(he: HtmlElement; params: KeyParams): Boolean;
    function OnBehaviorFocus(he: HtmlElement; params: FocusParams): Boolean;
    function OnBehaviorTimer(he: HtmlElement; params: TimerParams): Boolean;
    function OnBehaviorSize(he: HtmlElement): Boolean;
    function OnBehaviorScroll(he: HtmlElement; params: ScrollParams): Boolean;
  }
    function OnBehaviorDraw(he: HtmlElement; params: pBehaviorDrawParams): Boolean;
  {
    function OnBehaviorMethodCall(he: HtmlElement; params: MethodParams): Boolean;
    function OnBehaviorScriptCall(he: HtmlElement; params: XCallParams): Boolean;
  }
    function OnBehaviorEvent(he: HtmlElement; params: pBehaviorEventParams): Boolean;
  {
    function OnBehaviorDataArrived(he: HtmlElement; params: DataArrivedParams): Boolean;
    function OnBehaviorExchange(he: HtmlElement; params: ExchangeParams): Boolean;
  }
  end;

  HtmlElement = class
  public
    class function Create(tag: PAnsiChar; text: PWideChar = nil): HtmlElement;

    function FindFirst(sel: PWideChar): HtmlElement;

    procedure Insert(e: HtmlElement; index: UINT);

    function GetHtml(): AnsiString;
    procedure SetHtml(html: WideString; where: UINT);

    procedure SetBehaviorHandler(cb: IHtmlBehaviorListener);
    procedure RemoveBehaviorHandler(cb: IHtmlBehaviorListener);
  end;

implementation

{ HtmlElement }

class function HtmlElement.Create(tag: PAnsiChar; text: PWideChar): HtmlElement;
begin
  Result := HTMLayoutCreateElement(tag, text);
end;

function HtmlElement.FindFirst(sel: PWideChar): HtmlElement;
  function FirstCallback(he: HELEMENT; param: Pointer): BOOL stdcall;
  begin
    pHELEMENT(param)^ := he;
    Result := True; // stop enum
  end;
begin
  Result := nil;
  HTMLayoutSelectElements(self, sel, @FirstCallback, @Result);
end;

function HtmlElement.GetHtml: AnsiString;
var
  w: PChar;
begin
  w := nil;
  HTMLayoutGetElementHtml(self, w, True);
  Assert(false, 'who the hell will free the results?');
  Result := w;
end;

procedure HtmlElement.Insert(e: HtmlElement; index: UINT);
begin
  HTMLayoutInsertElement(e, self, index);
end;

function HTMLayoutEventThunk(tag: Pointer; he: HELEMENT; event: UINT; params: Pointer): BOOL stdcall;
begin
  Result := False;
  if tag = nil then Exit;
  case event of
    HANDLE_BEHAVIOR_EVENT:
      Result := IHtmlBehaviorListener(tag).OnBehaviorEvent(he, pBehaviorEventParams(params));
    HANDLE_DRAW:
      Result := IHtmlBehaviorListener(tag).OnBehaviorDraw(he, pBehaviorDrawParams(params));
  end;
end;

procedure HtmlElement.SetBehaviorHandler(cb: IHtmlBehaviorListener);
begin
  HTMLayoutAttachEventHandler(self, HTMLayoutEventThunk, Pointer(cb));
end;

procedure HtmlElement.RemoveBehaviorHandler(cb: IHtmlBehaviorListener);
begin
  HTMLayoutDetachEventHandler(self, HTMLayoutEventThunk, Pointer(cb));;
end;

procedure HtmlElement.SetHtml(html: WideString; where: UINT);
var
  u8: Utf8String;
begin
  u8 := Utf8Encode(html);
  HTMLayoutSetElementHtml(self, u8, Length(u8), where);
end;

end.

