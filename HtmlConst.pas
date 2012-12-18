unit HtmlConst;

interface

uses Windows;

const
  HLN_CREATE_CONTROL  = $AFF + $01;
  HLN_LOAD_DATA       = $AFF + $02;
  HLN_CONTROL_CREATED = $AFF + $03;
  HLN_DATA_LOADED     = $AFF + $04;
  HLN_DOCUMENT_COMPLETE = $AFF + $05;
  HLN_UPDATE_UI       = $AFF + $06;
  HLN_DESTROY_CONTROL = $AFF + $07;
  HLN_ATTACH_BEHAVIOR = $AFF + $08;
  HLN_BEHAVIOR_CHANGED = $AFF + $09;
  HLN_DIALOG_CREATED = $AFF + $10;
  HLN_DIALOG_CLOSE_RQ = $AFF + $0A;
  HLN_DOCUMENT_LOADED = $AFF + $0B;

  LOAD_OK      = 0;
  LOAD_DISCARD = 1;

  HLDOM_OK = 0;
  HLDOM_INVALID_HWND = 1;
  HLDOM_INVALID_HANDLE = 2;
  HLDOM_PASSIVE_HANDLE = 3;
  HLDOM_INVALID_PARAMETER = 4;
  HLDOM_OPERATION_FAILED = 5;
  HLDOM_OK_NOT_HANDLED = -1;

  SIH_REPLACE_CONTENT    = 0;
  SIH_INSERT_AT_START    = 1;
  SIH_APPEND_AFTER_LAST  = 2;

  SOH_REPLACE       = 3;
  SOH_INSERT_BEFORE = 4;
  SOH_INSERT_AFTER  = 5;

  INSERT_AT_END     = $7FFFFFF;

  //enum EVENT_GROUPS
  HANDLE_INITIALIZATION = $0000;     (* attached/detached *)
  HANDLE_MOUSE = $0001;              (* mouse events *)
  HANDLE_KEY = $0002;                (* key events *)
  HANDLE_FOCUS = $0004;              (* focus events, if this flag is set it also means that element it attached to is focusable *)
  HANDLE_SCROLL = $0008;             (* scroll events *)
  HANDLE_TIMER = $0010;              (* timer event *)
  HANDLE_SIZE = $0020;               (* size changed event *)
  HANDLE_DRAW = $0040;               (* drawing request (event) *)
  HANDLE_DATA_ARRIVED = $080;        (* requested data () has been delivered *)
  HANDLE_BEHAVIOR_EVENT = $0100;     (* secondary, synthetic events:
                                        BUTTON_CLICK, HYPERLINK_CLICK, etc.,
                                        a.k.a. notifications from intrinsic behaviors *)
  HANDLE_METHOD_CALL = $0200;        (* behavior specific methods *)

  HANDLE_EXCHANGE   = $1000;         (* system drag-n-drop *)
  HANDLE_GESTURE    = $2000;         (* touch input events *)

  HANDLE_ALL        = $FFFF;         (* all of them *)

  DISABLE_INITIALIZATION = $80000000; (* disable INITIALIZATION events to be sent.
                                         normally engine sends
                                         BEHAVIOR_DETACH / BEHAVIOR_ATTACH events unconditionally,
                                         this flag allows to disable this behavior
                                      *)

