unit HtmlDll;

interface

uses
  Windows, HtmlConst, HtmlTypes;

function HTMLayoutProcND(hwnd: HWND; msg: UINT; wParam:WPARAM; lParam: LPARAM; var pbHandled: BOOL): LRESULT; stdcall;
function HTMLayoutLoadHtml(hwnd: HWND; html: PBYTE; htmlSize: UINT): BOOL; stdcall;
function HTMLayoutLoadFile(hwnd: HWND; filename: LPCWSTR): BOOL; stdcall;
function HTMLayoutDataReady(hwnd: HWND; uri: LPCWSTR; data: Pointer; length: DWORD): BOOL; stdcall;

procedure HTMLayoutSetCallback(hwnd: HWND; cb: THtmlayoutCallback; cbParam: Pointer); stdcall;

function HTMLayoutGetRootElement(hwnd: HWND): HELEMENT; safecall;
function HTMLayoutGetChildrenCount(he: HELEMENT): UINT; safecall;
function HTMLayoutGetNthChild(he: HELEMENT; n: UINT): HELEMENT; safecall;

function HTMLayoutGetElementText(he: HELEMENT; characters: LPWSTR): UINT; safecall;
procedure HTMLayoutGetElementHtml(he: HELEMENT; var utf8bytes: PCHAR; outer: BOOL); safecall;
procedure HTMLayoutSetElementHtml(he: HELEMENT; html: Utf8String; htmlLength: DWord; where:UINT); safecall; overload;
function HTMLayoutGetElementInnerText16(he: HELEMENT): LPWSTR; safecall;
procedure HTMLayoutSetElementInnerText16(he: HELEMENT; utf16words: LPCWSTR; length: UINT); safecall;

function HTMLayoutGetElementType(he: HELEMENT): LPCSTR; safecall;

procedure HTMLayoutDeleteElement(he: HELEMENT); safecall;
function HTMLayoutCreateElement(tagname: LPCSTR; textOrNull: LPCWSTR): HELEMENT; safecall;
procedure HTMLayoutInsertElement(he: HELEMENT; hparent: HELEMENT; index: UINT); safecall;
procedure HTMLayoutDetachElement(he: HELEMENT); safecall;
function HTMLayoutCloneElement(he: HELEMENT): HELEMENT; safecall;
procedure HTMLayout_UseElement(he: HELEMENT); safecall;

procedure HTMLayoutMoveElement(he: HELEMENT; xView: Integer; yView: Integer); safecall;

procedure HTMLayoutSelectElements(he: HELEMENT; sel: LPWSTR; cb: THtmlayoutElementCallback; param: Pointer); safecall;

procedure HTMLayoutAttachEventHandler(he: HELEMENT; cb: THtmlayoutElementEvent; tag: Pointer); safecall;
procedure HTMLayoutDetachEventHandler(he: HELEMENT; cb: THtmlayoutElementEvent; tag: Pointer); safecall;
{
function HTMLayoutSetElementHtml(he: HELEMENT; html: WideString; where: UINT): Boolean; overload;
function HTMLayoutFindFirst(he: HELEMENT; sel: PWideChar): HELEMENT;

function GetElementHtml(he: HELEMENT): AnsiString;

/////

function HTMLayoutElementSetHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
function HTMLayoutElementRemoveHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
}

//*****************************************************************************************************

implementation

uses
  SysUtils;

const
  engineDLL = 'htmlayout.dll';

function HTMLayoutProcND (hwnd: HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM; var pbHandled: BOOL): LRESULT; external engineDLL; stdcall;

function HTMLayoutLoadHtml(hwnd: HWND; html:PBYTE; htmlSize:UINT): BOOL; external engineDLL; stdcall;
function HTMLayoutLoadFile(hwnd: HWND; filename:LPCWSTR): BOOL;  external engineDLL; stdcall;
function HTMLayoutDataReady(hwnd: HWND; uri: LPCWSTR; data: Pointer; length: DWORD): BOOL; external engineDLL; stdcall;

