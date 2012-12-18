unit HtmlTypes;

interface

uses Windows, HtmlConst;

type
  HELEMENT = Pointer;
  //HELEMENT = HtmlElement;
  pHELEMENT = ^HELEMENT;

  NMHL_LOAD_DATA = record
    Hdr: NMHDR;
    Uri: LPCWSTR;

    OutData: PBYTE;
    OutDataSize: UINT;
    DataType: UINT;

    Principal: HELEMENT;
    Initiator: HELEMENT;
  end;
  PNMHL_LOAD_DATA = ^NMHL_LOAD_DATA;
{
  NMHL_DATA_LOADED = record
    Hdr: NMHDR;
    Uri: LPCWSTR;
    Data: LPCBYTE;
    DataSize: DWORD;
    DataType: UINT;
    Status: UINT;
  end;
  PNMHL_DATA_LOADED = ^NMHL_DATA_LOADED;
}

  HtmlValue = record
    t, u: UINT;
    d: UINT64;
  end;

  BehaviorEventParams = record
    Cmd: BehaviorEvents;
    Target: HELEMENT;
    Source: HELEMENT;
    Reason: UINT;
    Data: HtmlValue;
  end;
  pBehaviorEventParams = ^BehaviorEventParams;

  BehaviorDrawParams = record
    Cmd: DrawEvents;
    dc: HDC;
    area: TRect;
    reserverd: UINT;
  end;
  pBehaviorDrawParams = ^BehaviorDrawParams;

  THtmlayoutCallback = function(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer): LRESULT stdcall;
  THtmlayoutElementCallback = function(he: HELEMENT; param: Pointer): BOOL stdcall;
  THtmlayoutElementEvent = function(tag: Pointer; he: HELEMENT; event: UINT; params: Pointer): BOOL stdcall;

implementation

end.