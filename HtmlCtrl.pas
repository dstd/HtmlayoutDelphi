unit HtmlCtrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, HtmlConst, HtmlTypes, HtmlDll, HtmlDOM;

type
  THtmlControl = class;

  THtmlLoadData = function (Sender: THtmlControl; Uri: PWideChar; element: HtmlElement): LRESULT of Object;
  THtmlDocumentComplete = procedure (Sender: THtmlControl) of Object;

  THtmlControl = class(TWinControl)
  private
    FOnLoadData: THtmlLoadData;
    FOnDocumentComplete: THtmlDocumentComplete;
    function HtmlCallback(uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure LoadHtml(pHtml: PByte; cb: Cardinal); overload;
    procedure LoadHtml(filename: widestring); overload;

    function GetRootElement(): HtmlElement;

    function OnDataReady(uri: PWideChar; data: Pointer; length: Cardinal): Boolean;
  published
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnLoadData: THtmlLoadData read FOnLoadData write FOnLoadData;
    property OnDocumentComplete: THtmlDocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
//    property OnMouseActivate;
    property OnMouseDown;
//    property OnMouseEnter;
//    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
end;

implementation

{ THtmlControl }

constructor THtmlControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure THtmlControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure THtmlControl.LoadHtml(pHtml: PByte; cb: Cardinal);
begin
end;

procedure THtmlControl.LoadHtml(filename: widestring);
begin
  HTMLayoutLoadFile(Handle, PWideChar(filename));
end;

function AHtmlCallbackProxy(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer): LRESULT; stdcall;
begin
  if vParam <> nil then
    Result := THtmlControl(vParam).HtmlCallback(uMsg, wParam, lParam)
  else
    Result := 0;
end;

procedure THtmlControl.WndProc(var Message: TMessage);
var
  Handled: BOOL;
  res: LRESULT;
begin
  res := HTMLayoutProcND(Handle, Message.Msg, Message.WParam, Message.LParam, Handled);
  if Handled then
  begin
    Message.Result := res;
    Exit;
  end;

  case Message.Msg of
    WM_CREATE:
      begin
        HTMLayoutSetCallback(Handle, @AHtmlCallbackProxy, Self);
      end;
  end;

  inherited WndProc(Message);
end;

function THtmlControl.HtmlCallback(uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  nmhdr: pNMHDR;
begin
  nmhdr := pNMHDR(lParam);
  case nmhdr^.code of
    HLN_LOAD_DATA:
      begin
        if Assigned(FOnLoadData) then
          Result := FOnLoadData(Self, pNMHL_LOAD_DATA(lParam)^.uri, pNMHL_LOAD_DATA(lParam)^.principal)
        else
          Result := LOAD_OK;
        Exit;
      end;
    HLN_DOCUMENT_COMPLETE:
      if Assigned(FOnLoadData) then
        FOnDocumentComplete(Self);
  end;
  Result := 0;
end;

function THtmlControl.GetRootElement: HtmlElement;
begin
  Result := HTMLayoutGetRootElement(Handle);
end;

function THtmlControl.OnDataReady(uri: PWideChar; data: Pointer; length: Cardinal): Boolean;
begin
  Result := HTMLayoutDataReady(Handle, uri, data, length);
end;

end.