procedure HTMLayoutSetCallback(hwnd: HWND; cb: THtmlayoutCallback; cbParam: Pointer); external engineDLL; stdcall;

function HTMLayoutGetRootElement(hwnd: HWND): HELEMENT; external engineDLL; safecall;
function HTMLayoutGetChildrenCount(he: HELEMENT): UINT; external engineDLL; safecall;
function HTMLayoutGetNthChild(he: HELEMENT; n: UINT): HELEMENT; external engineDLL; safecall;

function HTMLayoutGetElementText(he: HELEMENT; characters: LPWSTR): UINT; external engineDLL; safecall;
procedure HTMLayoutGetElementHtml(he: HELEMENT; var utf8bytes: PCHAR; outer: BOOL); external engineDLL; safecall;
procedure HTMLayoutSetElementHtml(he: HELEMENT; html: Utf8String; htmlLength: DWord; where:UINT); external engineDLL; safecall; overload;
function HTMLayoutGetElementInnerText16(he: HELEMENT): LPWSTR; external engineDLL; safecall;
procedure HTMLayoutSetElementInnerText16(he: HELEMENT; utf16words: LPCWSTR; length: UINT); external engineDLL; safecall;

function HTMLayoutGetElementType(he: HELEMENT): LPCSTR; external engineDLL; safecall;

procedure HTMLayoutDeleteElement(he: HELEMENT); external engineDLL; safecall;
function HTMLayoutCreateElement(tagname: LPCSTR; textOrNull: LPCWSTR): HELEMENT; external engineDLL; safecall;
procedure HTMLayoutInsertElement(he: HELEMENT; hparent: HELEMENT; index: UINT); external engineDLL; safecall;
procedure HTMLayoutDetachElement(he: HELEMENT); external engineDLL; safecall;
function HTMLayoutCloneElement(he: HELEMENT): HELEMENT; external engineDLL; safecall;
procedure HTMLayout_UseElement(he: HELEMENT); external engineDLL; safecall;

procedure HTMLayoutMoveElement(he: HELEMENT; xView: Integer; yView: Integer); external engineDLL; safecall;

procedure HTMLayoutSelectElements(he: HELEMENT; sel: LPWSTR; cb: THtmlayoutElementCallback; param: Pointer); external engineDLL name 'HTMLayoutSelectElementsW'; safecall;

procedure HTMLayoutAttachEventHandler(he: HELEMENT; cb: THtmlayoutElementEvent; tag: Pointer); external engineDLL; safecall;
procedure HTMLayoutDetachEventHandler(he: HELEMENT; cb: THtmlayoutElementEvent; tag: Pointer); external engineDLL; safecall;

{
function HTMLayoutSetElementHtml(he: HELEMENT; html: WideString; where: UINT): Boolean;
var
  u8: Utf8String;
begin
  u8 := Utf8Encode(html);
  Result := HTMLayoutSetElementHtml(he, u8, Length(u8), where) = HLDOM_OK;
end;

function GetElementHtml(he: HELEMENT): AnsiString;
var
  w: PChar;
begin
  w := nil;
  HTMLayoutGetElementHtml(he, w, True);
  Result := w;
end;

function HTMLayoutFindFirst(he: HELEMENT; sel: PWideChar): HELEMENT;
  function FirstCallback(he: HELEMENT; param: Pointer): BOOL stdcall;
  begin
    GetElementHtml(he);
    pHELEMENT(param)^ := he;
    Result := True; // stop enum
  end;
begin
  Result := nil;
  HTMLayoutSelectElements(he, sel, @FirstCallback, @Result);
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

function HTMLayoutElementSetHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
begin
  Result := HTMLayoutAttachEventHandler(he, HTMLayoutEventThunk, Pointer(cb)) = HLDOM_OK;
end;

function HTMLayoutElementRemoveHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
begin
  Result := HTMLayoutDetachEventHandler(he, HTMLayoutEventThunk, Pointer(cb)) = HLDOM_OK;
end;
}

end.