type
  BehaviorEvents = (
    BUTTON_CLICK = 0,              // click on button
    BUTTON_PRESS = 1,              // mouse down or key down in button
    BUTTON_STATE_CHANGED = 2,      // checkbox/radio/slider changed its state/value 
    EDIT_VALUE_CHANGING = 3,       // before text change
    EDIT_VALUE_CHANGED = 4,        // after text change
    SELECT_SELECTION_CHANGED = 5,  // selection in <select> changed
    SELECT_STATE_CHANGED = 6,      // node in select expanded/collapsed, heTarget is the node

    POPUP_REQUEST   = 7,           // request to show popup just received, 
                                   //     here DOM of popup element can be modifed.
    POPUP_READY     = 8,           // popup element has been measured and ready to be shown on screen,
                                   //     here you can use functions like ScrollToView.
    POPUP_DISMISSED = 9,           // popup element is closed,
                                   //     here DOM of popup element can be modifed again - e.g. some items can be removed
                                   //     to free memory.

    MENU_ITEM_ACTIVE = $A,        // menu item activated by mouse hover or by keyboard,
    MENU_ITEM_CLICK = $B,         // menu item click, 
                                   //   BEHAVIOR_EVENT_PARAMS structure layout
                                   //   BEHAVIOR_EVENT_PARAMS.cmd - MENU_ITEM_CLICK/MENU_ITEM_ACTIVE   
                                   //   BEHAVIOR_EVENT_PARAMS.heTarget - the menu item, presumably <li> element
                                   //   BEHAVIOR_EVENT_PARAMS.reason - BY_MOUSE_CLICK | BY_KEY_CLICK

    CONTEXT_MENU_SETUP   = $F,    // evt.he is a menu dom element that is about to be shown. You can disable/enable items in it.      
    CONTEXT_MENU_REQUEST = $10,   // "right-click", BEHAVIOR_EVENT_PARAMS::he is current popup menu HELEMENT being processed or NULL.
                                   // application can provide its own HELEMENT here (if it is NULL) or modify current menu element.
  
    VISIUAL_STATUS_CHANGED = $11, // broadcast notification, sent to all elements of some container being shown or hidden   
    DISABLED_STATUS_CHANGED = $12,// broadcast notification, sent to all elements of some container that got new value of :disabled state

    POPUP_DISMISSING = $13,       // popup is about to be closed


    // "grey" event codes  - notfications from behaviors from this SDK 
    HYPERLINK_CLICK = $80,        // hyperlink click
    TABLE_HEADER_CLICK,            // click on some cell in table header, 
                                   //     target = the cell, 
                                   //     reason = index of the cell (column number, 0..n)
    TABLE_ROW_CLICK,               // click on data row in the table, target is the row
                                   //     target = the row, 
                                   //     reason = index of the row (fixed_rows..n)
    TABLE_ROW_DBL_CLICK,           // mouse dbl click on data row in the table, target is the row
                                   //     target = the row, 
                                   //     reason = index of the row (fixed_rows..n)

    ELEMENT_COLLAPSED = $90,      // element was collapsed, so far only behavior:tabs is sending these two to the panels
    ELEMENT_EXPANDED,              // element was expanded,

    ACTIVATE_CHILD,                // activate (select) child, 
                                   // used for example by accesskeys behaviors to send activation request, e.g. tab on behavior:tabs. 

    DO_SWITCH_TAB = ACTIVATE_CHILD,// command to switch tab programmatically, handled by behavior:tabs 
                                   // use it as HTMLayoutPostEvent(tabsElementOrItsChild, DO_SWITCH_TAB, tabElementToShow, 0),

    INIT_DATA_VIEW,                // request to virtual grid to initialize its view
  
    ROWS_DATA_REQUEST,             // request from virtual grid to data source behavior to fill data in the table
                                   // parameters passed throug DATA_ROWS_PARAMS structure.

    UI_STATE_CHANGED,              // ui state changed, observers shall update their visual states.
                                   // is sent for example by behavior:richtext when caret position/selection has changed.

    FORM_SUBMIT,                   // behavior:form detected submission event. BEHAVIOR_EVENT_PARAMS::data field contains data to be posted.
                                   // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                                   // to be submitted. You can modify the data or discard submission by returning TRUE from the handler.
    FORM_RESET,                    // behavior:form detected reset event (from button type=reset). BEHAVIOR_EVENT_PARAMS::data field contains data to be reset.
                                   // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about 
                                   // to be rest. You can modify the data or discard reset by returning TRUE from the handler.
                                 
    DOCUMENT_COMPLETE,             // behavior:frame have complete document.

    HISTORY_PUSH,                  // behavior:history stuff
    HISTORY_DROP,                     
    HISTORY_PRIOR,
    HISTORY_NEXT,

    HISTORY_STATE_CHANGED,         // behavior:history notification - history stack has changed

    CLOSE_POPUP,                   // close popup request,
    REQUEST_TOOLTIP,               // request tooltip, BEHAVIOR_EVENT_PARAMS.he <- is the tooltip element.

    ANIMATION         = $A0,      // animation started (reason=1) or ended(reason=0) on the element.


    FIRST_APPLICATION_EVENT_CODE = $100, 
    // all custom event codes shall be greater
    // than this number. All codes below this will be used
    // solely by application - HTMLayout will not intrepret it 
    // and will do just dispatching.
    // To send event notifications with  these codes use
    // HTMLayoutSend/PostEvent API.

    __DUMMY = $7FFFFFFF
  );

  DrawEvents = (
    DRAW_BACKGROUND = 0,
    DRAW_CONTENT = 1,
    DRAW_FOREGROUND = 2
  );

implementation
end.