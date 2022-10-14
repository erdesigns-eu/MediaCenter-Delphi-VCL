{
  Description
  Comments

  (c) Copyrights 2017-2022 Ernst Reidinga <ernstreidinga85@gmail.com>

  If you use this unit, please give credits to the original author;
  Ernst Reidinga.
}

unit untMediaCenter;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Graphics,
  Winapi.Messages,
  System.Types,
  Vcl.ExtCtrls,
  Winapi.MMSystem,
  Vcl.Imaging.pngimage,

  { Direct2D }
  Winapi.D2D1,
  Vcl.Direct2D;

const
  clMediaCenterBlue1 = TColor($004B2208);
  clMediaCenterBlue2 = TColor($00924A0E);
  clMediaCenterWhite = TColor($00E2DFDE);

const
  PlayerControlsDividerWidth  = 4;
  PlayerControlsDividerHeight = 21;

type
  TMediaCenterAnimationTimer = class;

{*******************************************************}
{           MediaCenter Animation Timer Thread          }
{*******************************************************}
  TMediaCenterAnimationTimerThread = class(TThread)
  private
    FOwner    : TMediaCenterAnimationTimer;
    FTimerID  : cardinal;
    FInterval : cardinal;
    FEvent    : THandle;
  protected
    procedure Execute; override;
  end;

{*******************************************************}
{           MediaCenter Animation Timer Class           }
{*******************************************************}
  TMediaCenterAnimationTimer = class(TComponent)
  private
    FOnTimer    : TNotifyEvent;
    FTimerThread: TMediaCenterAnimationTimerThread;
    FEnabled    : boolean;

    procedure DoTimerProc;
    procedure SetEnabled(Enabled: Boolean);
    function GetInterval : Cardinal;
    procedure SetInterval(Interval: Cardinal);
    {$WARN SYMBOL_PLATFORM OFF}
    function GetThreadPriority: TThreadPriority;
    procedure SetThreadPriority(Priority: TThreadPriority);
    {$WARN SYMBOL_PLATFORM ON}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled: boolean read FEnabled write SetEnabled default False;
    property Interval: cardinal read GetInterval write SetInterval default 10;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    {$WARN SYMBOL_PLATFORM OFF}
    property ThreadPriority: TThreadPriority read GetThreadPriority  write SetThreadPriority default tpNormal;
    {$WARN SYMBOL_PLATFORM ON}
  end;

type
  TMediaCenterAnimationEasingFunction = function(P: Extended; FirstNum, Diff: Integer) : Extended of object;
  TMediaCenterAnimationTickEvent      = reference to procedure(Sender: TObject; Value: Extended);
  TMediaCenterAnimationNotifyEvent    = reference to procedure(Sender: TObject);

type
  TMediaCenterAnimationEasingType = (
    etBackEaseIn,    etBackEaseOut,    etBackEaseInOut,
    etBounceEaseIn,  etBounceEaseOut,
    etCircEaseIn,    etCircEaseOut,    etCircEaseInOut,
    etCubicEaseIn,   etCubicEaseOut,   etCubicEaseInOut,
    etElasticEaseIn, etElasticEaseOut,
    etExpoEaseIn,    etExpoEaseOut,    etExpoEaseInOut,
    etQuadEaseIn,    etQuadEaseOut,    etQuadEaseInOut,
    etQuartEaseIn,   etQuartEaseOut,   etQuartEaseInOut,
    etQuintEaseIn,   etQuintEaseOut,   etQuintEaseInOut,
    etSineEaseIn,    etSineEaseOut,    etSineEaseInOut);

{*******************************************************}
{              MediaCenter Animation Class              }
{*******************************************************}
type
  TMediaCenterAnimation = class(TPersistent)
  private
    FStartPos   : Integer;
    FAnimLength : Integer;
    FDifferent  : Integer;
    FStartTime  : TDateTime;
    FEasingFunc : TMediaCenterAnimationEasingFunction;
    FTimer      : TMediaCenterAnimationTimer;
    FDelayTimer : TMediaCenterAnimationTimer;
    FOnTick     : TMediaCenterAnimationTickEvent;
    FOnFinish   : TMediaCenterAnimationNotifyEvent;

    procedure OnTimer(Sender: TObject);
    procedure OnDelayTimer(Sender: TObject);
    procedure FinishAnimation;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Start(StartPos, EndPos, Length: Integer; Easing: TMediaCenterAnimationEasingType); overload;
    procedure Start(StartPos, EndPos, Length: Integer; Easing: TMediaCenterAnimationEasingType; CycleTime, StartDelay: Integer); overload;
    procedure Stop;

    class function GetEasingFunction(Easing: TMediaCenterAnimationEasingType): TMediaCenterAnimationEasingFunction; static;

    class function BackEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function BackEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function BackEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function BounceEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function BounceEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CircEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CircEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CircEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CubicEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CubicEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function CubicEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function ElasticEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function ElasticEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function ExpoEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function ExpoEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function ExpoEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuadEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuadEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuadEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuartEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuartEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuartEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuintEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuintEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function QuintEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function SineEaseIn(P: Extended; FirstNum, Diff: Integer): Extended;
    class function SineEaseOut(P: Extended; FirstNum, Diff: Integer): Extended;
    class function SineEaseInOut(P: Extended; FirstNum, Diff: Integer): Extended;
  published
    property OnTick: TMediaCenterAnimationTickEvent read FOnTick write FOnTick;
    property OnFinish: TMediaCenterAnimationNotifyEvent read FOnFinish write FOnFinish;
  end;

type
  TMediaCenterBackgroundStretchMode = (smStretch, smAspectStretch, smAspectHorizontal, smAspectVertical, smNone);

{*******************************************************}
{             MediaCenter Background Class              }
{*******************************************************}
type
  TMediaCenterBackground = class(TPersistent)
  private
    FOnChange : TNotifyEvent;

    FPicture  : TPicture;
    FStretch  : TMediaCenterBackgroundStretchMode;
    FCenter   : Boolean;
    FColor    : TColor;

    procedure SetPicture(Picture: TPicture);
    procedure SetStretch(Stretch: TMediaCenterBackgroundStretchMode);
    procedure SetCenter(Center: Boolean);
    procedure SetColor(Color: TColor);

    procedure OnChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Picture: TPicture read FPicture write SetPicture;
    property StretchMode: TMediaCenterBackgroundStretchMode read FStretch write SetStretch default smStretch;
    property Center: Boolean read FCenter write SetCenter default True;
    property Color: TColor read FColor write SetColor default clMediaCenterBlue1;
  end;

type
  TMediaCenterButtonState = (bsNoFocus, bsFocus, bsPressed, bsDisabled);

{*******************************************************}
{          MediaCenter Navigation Button Class          }
{*******************************************************}
type
  TMediaCenterNavigationButton = class(TPersistent)
  private
    FOnChange       : TNotifyEvent;
    FOnEnableChange : TNotifyEvent;

    FDisabled : TPicture;
    FNoFocus  : TPicture;
    FFocus    : TPicture;
    FPressed  : TPicture;
    FEnabled  : Boolean;
    FTop      : Integer;
    FLeft     : Integer;
    FRect     : TRect;

    procedure SetDisabled(Picture: TPicture);
    procedure SetNoFocus(Picture: TPicture);
    procedure SetFocus(Picture: TPicture);
    procedure SetPressed(Picture: TPicture);
    procedure SetEnabled(Enabled: Boolean);
    procedure SetTop(Top: Integer);
    procedure SetLeft(Left: Integer);

    procedure OnChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property ButtonRect: TRect read FRect write FRect;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnEnableChange: TNotifyEvent read FOnEnableChange write FOnEnableChange;

    property Disabled: TPicture read FDisabled write SetDisabled;
    property NoFocus: TPicture read FNoFocus write SetNoFocus;
    property Focus: TPicture read FFocus write SetFocus;
    property Pressed: TPicture read FPressed write SetPressed;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Top: Integer read FTop write SetTop;
    property Left: Integer read FLeft write SetLeft;
  end;

{*******************************************************}
{             MediaCenter Navigation Class              }
{*******************************************************}
type
  TMediaCenterNavigation = class(TPersistent)
  private
    FOnChange : TNotifyEvent;

    FGoBack      : TMediaCenterNavigationButton;
    FGoBackState : TMediaCenterButtonState;
    FMenu        : TMediaCenterNavigationButton;
    FMenuState   : TMediaCenterButtonState;
    FVisible     : Boolean;
    FDuration    : Integer;
    FCorner      : TPicture;

    FShowAnimation : TMediaCenterAnimation;
    FHideAnimation : TMediaCenterAnimation;
    FShowAnimationBusy : Boolean;
    FHideAnimationBusy : Boolean;

    FOpacity       : Byte;
    FPosition      : Integer;
    FNeedsPainting : Boolean;

    procedure SetGoBack(GoBack: TMediaCenterNavigationButton);
    procedure SetGoBackState(State: TMediaCenterButtonState);
    procedure SetMenu(Menu: TMediaCenterNavigationButton);
    procedure SetMenuState(State: TMediaCenterButtonState);
    procedure SetVisible(Visible: Boolean);
    procedure SetCorner(Corner: TPicture);

    procedure ShowAnimationTick(Sender: TObject; Value: Extended);
    procedure ShowAnimationFinish(Sender: TObject);
    procedure HideAnimationTick(Sender: TObject; Value: Extended);
    procedure HideAnimationFinish(Sender: TObject);

    procedure OnChanged(Sender: TObject);
    procedure OnEnableChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property Opacity: Byte read FOpacity;
    property Position: Integer read FPosition;
    property NeedsPainting: Boolean read FNeedsPainting;

    property GoBackState: TMediaCenterButtonState read FGoBackState write SetGoBackState;
    property MenuState: TMediaCenterButtonState read FMenuState write SetMenuState;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property GoBack: TMediaCenterNavigationButton read FGoBack write SetGoBack;
    property Menu: TMediaCenterNavigationButton read FMenu write SetMenu;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Duration: Integer read FDuration write FDuration default 350;
    property Corner: TPicture read FCorner write SetCorner;
  end;

{*******************************************************}
{                MediaCenter Clock Class                }
{*******************************************************}
type
  TMediaCenterClock = class(TPersistent)
  private
    FOnChange : TNotifyEvent;

    FLogo        : TPicture;
    FFont        : TFont;
    FTop         : Integer;
    FRight       : Integer;
    FVisible     : Boolean;
    FDuration    : Integer;
    FFormat      : String;
    FClockTimer  : TMediaCenterAnimationTimer;
    FCorner      : TPicture;

    FShowAnimation : TMediaCenterAnimation;
    FHideAnimation : TMediaCenterAnimation;
    FShowAnimationBusy : Boolean;
    FHideAnimationBusy : Boolean;

    FOpacity       : Byte;
    FPosition      : Integer;
    FNeedsPainting : Boolean;

    procedure SetLogo(Logo: TPicture);
    procedure SetFont(Font: TFont);
    procedure SetTop(Top: Integer);
    procedure SetRight(Right: Integer);
    procedure SetVisible(Visible: Boolean);
    procedure SetFormat(Format: String);
    procedure SetInterval(Interval: Integer);
    function GetInterval : Integer;
    procedure SetCorner(Corner: TPicture);

    procedure ShowAnimationTick(Sender: TObject; Value: Extended);
    procedure ShowAnimationFinish(Sender: TObject);
    procedure HideAnimationTick(Sender: TObject; Value: Extended);
    procedure HideAnimationFinish(Sender: TObject);

    procedure OnChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property Opacity: Byte read FOpacity;
    property Position: Integer read FPosition;
    property NeedsPainting: Boolean read FNeedsPainting;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Logo: TPicture read FLogo write SetLogo;
    property Font: TFont read FFont write SetFont;
    property Top: Integer read FTop write SetTop default 18;
    property Right: Integer read FRight write SetRight default 24;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Duration: Integer read FDuration write FDuration default 350;
    property Format: String read FFormat write SetFormat;
    property Interval: Integer read GetInterval write SetInterval default 1000;
    property Corner: TPicture read FCorner write SetCorner;
  end;

{*******************************************************}
{            MediaCenter Player Button Class            }
{*******************************************************}
type
  TMediaCenterPlayerButton = class(TPersistent)
  private
    FOnChange       : TNotifyEvent;
    FOnEnableChange : TNotifyEvent;

    FDisabled : TPicture;
    FNoFocus  : TPicture;
    FFocus    : TPicture;
    FPressed  : TPicture;
    FEnabled  : Boolean;
    FBottom   : Integer;
    FRight    : Integer;
    FRect     : TRect;

    procedure SetDisabled(Picture: TPicture);
    procedure SetNoFocus(Picture: TPicture);
    procedure SetFocus(Picture: TPicture);
    procedure SetPressed(Picture: TPicture);
    procedure SetEnabled(Enabled: Boolean);
    procedure SetBottom(Bottom: Integer);
    procedure SetRight(Right: Integer);

    procedure OnChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property ButtonRect: TRect read FRect write FRect;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnEnableChange: TNotifyEvent read FOnEnableChange write FOnEnableChange;

    property Disabled: TPicture read FDisabled write SetDisabled;
    property NoFocus: TPicture read FNoFocus write SetNoFocus;
    property Focus: TPicture read FFocus write SetFocus;
    property Pressed: TPicture read FPressed write SetPressed;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Bottom: Integer read FBottom write SetBottom;
    property Right: Integer read FRight write SetRight;
  end;

type
  TMediaCenterMuteButtonState = (Mute, UnMute);
  TMediaCenterPlayButtonState = (Play, Pause);

{*******************************************************}
{           MediaCenter Player Controls Class           }
{*******************************************************}
type
  TMediaCenterPlayerControls = class(TPersistent)
  private
    FOnChange : TNotifyEvent;

    FVisible         : Boolean;
    FDuration        : Integer;
    FCorner          : TPicture;
    FDivider         : TPicture;
    FVolumeUp        : TMediaCenterPlayerButton;
    FVolumeUpState   : TMediaCenterButtonState;
    FVolumeDown      : TMediaCenterPlayerButton;
    FVolumeDownState : TMediaCenterButtonState;
    FMute            : TMediaCenterPlayerButton;
    FUnMute          : TMediaCenterPlayerButton;
    FMuteState       : TMediaCenterMuteButtonState;
    FMuteUnMuteState : TMediaCenterButtonState;
    FForward         : TMediaCenterPlayerButton;
    FForwardState    : TMediaCenterButtonState;
    FNext            : TMediaCenterPlayerButton;
    FNextState       : TMediaCenterButtonState;
    FPlay            : TMediaCenterPlayerButton;
    FPause           : TMediaCenterPlayerButton;
    FPlayState       : TMediaCenterPlayButtonState;
    FPlayPauseState  : TMediaCenterButtonState;
    FBackward        : TMediaCenterPlayerButton;
    FBackwardState   : TMediaCenterButtonState;
    FPrevious        : TMediaCenterPlayerButton;
    FPreviousState   : TMediaCenterButtonState;
    FStop            : TMediaCenterPlayerButton;
    FStopState       : TMediaCenterButtonState;

    FShowAnimation : TMediaCenterAnimation;
    FHideAnimation : TMediaCenterAnimation;
    FShowAnimationBusy : Boolean;
    FHideAnimationBusy : Boolean;

    FOpacity       : Byte;
    FPosition      : Integer;
    FNeedsPainting : Boolean;

    procedure SetVisible(Visible: Boolean);
    procedure SetCorner(Corner: TPicture);
    procedure SetDivider(Divider: TPicture);
    procedure SetVolumeUp(VolumeUp: TMediaCenterPlayerButton);
    procedure SetVolumeUpState(State: TMediaCenterButtonState);
    procedure SetVolumeDown(VolumeDown: TMediaCenterPlayerButton);
    procedure SetVolumeDownState(State: TMediaCenterButtonState);
    procedure SetMute(Mute: TMediaCenterPlayerButton);
    procedure SetUnMute(UnMute: TMediaCenterPlayerButton);
    procedure SetMuteState(MuteState: TMediaCenterMuteButtonState);
    procedure SetMuteUnMuteState(State: TMediaCenterButtonState);
    procedure SetForward(Forward: TMediaCenterPlayerButton);
    procedure SetForwardState(State: TMediaCenterButtonState);
    procedure SetNext(Next: TMediaCenterPlayerButton);
    procedure SetNextState(State: TMediaCenterButtonState);
    procedure SetPlay(Play: TMediaCenterPlayerButton);
    procedure SetPause(Pause: TMediaCenterPlayerButton);
    procedure SetPlayState(State: TMediaCenterPlayButtonState);
    procedure SetPlayPauseState(State: TMediaCenterButtonState);
    procedure SetBackward(Backward: TMediaCenterPlayerButton);
    procedure SetBackwardState(State: TMediaCenterButtonState);
    procedure SetPrevious(Next: TMediaCenterPlayerButton);
    procedure SetPreviousState(State: TMediaCenterButtonState);
    procedure SetStop(Stop: TMediaCenterPlayerButton);
    procedure SetStopState(State: TMediaCenterButtonState);

    procedure ShowAnimationTick(Sender: TObject; Value: Extended);
    procedure ShowAnimationFinish(Sender: TObject);
    procedure HideAnimationTick(Sender: TObject; Value: Extended);
    procedure HideAnimationFinish(Sender: TObject);

    procedure OnChanged(Sender: TObject);
    procedure OnEnableChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property Opacity: Byte read FOpacity;
    property Position: Integer read FPosition;

    property VolumeUpState: TMediaCenterButtonState read FVolumeUpState write SetVolumeUpState;
    property VolumeDownState: TMediaCenterButtonState read FVolumeDownState write SetVolumeDownState;
    property MuteUnMuteState: TMediaCenterButtonState read FMuteUnMuteState write SetMuteUnMuteState;
    property ForwardState: TMediaCenterButtonState read FForwardState write SetForwardState;
    property NextState: TMediaCenterButtonState read FNextState write SetNextState;
    property PlayPauseState: TMediaCenterButtonState read FPlayPauseState write SetPlayPauseState;
    property BackwardState: TMediaCenterButtonState read FBackwardState write SetBackwardState;
    property PreviousState: TMediaCenterButtonState read FPreviousState write SetPreviousState;
    property StopState: TMediaCenterButtonState read FStopState write SetStopState;
    property NeedsPainting: Boolean read FNeedsPainting;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Visible: Boolean read FVisible write SetVisible default False;
    property Corner: TPicture read FCorner write SetCorner;
    property Divider: TPicture read FDivider write SetDivider;
    property Duration: Integer read FDuration write FDuration default 350;
    property VolumeUp: TMediaCenterPlayerButton read FVolumeUp write SetVolumeUp;
    property VolumeDown: TMediaCenterPlayerButton read FVolumeDown write SetVolumeDown;
    property Mute: TMediaCenterPlayerButton read FMute write SetMute;
    property UnMute: TMediaCenterPlayerButton read FUnMute write SetUnMute;
    property MuteState: TMediaCenterMuteButtonState read FMuteState write SetMuteState default Mute;
    property Forward: TMediaCenterPlayerButton read FForward write SetForward;
    property Next: TMediaCenterPlayerButton read FNext write SetNext;
    property Play: TMediaCenterPlayerButton read FPlay write SetPlay;
    property Pause: TMediaCenterPlayerButton read FPause write SetPause;
    property PlayState: TMediaCenterPlayButtonState read FPlayState write SetPlayState default Play;
    property Backward: TMediaCenterPlayerButton read FBackward write SetBackward;
    property Previous: TMediaCenterPlayerButton read FPrevious write SetPrevious;
    property Stop: TMediaCenterPlayerButton read FStop write SetStop;
  end;

{*******************************************************}
{            MediaCenter Busy Spinner Class             }
{*******************************************************}
type
  TMediaCenterBusySpinner = class(TPersistent)
  private
    FOnChange : TNotifyEvent;

    FVisible       : Boolean;
    FDuration      : Integer;
    FSpinTimer     : TMediaCenterAnimationTimer;
    FFront         : TPicture;
    FBack          : TPicture;
    FNeedsPainting : Boolean;

    FShowAnimation : TMediaCenterAnimation;
    FHideAnimation : TMediaCenterAnimation;
    FShowAnimationBusy : Boolean;
    FHideAnimationBusy : Boolean;

    FOpacity : Byte;
    FAngle   : Cardinal;

    procedure SetVisible(Visible: Boolean);
    procedure SetInterval(Interval: Integer);
    function GetInterval : Integer;
    procedure SetFront(Front: TPicture);
    procedure SetBack(Back: TPicture);

    procedure ShowAnimationTick(Sender: TObject; Value: Extended);
    procedure ShowAnimationFinish(Sender: TObject);
    procedure HideAnimationTick(Sender: TObject; Value: Extended);
    procedure HideAnimationFinish(Sender: TObject);

    procedure OnSpinTimer(Sender: TObject);
    procedure OnChanged(Sender: TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property Opacity: Byte read FOpacity;
    property Angle: Cardinal read FAngle;
    property NeedsPainting: Boolean read FNeedsPainting;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Visible: Boolean read FVisible write SetVisible default False;
    property Duration: Integer read FDuration write FDuration default 200;
    property Interval: Integer read GetInterval write SetInterval default 10;
    property Front: TPicture read FFront write SetFront;
    property Back: TPicture read FBack write SetBack;
  end;

type
  TMediaCenterPlayerButtonType = (
    pbBackward,
    pbForward,
    pbMute,
    pbUnMute,
    pbNext,
    pbPrevious,
    pbPause,
    pbPlay,
    pbStop,
    pbVolumeDown,
    pbVolumeUp
  );

type
  TMediaCenterPlayerButtonClickEvent = procedure(Button: TMediaCenterPlayerButtonType) of object;
  TMediaCenterPaintEvent             = procedure(Canvas: TDirect2DCanvas) of object;

{*******************************************************}
{                MediaCenter Base Class                 }
{*******************************************************}
type
  TMediaCenterBase = class(TCustomControl)
  private
    { Private declarations }
    FD2DCanvas      : TDirect2DCanvas;
    FBackground     : TMediaCenterBackground;
    FNavigation     : TMediaCenterNavigation;
    FClock          : TMediaCenterClock;
    FPlayerControls : TMediaCenterPlayerControls;
    FBusySpinner    : TMediaCenterBusySpinner;

    FOnGoBackClick  : TNotifyEvent;
    FOnMenuClick    : TNotifyEvent;
    FOnPlayerClick  : TMediaCenterPlayerButtonClickEvent;
    FOnPaint        : TMediaCenterPaintEvent;

    procedure CreateDeviceResources;

    procedure SetBackground(Background: TMediaCenterBackground);
    procedure SetNavigation(Navigation: TMediaCenterNavigation);
    procedure SetClock(Clock: TMediaCenterClock);
    procedure SetPlayerControls(PlayerControls: TMediaCenterPlayerControls);
    procedure SetBusySpinner(BusySpinner: TMediaCenterBusySpinner);

    { Catching paint events }
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    procedure Paint; override;

    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure OnChanged(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Background: TMediaCenterBackground read FBackground write SetBackground;
    property Navigation: TMediaCenterNavigation read FNavigation write SetNavigation;
    property Clock: TMediaCenterClock read FClock write SetClock;
    property PlayerControls: TMediaCenterPlayerControls read FPlayerControls write SetPlayerControls;
    property BusySpinner: TMediaCenterBusySpinner read FBusySpinner write SetBusySpinner;

    property OnGoBackClick: TNotifyEvent read FOnGoBackClick write FOnGoBackClick;
    property OnMenuClick: TNotifyEvent read FOnMenuClick write FOnMenuClick;
    property OnPlayerClick: TMediaCenterPlayerButtonClickEvent read FOnPlayerClick write FOnPlayerClick;
    property OnPaint: TMediaCenterPaintEvent read FOnPaint write FOnPaint;
  end;


{*******************************************************}
{             MediaCenter Component Class               }
{*******************************************************}
type
  TMediaCenter = class(TMediaCenterBase)
  published
    property Align default alLeft;
    property Anchors;
    property Background;
    property Enabled;
    property Navigation;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop default True;
    property Touch;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGoBackClick;
    property OnMenuClick;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;

procedure Register;

implementation

uses
  System.DateUtils,
  System.Math;

procedure MMTimerCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
begin
  with TMediaCenterAnimationTimerThread(dwUser) do
    if Suspended then
    begin
      TimeKillEvent(FTimerID);
      FTimerID := 0;
    end else
      Synchronize(FOwner.DoTimerProc);
end;

{*******************************************************}
{           MediaCenter Animation Timer Thread          }
{*******************************************************}
procedure TMediaCenterAnimationTimerThread.Execute;
begin
  repeat
    FTimerID := TimeSetEvent(FInterval, 0, @MMTimerCallBack, Cardinal(Self), TIME_PERIODIC);
    if FTimerID <> 0 then
      WaitForSingleObject(FEvent, INFINITE);
    if FTimerID <> 0 then
      TimeKillEvent(FTimerID);
  until Terminated;
end;

{*******************************************************}
{           MediaCenter Animation Timer Class           }
{*******************************************************}
constructor TMediaCenterAnimationTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimerThread:= TMediaCenterAnimationTimerThread.Create(True);
  with FTimerThread do
  begin
    FOwner    := Self;
    FTimerID  := 0;
    FInterval := 10;
    Priority  := tpNormal;
    FEvent    := CreateEvent(nil, False, False, nil)
  end;
end;

destructor TMediaCenterAnimationTimer.Destroy;
begin
  with FTimerThread do
  begin
    FEnabled := False;
    Terminate;
    SetEvent(FEvent);
    {$WARN SYMBOL_DEPRECATED OFF}
    if Suspended then Resume;
    {$WARN SYMBOL_DEPRECATED ON}
    WaitFor;
    CloseHandle(FEvent);
    Free;
  end;
  inherited Destroy;
end;

procedure TMediaCenterAnimationTimer.DoTimerProc;
begin
  if FEnabled and Assigned(FOnTimer) and not (csDestroying in ComponentState) then
  try
    FOnTimer(Self);
  except
  end
end;

procedure TMediaCenterAnimationTimer.SetEnabled(Enabled: Boolean);
begin
  if Enabled <> FEnabled then
  begin
    FEnabled:= Enabled;
    if FEnabled then
    begin
      if FTimerThread.FInterval > 0 then
      begin
        SetEvent(FTimerThread.FEvent);
        {$WARN SYMBOL_DEPRECATED OFF}
        FTimerThread.Resume;
        {$WARN SYMBOL_DEPRECATED ON}
      end;
    end else
      {$WARN SYMBOL_DEPRECATED OFF}
      FTimerThread.Suspend;
      {$WARN SYMBOL_DEPRECATED ON}
  end
end;

function TMediaCenterAnimationTimer.GetInterval: Cardinal;
begin
  Result := FTimerThread.FInterval;
end;

procedure TMediaCenterAnimationTimer.SetInterval(Interval: Cardinal);
var
  SaveEnabled : Boolean;
begin
  if Interval <> FTimerThread.FInterval then
  begin
    SaveEnabled := FEnabled;
    Enabled     := False;
    FTimerThread.FInterval:= Interval;
    Enabled := SaveEnabled;
  end
end;

{$WARN SYMBOL_PLATFORM OFF}
function TMediaCenterAnimationTimer.GetThreadPriority: TThreadPriority;
begin
  Result := FTimerThread.Priority;
end;

procedure TMediaCenterAnimationTimer.SetThreadPriority(Priority: TThreadPriority);
begin
  FTimerThread.Priority := Priority;
end;
{$WARN SYMBOL_PLATFORM ON}

{*******************************************************}
{              MediaCenter Animation Class              }
{*******************************************************}
constructor TMediaCenterAnimation.Create;
begin
  inherited Create;

  FTimer := TMediaCenterAnimationTimer.Create(nil);
  FTimer.Enabled  := False;
  FTimer.Interval := 10;
  FTimer.OnTimer  := OnTimer;
  FTimer.ThreadPriority := tpNormal;

  FDelayTimer := TMediaCenterAnimationTimer.Create(nil);
  FDelayTimer.Enabled := False;
  FDelayTimer.OnTimer := OnDelayTimer;
  FDelayTimer.ThreadPriority := tpNormal;
end;

destructor TMediaCenterAnimation.Destroy;
begin
  FTimer.Free;
  FDelayTimer.Free;

  inherited Destroy;
end;

procedure TMediaCenterAnimation.OnTimer(Sender: TObject);
var
  Value: Extended;
begin
  FTimer.Enabled := False;
  Value := FEasingFunc(MilliSecondsBetween(FStartTime, Now) / FAnimLength, FStartPos, FDifferent);
  if Assigned(OnTick) then OnTick(Self, Value);

  if MilliSecondsBetween(FStartTime, Now) < FAnimLength then
  begin
    FTimer.Enabled := True;
  end else
  begin
    FinishAnimation;
  end;
end;

procedure TMediaCenterAnimation.OnDelayTimer(Sender: TObject);
begin
  FDelayTimer.Enabled := False;
  FStartTime          := Now;
  FTimer.Enabled      := True;
end;

procedure TMediaCenterAnimation.FinishAnimation;
begin
  if Assigned(OnFinish) then OnFinish(Self);
end;

procedure TMediaCenterAnimation.Start(StartPos, EndPos, Length: Integer; Easing: TMediaCenterAnimationEasingType);
begin
  Start(StartPos, EndPos, Length, Easing, 5, -1);
end;

procedure TMediaCenterAnimation.Start(StartPos, EndPos, Length: Integer; Easing: TMediaCenterAnimationEasingType; CycleTime, StartDelay: Integer);
begin
  FEasingFunc := GetEasingFunction(Easing);
  FStartPos   := StartPos;
  FStartTime  := Now;
  FDifferent  := EndPos;
  FAnimLength := Length;

  FTimer.Enabled  := False;
  FTimer.Interval := CycleTime;

  if StartDelay = -1 then
    FTimer.Enabled := True
  else
  begin
    FDelayTimer.Interval := StartDelay;
    FDelayTimer.Enabled  := True;
  end;
end;

procedure TMediaCenterAnimation.Stop;
begin
  FTimer.Enabled      := False;
  FDelayTimer.Enabled := False;
  FinishAnimation;
end;

class function TMediaCenterAnimation.GetEasingFunction(Easing: TMediaCenterAnimationEasingType): TMediaCenterAnimationEasingFunction;
begin
  case Easing of
    etBackEaseIn     : Result := BackEaseIn;
    etbackEaseOut    : Result := backEaseOut;
    etBackEaseInOut  : Result := BackEaseInOut;
    etBounceEaseIn   : Result := BounceEaseIn;
    etBounceEaseOut  : Result := BounceEaseOut;
    etCircEaseIn     : Result := CircEaseIn;
    etCircEaseOut    : Result := CircEaseOut;
    etCircEaseInOut  : Result := CircEaseInOut;
    etCubicEaseIn    : Result := CubicEaseIn;
    etCubicEaseOut   : Result := CubicEaseOut;
    etCubicEaseInOut : Result := CubicEaseInOut;
    etElasticEaseIn  : Result := ElasticEaseIn;
    etElasticEaseOut : Result := ElasticEaseOut;
    etExpoEaseIn     : Result := ExpoEaseIn;
    etExpoEaseOut    : Result := ExpoEaseOut;
    etExpoEaseInOut  : Result := ExpoEaseInOut;
    etQuadEaseIn     : Result := QuadEaseIn;
    etQuadEaseOut    : Result := QuadEaseOut;
    etQuadEaseInOut  : Result := QuadEaseInOut;
    etQuartEaseIn    : Result := QuartEaseIn;
    etQuartEaseOut   : Result := QuartEaseOut;
    etQuartEaseInOut : Result := QuartEaseInOut;
    etQuintEaseIn    : Result := QuintEaseIn;
    etQuintEaseOut   : Result := QuintEaseOut;
    etQuintEaseInOut : Result := QuintEaseInOut;
    etSineEaseIn     : Result := SineEaseIn;
    etSineEaseOut    : Result := SineEaseOut;
    etSineEaseInOut  : Result := SineEaseInOut;
  else
    Result := QuartEaseInOut;
  end;
end;

class function TMediaCenterAnimation.BackEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, S : Extended;
begin
  C := diff;
  S := 1.70158;
  Result := c * p * p * ((S + 1) * P - S) + FirstNum;
end;

class function TMediaCenterAnimation.BackEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, S : Extended;
begin
  C := Diff;
  S := 1.70158;
  P := P - 1;
  Result := C * (P * P * ((S + 1) * P + S) + 1) + FirstNum;
end;

class function TMediaCenterAnimation.BackEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, S : Extended;
begin
  C := Diff;
  S := 1.70158 * 1.525;
  P := P / 0.5;
  if (P < 1) then
    Result := C / 2 * (P * P * ((S + 1) * P - S))  + FirstNum
  else
  begin
    P := P - 2;
    Result := C / 2 * (P * P *((S + 1) * P + S) + 2) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.BounceEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, I : Extended;
begin
  C := Diff;
  I := BounceEaseOut(1 - P, 0, Diff);
  Result := C - I + FirstNum;
end;

class function TMediaCenterAnimation.BounceEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C: Extended;
begin
  C := Diff;
  if (P < 1 / 2.75) then
    Result := C * (7.5625 * P * P) + FirstNum
  else
  if (P < 2 / 2.75) then
  begin
    P := P - (1.5 / 2.75);
    Result := C * (7.5625 * P * P + 0.75) + FirstNum;
  end else
  if (P < 2.5 / 2.75) then
  begin
    P := P - (2.25 / 2.75);
    Result := C * (7.5625 * P * P + 0.9375) + FirstNum;
  end else
  begin
    P := P - (2.625 / 2.75);
    Result := C * (7.5625 * P * P + 0.984375) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.CircEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := -C * (Sqrt(1 - P * P) - 1 ) + FirstNum;
end;

class function TMediaCenterAnimation.CircEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P - 1;
  Result := C * Sqrt(1 - P * P) + FirstNum;
end;

class function TMediaCenterAnimation.CircEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P / 0.5;
  if (P < 1) then
    Result := -C / 2 * (Sqrt(1 - P * P) - 1) + FirstNum
  else
  begin
    P := P - 2;
    Result := C / 2 * (Sqrt(1 - P * P) + 1) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.CubicEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := C * (P * P * P) + FirstNum;
end;

class function TMediaCenterAnimation.CubicEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P -1;
  Result := C * (P * P * P + 1) + FirstNum;
end;

class function TMediaCenterAnimation.CubicEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P / 0.5;
  if (P < 1) then
    Result := C / 2 * P * P * P + FirstNum
  else
  begin
    P := P - 2;
    Result := C / 2 * (P * P * P + 2) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.ElasticEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, Period, S, Amplitude : Extended;
begin
  C := diff;

  if P = 0 then Exit(FirstNum);
  if P = 1 then Exit(C);

  Period := 0.25;
  Amplitude := C;

  if (Amplitude < Abs(C)) then
  begin
    Amplitude := C;
    S := Period / 4;
  end else
  begin
    S := Period / (2 * PI) * ArcSin(C / Amplitude);
  end;
  P := P - 1;
  Result := -(Amplitude * Power(2, 10 * P) * Sin((P * 1 - S) * (2 * PI) / Period)) + FirstNum;
end;

class function TMediaCenterAnimation.ElasticEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C, Period, S, Amplitude : Extended;
begin
  C := Diff;

  if Diff = 0 then Exit(C);
  if P = 0 then Exit(FirstNum);
  if P = 1 then Exit(C);

  Period := 0.25;
  Amplitude := C;

  if (Amplitude < Abs(C)) then
  begin
    Amplitude := C;
    S := Period / 4;
  end else
  begin
    S := Period / (2 * PI) * ArcSin(C / Amplitude);
  end;
  Result := -(Amplitude * Power(2, -10 * P) * Sin((P * 1 - S) * (2 * PI) / Period)) + C + FirstNum;
end;

class function TMediaCenterAnimation.ExpoEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;

  if (P = 0) then
    Result := FirstNum
  else
  begin
    P := P - 1;
    Result := C * Power(2, 10 * P) + FirstNum - C * 0.001;
  end;
end;

class function TMediaCenterAnimation.ExpoEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;

  if (P = 1) then
    Result := C
  else
  begin
    Result := Diff * 1.001 * (-Power(2, -10 * P) + 1) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.ExpoEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;

  if (P = 0) then Exit(FirstNum);
  if (P = 1) then Exit(C);

  P := P / 0.5;
  if P < 1 then
    Result := C / 2 * Power(2, 10 * (P - 1)) + FirstNum - C * 0.0005
  else
  begin
    P := P - 1;
    Result := C / 2 * 1.0005 * (-Power(2, -10 * P) + 2) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.QuadEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C: Extended;
begin
  C := Diff;
  Result := C * P * P + FirstNum;
end;

class function TMediaCenterAnimation.QuadEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := -C * P * (P - 2) + FirstNum;
end;

class function TMediaCenterAnimation.QuadEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;

  P := P / 0.5;
  if P < 1 then
    Result := C / 2 * P * P + FirstNum
  else
  begin
    P := P - 1;
    Result := -C / 2 * (P * (P - 2) - 1) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.QuartEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := C * P * P * P * P + FirstNum;
end;

class function TMediaCenterAnimation.QuartEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P - 1;
  Result := -C * (P * P * P * P - 1) + FirstNum;
end;

class function TMediaCenterAnimation.QuartEaseInOut(p: Extended; firstNum: integer; diff: integer): Extended;
var
  C : Extended;
begin
  C := Diff;

  P := P / 0.5;
  if P < 1 then
    Result := C / 2 * P * P * P * P + FirstNum
  else
  begin
    P := P - 2;
    Result := -C / 2 * (P * P * P * P - 2) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.QuintEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := C * P * P * P * P * P + FirstNum;
end;

class function TMediaCenterAnimation.QuintEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  P := P - 1;
  Result := C * (P * P * P * P * P + 1) + FirstNum;
end;

class function TMediaCenterAnimation.QuintEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;

  P := P / 0.5;
  if P < 1 then
    Result := C / 2 * P * P * P * P * P + FirstNum
  else
  begin
    P := P - 2;
    Result := C / 2 * (P * P * P * P * P + 2) + FirstNum;
  end;
end;

class function TMediaCenterAnimation.SineEaseIn(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := -C * Cos(P * (PI / 2)) + C + FirstNum;
end;

class function TMediaCenterAnimation.SineEaseOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := C * Sin(P * (PI / 2)) + FirstNum;
end;

class function TMediaCenterAnimation.sineEaseInOut(P: Extended; FirstNum, Diff: Integer) : Extended;
var
  C : Extended;
begin
  C := Diff;
  Result := -C / 2 * (Cos(PI * P) - 1) + FirstNum;
end;

{*******************************************************}
{             MediaCenter Background Class              }
{*******************************************************}
constructor TMediaCenterBackground.Create;
begin
  inherited Create;

  FPicture := TPicture.Create;
  FPicture.OnChange := OnChanged;

  FStretch := smStretch;
  FCenter  := True;
  FColor   := clMediaCenterBlue1;
end;

destructor TMediaCenterBackground.Destroy;
begin
  FPicture.Free;

  inherited Destroy;
end;

procedure TMediaCenterBackground.SetPicture(Picture: TPicture);
begin
  FPicture.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBackground.SetStretch(Stretch: TMediaCenterBackgroundStretchMode);
begin
  if (Stretch <> FStretch) then
  begin
    FStretch := Stretch;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterBackground.SetCenter(Center: Boolean);
begin
  if (Center <> FCenter) then
  begin
    FCenter := Center;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterBackground.SetColor(Color: TColor);
begin
  if (Color <> FColor) then
  begin
    FColor := Color;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterBackground.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBackground.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterBackground) then
  begin
    FStretch := (Source as TMediaCenterBackground).StretchMode;
    FCenter  := (Source as TMediaCenterBackground).Center;
    FColor   := (Source as TMediaCenterBackground).Color;
    FPicture.Assign((Source as TMediaCenterBackground).Picture);
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{          MediaCenter Navigation Button Class          }
{*******************************************************}
constructor TMediaCenterNavigationButton.Create;
begin
  inherited Create;

  FDisabled := TPicture.Create;
  FDisabled.OnChange := OnChanged;
  FNoFocus  := TPicture.Create;
  FNoFocus.OnChange := OnChanged;
  FFocus    := TPicture.Create;
  FFocus.OnChange := OnChanged;
  FPressed  := TPicture.Create;
  FPressed.OnChange := OnChanged;
  FEnabled := True;
end;

destructor TMediaCenterNavigationButton.Destroy;
begin
  FDisabled.Free;
  FNoFocus.Free;
  FFocus.Free;
  FPressed.Free;

  inherited Destroy;
end;

procedure TMediaCenterNavigationButton.SetDisabled(Picture: TPicture);
begin
  FDisabled.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.SetNoFocus(Picture: TPicture);
begin
  FNoFocus.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.SetFocus(Picture: TPicture);
begin
  FFocus.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.SetPressed(Picture: TPicture);
begin
  FPressed.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.SetEnabled(Enabled: Boolean);
begin
  FEnabled := Enabled;
  if Assigned(FOnChange) then FOnChange(Self);
  if Assigned(FOnEnableChange) then FOnEnableChange(Self);
end;

procedure TMediaCenterNavigationButton.SetTop(Top: Integer);
begin
  FTop := Top;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.SetLeft(Left: Integer);
begin
  FLeft := Left;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigationButton.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterNavigationButton) then
  begin
    FDisabled.Assign((Source as TMediaCenterNavigationButton).Disabled);
    FNoFocus.Assign((Source as TMediaCenterNavigationButton).NoFocus);
    FFocus.Assign((Source as TMediaCenterNavigationButton).Focus);
    FPressed.Assign((Source as TMediaCenterNavigationButton).Pressed);
    FEnabled := (Source as TMediaCenterNavigationButton).Enabled;
    FTop     := (Source as TMediaCenterNavigationButton).Top;
    FLeft    := (Source as TMediaCenterNavigationButton).Left;
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{             MediaCenter Navigation Class              }
{*******************************************************}
constructor TMediaCenterNavigation.Create;
begin
  inherited Create;

  FGoBack := TMediaCenterNavigationButton.Create;
  FGoBack.OnChange := OnChanged;
  FGoBack.OnEnableChange := OnEnableChanged;
  FGoBack.FTop  := 8;
  FGoBack.FLeft := 8;
  FMenu := TMediaCenterNavigationButton.Create;
  FMenu.OnChange := OnChanged;
  FMenu.OnEnableChange := OnEnableChanged;
  FMenu.FTop  := 9;
  FMenu.FLeft := 54;
  FVisible  := True;

  FShowAnimation := TMediaCenterAnimation.Create;
  FShowAnimation.OnTick   := ShowAnimationTick;
  FShowAnimation.OnFinish := ShowAnimationFinish;
  FHideAnimation := TMediaCenterAnimation.Create;
  FHideAnimation.OnTick   := HideAnimationTick;
  FHideAnimation.OnFinish := HideAnimationFinish;
  FShowAnimationBusy := False;
  FHideAnimationBusy := False;
  FCorner := TPicture.Create;
  FCorner.OnChange := OnCHanged;

  FOpacity  := 255;
  FPosition := 25;
  FDuration := 350;
  FNeedsPainting := True;
end;

destructor TMediaCenterNavigation.Destroy;
begin
  FGoBack.Free;
  FMenu.Free;

  FShowAnimation.Free;
  FHideAnimation.Free;
  FCorner.Free;

  inherited Destroy;
end;

procedure TMediaCenterNavigation.SetGoBack(GoBack: TMediaCenterNavigationButton);
begin
  FGoBack.Assign(GoBack);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigation.SetGoBackState(State: TMediaCenterButtonState);
begin
  if (GoBackState <> State) then
  begin
    FGoBackState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterNavigation.SetMenu(Menu: TMediaCenterNavigationButton);
begin
  FMenu.Assign(Menu);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigation.SetMenuState(State: TMediaCenterButtonState);
begin
  if (MenuState <> State) then
  begin
    FMenuState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterNavigation.SetVisible(Visible: Boolean);
begin
  if (not FShowAnimationBusy) and (not FHideAnimationBusy) then
  begin
    if Visible then
    begin
      FShowAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FShowAnimationBusy := True;
      FNeedsPainting     := True;
    end else
    begin
      FHideAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FHideAnimationBusy := True;
    end;
  end;
end;

procedure TMediaCenterNavigation.SetCorner(Corner: TPicture);
begin
  FCorner.Assign(Corner);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigation.ShowAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Min(255, Ceil(Value));
  FPosition := Min(25, Round(FOpacity / 10));
end;

procedure TMediaCenterNavigation.ShowAnimationFinish(Sender: TObject);
begin
  FShowAnimationBusy := False;
  FVisible := True;
end;

procedure TMediaCenterNavigation.HideAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Max(0, Floor(255 - Value));
  FPosition := Max(0, Round(FOpacity / 10));
end;

procedure TMediaCenterNavigation.HideAnimationFinish(Sender: TObject);
begin
  FHideAnimationBusy := False;
  FNeedsPainting := False;
  FVisible := False;
end;

procedure TMediaCenterNavigation.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterNavigation.OnEnableChanged(Sender: TObject);
begin
  if (Sender = GoBack) then
  begin
    if GoBack.Enabled then
      GoBackState := bsNoFocus
    else
      GoBackState := bsDisabled;
  end;
  if (Sender = Menu) then
  begin
    if Menu.Enabled then
      MenuState := bsNoFocus
    else
      MenuState := bsDisabled;
  end;
end;

procedure TMediaCenterNavigation.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterNavigation) then
  begin
    FGoBack.Assign((Source as TMediaCenterNavigation).GoBack);
    FMenu.Assign((Source as TMediaCenterNavigation).Menu);
    FCorner.Assign((Source as TMediaCenterNavigation).Corner);
    FVisible  := (Source as TMediaCenterNavigation).Visible;
    FDuration := (Source as TMediaCenterNavigation).Duration;
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{                MediaCenter Clock Class                }
{*******************************************************}
constructor TMediaCenterClock.Create;
begin
  inherited Create;

  FLogo := TPicture.Create;
  FLogo.OnChange := OnChanged;
  FFont := TFont.Create;
  FFont.OnChange := OnChanged;
  FFont.Color := clMediaCenterWhite;
  FFont.Size  := 16;

  FShowAnimation := TMediaCenterAnimation.Create;
  FShowAnimation.OnTick   := ShowAnimationTick;
  FShowAnimation.OnFinish := ShowAnimationFinish;
  FHideAnimation := TMediaCenterAnimation.Create;
  FHideAnimation.OnTick   := HideAnimationTick;
  FHideAnimation.OnFinish := HideAnimationFinish;
  FShowAnimationBusy := False;
  FHideAnimationBusy := False;

  FVisible  := True;
  FTop      := 18;
  FRight    := 24;
  FOpacity  := 255;
  FPosition := 25;
  FDuration := 350;
  FFormat   := 'hh:mm';
  FNeedsPainting := True;

  FClockTimer := TMediaCenterAnimationTimer.Create(nil);
  FClockTimer.Interval := 1000;
  FClockTimer.Enabled  := True;
  FClockTimer.OnTimer  := OnChanged;

  FCorner := TPicture.Create;
  FCorner.OnChange := OnChanged;
end;

destructor TMediaCenterClock.Destroy;
begin
  FLogo.Free;
  FFont.Free;

  FShowAnimation.Free;
  FHideAnimation.Free;

  FClockTimer.Free;
  FCorner.Free;

  inherited Destroy;
end;

procedure TMediaCenterClock.SetLogo(Logo: TPicture);
begin
  FLogo.Assign(Logo);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterClock.SetFont(Font: TFont);
begin
  FFont.Assign(Font);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterClock.SetTop(Top: Integer);
begin
  if (FTop <> Top) and (Top > 0) then
  begin
    FTop := Top;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterClock.SetRight(Right: Integer);
begin
  if (FRight <> Right) and (Right > 0) then
  begin
    FRight := Right;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterClock.SetVisible(Visible: Boolean);
begin
  if (not FShowAnimationBusy) and (not FHideAnimationBusy) then
  begin
    if Visible then
    begin
      FClockTimer.Enabled := True;
      FShowAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FShowAnimationBusy := True;
      FNeedsPainting     := True;
    end else
    begin
      FHideAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FHideAnimationBusy := True;
    end;
  end;
end;

procedure TMediaCenterClock.SetFormat(Format: string);
begin
  FFormat := Format;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterClock.SetInterval(Interval: Integer);
begin
  FClockTimer.Interval := Interval;
end;

function TMediaCenterClock.GetInterval : Integer;
begin
  Result := FClockTimer.Interval;
end;

procedure TMediaCenterClock.SetCorner(Corner: TPicture);
begin
  FCorner.Assign(Corner);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterClock.ShowAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Min(255, Ceil(Value));
  FPosition := Min(25, Round(FOpacity / 10));
end;

procedure TMediaCenterClock.ShowAnimationFinish(Sender: TObject);
begin
  FShowAnimationBusy := False;
  FVisible := True;
end;

procedure TMediaCenterClock.HideAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Max(0, Floor(255 - Value));
  FPosition := Max(0, Round(FOpacity / 10));
end;

procedure TMediaCenterClock.HideAnimationFinish(Sender: TObject);
begin
  FHideAnimationBusy  := False;
  FClockTimer.Enabled := False;
  FNeedsPainting := False;
  FVisible := False;
end;

procedure TMediaCenterClock.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterClock.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterClock) then
  begin
    FLogo.Assign((Source as TMediaCenterClock).Logo);
    FFont.Assign((Source as TMediaCenterClock).Font);
    FCorner.Assign((Source as TMediaCenterClock).Corner);
    FVisible  := (Source as TMediaCenterClock).Visible;
    FDuration := (Source as TMediaCenterClock).Duration;
    FTop      := (Source as TMediaCenterClock).Top;
    FRight    := (Source as TMediaCenterClock).Right;
    FFormat   := (Source as TMediaCenterClock).Format;
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{            MediaCenter Player Button Class            }
{*******************************************************}
constructor TMediaCenterPlayerButton.Create;
begin
  inherited Create;

  FDisabled := TPicture.Create;
  FDisabled.OnChange := OnChanged;
  FNoFocus  := TPicture.Create;
  FNoFocus.OnChange := OnChanged;
  FFocus    := TPicture.Create;
  FFocus.OnChange := OnChanged;
  FPressed  := TPicture.Create;
  FPressed.OnChange := OnChanged;
  FEnabled := True;
end;

destructor TMediaCenterPlayerButton.Destroy;
begin
  FDisabled.Free;
  FNoFocus.Free;
  FFocus.Free;
  FPressed.Free;

  inherited Destroy;
end;

procedure TMediaCenterPlayerButton.SetDisabled(Picture: TPicture);
begin
  FDisabled.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.SetNoFocus(Picture: TPicture);
begin
  FNoFocus.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.SetFocus(Picture: TPicture);
begin
  FFocus.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.SetPressed(Picture: TPicture);
begin
  FPressed.Assign(Picture);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.SetEnabled(Enabled: Boolean);
begin
  FEnabled := Enabled;
  if Assigned(FOnChange) then FOnChange(Self);
  if Assigned(FOnEnableChange) then FOnEnableChange(Self);
end;

procedure TMediaCenterPlayerButton.SetBottom(Bottom: Integer);
begin
  FBottom := Bottom;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.SetRight(Right: Integer);
begin
  FRight := Right;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerButton.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterPlayerButton) then
  begin
    FDisabled.Assign((Source as TMediaCenterPlayerButton).Disabled);
    FNoFocus.Assign((Source as TMediaCenterPlayerButton).NoFocus);
    FFocus.Assign((Source as TMediaCenterPlayerButton).Focus);
    FPressed.Assign((Source as TMediaCenterPlayerButton).Pressed);
    FEnabled := (Source as TMediaCenterPlayerButton).Enabled;
    FBottom  := (Source as TMediaCenterPlayerButton).Bottom;
    FRight   := (Source as TMediaCenterPlayerButton).Right;
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{           MediaCenter Player Controls Class           }
{*******************************************************}
constructor TMediaCenterPlayerControls.Create;
begin
  inherited Create;

  FVisible  := False;
  FDuration := 350;
  FOpacity  := 0;
  FPosition := 0;

  FCorner := TPicture.Create;
  FCorner.OnChange := OnChanged;
  FDivider := TPicture.Create;
  FDivider.OnChange := OnChanged;
  FVolumeUp := TMediaCenterPlayerButton.Create;
  FVolumeUp.OnChange := OnChanged;
  FVolumeUp.OnEnableChange := OnEnableChanged;
  FVolumeUp.Right  := 11;
  FVolumeUp.Bottom := 15;
  FVolumeDown := TMediaCenterPlayerButton.Create;
  FVolumeDown.OnChange := OnChanged;
  FVolumeDown.OnEnableChange := OnEnableChanged;
  FVolumeDown.Right  := 55;
  FVolumeDown.Bottom := 15;
  FMute := TMediaCenterPlayerButton.Create;
  FMute.OnChange := OnChanged;
  FMute.OnEnableChange := OnEnableChanged;
  FMute.Right  := 99;
  FMute.Bottom := 15;
  FUnMute := TMediaCenterPlayerButton.Create;
  FUnMute.OnChange := OnChanged;
  FUnMute.OnEnableChange := OnEnableChanged;
  FUnMute.Right  := 99;
  FUnMute.Bottom := 15;
  FMuteState  := TMediaCenterMuteButtonState.Mute;
  FForward := TMediaCenterPlayerButton.Create;
  FForward.OnChange := OnChanged;
  FForward.OnEnableChange := OnEnableChanged;
  FForward.Right  := 149;
  FForward.Bottom := 15;
  FNext := TMediaCenterPlayerButton.Create;
  FNext.OnChange := OnChanged;
  FNext.OnEnableChange := OnEnableChanged;
  FNext.Right  := 195;
  FNext.Bottom := 15;
  FPlay := TMediaCenterPlayerButton.Create;
  FPlay.OnChange := OnChanged;
  FPlay.OnEnableChange := OnEnableChanged;
  FPlay.Right := 240;
  FPlay.Bottom := 8;
  FPause := TMediaCenterPlayerButton.Create;
  FPause.OnChange := OnChanged;
  FPause.OnEnableChange := OnEnableChanged;
  FPause.Right := 240;
  FPause.Bottom := 8;
  FPrevious := TMediaCenterPlayerButton.Create;
  FPrevious.OnChange := OnChanged;
  FPrevious.OnEnableChange := OnEnableChanged;
  FPrevious.Right  := 290;
  FPrevious.Bottom := 15;
  FBackward := TMediaCenterPlayerButton.Create;
  FBackward.OnChange := OnChanged;
  FBackward.OnEnableChange := OnEnableChanged;
  FBackward.Right  := 334;
  FBackward.Bottom := 15;
  FStop := TMediaCenterPlayerButton.Create;
  FStop.OnChange := OnChanged;
  FStop.OnEnableChange := OnEnableChanged;
  FStop.Right  := 384;
  FStop.Bottom := 15;

  FShowAnimation := TMediaCenterAnimation.Create;
  FShowAnimation.OnTick   := ShowAnimationTick;
  FShowAnimation.OnFinish := ShowAnimationFinish;
  FHideAnimation := TMediaCenterAnimation.Create;
  FHideAnimation.OnTick   := HideAnimationTick;
  FHideAnimation.OnFinish := HideAnimationFinish;
  FShowAnimationBusy := False;
  FHideAnimationBusy := False;
end;

destructor TMediaCenterPlayerControls.Destroy;
begin
  FCorner.Free;
  FDivider.Free;
  FVolumeUp.Free;
  FVolumeDown.Free;
  FMute.Free;
  FUnMute.Free;
  FForward.Free;
  FNext.Free;
  FPlay.Free;
  FPause.Free;
  FBackward.Free;
  FPrevious.Free;
  FStop.Free;

  FShowAnimation.Free;
  FHideAnimation.Free;

  inherited Destroy;
end;

procedure TMediaCenterPlayerControls.SetVisible(Visible: Boolean);
begin
  if (not FShowAnimationBusy) and (not FHideAnimationBusy) then
  begin
    if Visible then
    begin
      FShowAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FShowAnimationBusy := True;
      FNeedsPainting     := True;
    end else
    begin
      FHideAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FHideAnimationBusy := True;
    end;
  end;
end;

procedure TMediaCenterPlayerControls.SetCorner(Corner: TPicture);
begin
  FCorner.Assign(Corner);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetDivider(Divider: TPicture);
begin
  FDivider.Assign(Divider);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetVolumeUp(VolumeUp: TMediaCenterPlayerButton);
begin
  FVolumeUp.Assign(VolumeUp);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetVolumeUpState(State: TMediaCenterButtonState);
begin
  if (VolumeUpState <> State) then
  begin
    FVolumeUpState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetVolumeDown(VolumeDown: TMediaCenterPlayerButton);
begin
  FVolumeDown.Assign(VolumeDown);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetVolumeDownState(State: TMediaCenterButtonState);
begin
  if (VolumeDownState <> State) then
  begin
    FVolumeDownState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetMute(Mute: TMediaCenterPlayerButton);
begin
  FMute.Assign(Mute);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetUnMute(UnMute: TMediaCenterPlayerButton);
begin
  FUnMute.Assign(UnMute);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetMuteState(MuteState: TMediaCenterMuteButtonState);
begin
  FMuteState := MuteState;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetMuteUnMuteState(State: TMediaCenterButtonState);
begin
  if (MuteUnMuteState <> State) then
  begin
    FMuteUnMuteState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetForward(Forward: TMediaCenterPlayerButton);
begin
  FForward.Assign(Forward);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetForwardState(State: TMediaCenterButtonState);
begin
  if (ForwardState <> State) then
  begin
    FForwardState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetNext(Next: TMediaCenterPlayerButton);
begin
  FNext.Assign(Next);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetNextState(State: TMediaCenterButtonState);
begin
  if (NextState <> State) then
  begin
    FNextState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetPlay(Play: TMediaCenterPlayerButton);
begin
  FPlay.Assign(Next);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetPause(Pause: TMediaCenterPlayerButton);
begin
  FPause.Assign(Next);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetPlayState(State: TMediaCenterPlayButtonState);
begin
  if (PlayState <> State) then
  begin
    FPlayState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetPlayPauseState(State: TMediaCenterButtonState);
begin
  if (PlayPauseState <> State) then
  begin
    FPlayPauseState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetBackward(Backward: TMediaCenterPlayerButton);
begin
  FBackward.Assign(Next);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetBackwardState(State: TMediaCenterButtonState);
begin
  if (BackwardState <> State) then
  begin
    FBackwardState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetPrevious(Next: TMediaCenterPlayerButton);
begin
  FPrevious.Assign(Next);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetPreviousState(State: TMediaCenterButtonState);
begin
  if (PreviousState <> State) then
  begin
    FPreviousState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.SetStop(Stop: TMediaCenterPlayerButton);
begin
  FStop.Assign(Stop);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.SetStopState(State: TMediaCenterButtonState);
begin
  if (StopState <> State) then
  begin
    FStopState := State;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TMediaCenterPlayerControls.ShowAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Min(255, Max(0, Ceil(Value)));
  FPosition := Min(25, Round(FOpacity / 10));
end;

procedure TMediaCenterPlayerControls.ShowAnimationFinish(Sender: TObject);
begin
  FShowAnimationBusy := False;
  FVisible := True;
end;

procedure TMediaCenterPlayerControls.HideAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity  := Max(0, Floor(255 - Value));
  FPosition := Max(0, Round(FOpacity / 10));
end;

procedure TMediaCenterPlayerControls.HideAnimationFinish(Sender: TObject);
begin
  FHideAnimationBusy := False;
  FNeedsPainting     := True;
  FVisible := False;
end;

procedure TMediaCenterPlayerControls.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterPlayerControls.OnEnableChanged(Sender: TObject);
begin
  if (Sender = VolumeUp) then
  begin
    if VolumeUp.Enabled then
      VolumeUpState := bsNoFocus
    else
      VolumeUpState := bsDisabled;
  end;
  if (Sender = VolumeDown) then
  begin
    if VolumeDown.Enabled then
      VolumeDownState := bsNoFocus
    else
      VolumeDownState := bsDisabled;
  end;
  if (Sender = Mute) then
  begin
    if Mute.Enabled then
      MuteUnMuteState := bsNoFocus
    else
      MuteUnMuteState := bsDisabled;
  end;
  if (Sender = UnMute) then
  begin
    if UnMute.Enabled then
      MuteUnMuteState := bsNoFocus
    else
      MuteUnMuteState := bsDisabled;
  end;
  if (Sender = Forward) then
  begin
    if Forward.Enabled then
      ForwardState := bsNoFocus
    else
      ForwardState := bsDisabled;
  end;
  if (Sender = Next) then
  begin
    if Next.Enabled then
      NextState := bsNoFocus
    else
      NextState := bsDisabled;
  end;
  if (Sender = Play) then
  begin
    if Play.Enabled then
      PlayPauseState := bsNoFocus
    else
      PlayPauseState := bsDisabled;
  end;
  if (Sender = Pause) then
  begin
    if Pause.Enabled then
      PlayPauseState := bsNoFocus
    else
      PlayPauseState := bsDisabled;
  end;
  if (Sender = Backward) then
  begin
    if Backward.Enabled then
      BackwardState := bsNoFocus
    else
      BackwardState := bsDisabled;
  end;
  if (Sender = Previous) then
  begin
    if Previous.Enabled then
      PreviousState := bsNoFocus
    else
      PreviousState := bsDisabled;
  end;
  if (Sender = Stop) then
  begin
    if Stop.Enabled then
      StopState := bsNoFocus
    else
      StopState := bsDisabled;
  end;
end;

procedure TMediaCenterPlayerControls.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterPlayerControls) then
  begin
    FCorner.Assign((Source as TMediaCenterPlayerControls).Corner);
    FVolumeUp.Assign((Source as TMediaCenterPlayerControls).VolumeUp);
    FVolumeDown.Assign((Source as TMediaCenterPlayerControls).VolumeDown);
    FMute.Assign((Source as TMediaCenterPlayerControls).Mute);
    FUnMute.Assign((Source as TMediaCenterPlayerControls).UnMute);
    FForward.Assign((Source as TMediaCenterPlayerControls).Forward);
    FNext.Assign((Source as TMediaCenterPlayerControls).Next);
    FMuteState := (Source as TMediaCenterPlayerControls).MuteState;
    FPlay.Assign((Source as TMediaCenterPlayerControls).Play);
    FPause.Assign((Source as TMediaCenterPlayerControls).Pause);
    FPlayState := (Source as TMediaCenterPlayerControls).PlayState;
    FBackward.Assign((Source as TMediaCenterPlayerControls).Backward);
    FPrevious.Assign((Source as TMediaCenterPlayerControls).Previous);
    FStop.Assign((Source as TMediaCenterPlayerControls).Stop);
  end else
    inherited;
end;

{*******************************************************}
{            MediaCenter Busy Spinner Class             }
{*******************************************************}
constructor TMediaCenterBusySpinner.Create;
begin
  inherited Create;

  FFront := TPicture.Create;
  FFront.OnChange := OnChanged;
  FBack := TPicture.Create;
  FBack.OnChange := OnChanged;

  FShowAnimation := TMediaCenterAnimation.Create;
  FShowAnimation.OnTick   := ShowAnimationTick;
  FShowAnimation.OnFinish := ShowAnimationFinish;
  FHideAnimation := TMediaCenterAnimation.Create;
  FHideAnimation.OnTick   := HideAnimationTick;
  FHideAnimation.OnFinish := HideAnimationFinish;
  FShowAnimationBusy := False;
  FHideAnimationBusy := False;

  FVisible  := False;
  FOpacity  := 0;
  FDuration := 200;

  FSpinTimer := TMediaCenterAnimationTimer.Create(nil);
  FSpinTimer.Interval := 10;
  FSpinTimer.Enabled  := False;
  FSpinTimer.OnTimer  := OnSpinTimer;
end;

destructor TMediaCenterBusySpinner.Destroy;
begin
  FFront.Free;
  FBack.Free;

  FShowAnimation.Free;
  FHideAnimation.Free;
  FSpinTimer.Free;

  inherited Destroy;
end;

procedure TMediaCenterBusySpinner.SetVisible(Visible: Boolean);
begin
  if (not FShowAnimationBusy) and (not FHideAnimationBusy) then
  begin
    if Visible then
    begin
      FSpinTimer.Enabled := True;
      FShowAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FShowAnimationBusy := True;
      FNeedsPainting := True;
    end else
    begin
      FHideAnimation.Start(0, 255, FDuration, etQuadEaseInOut);
      FHideAnimationBusy := True;
    end;
  end;
end;

procedure TMediaCenterBusySpinner.SetInterval(Interval: Integer);
begin
  FSpinTimer.Interval := Interval;
end;

function TMediaCenterBusySpinner.GetInterval: Integer;
begin
  Result := FSpinTimer.Interval;
end;

procedure TMediaCenterBusySpinner.SetFront(Front: TPicture);
begin
  FFront.Assign(Front);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBusySpinner.SetBack(Back: TPicture);
begin
  FBack.Assign(Back);
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBusySpinner.ShowAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity := Min(255, Ceil(Value));
end;

procedure TMediaCenterBusySpinner.ShowAnimationFinish(Sender: TObject);
begin
  FShowAnimationBusy := False;
  FVisible := True;
  FOpacity := 255;
end;

procedure TMediaCenterBusySpinner.HideAnimationTick(Sender: TObject; Value: Extended);
begin
  if Assigned(FOnChange) then FOnChange(Self);
  FOpacity := Max(0, Floor(255 - Value));
end;

procedure TMediaCenterBusySpinner.HideAnimationFinish(Sender: TObject);
begin
  FHideAnimationBusy := False;
  FSpinTimer.Enabled := False;
  FVisible := False;
  FOpacity := 0;
  FNeedsPainting := False;
end;

procedure TMediaCenterBusySpinner.OnSpinTimer(Sender: TObject);
begin
  if (Angle >= 360) then
  begin
    FAngle := 0;
  end else
  begin
    Inc(FAngle, 5);
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBusySpinner.OnChanged(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TMediaCenterBusySpinner.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TMediaCenterBusySpinner) then
  begin
    FVisible  := (Source as TMediaCenterBusySpinner).Visible;
    FDuration := (Source as TMediaCenterBusySpinner).Duration;
    SetInterval((Source as TMediaCenterBusySpinner).Interval);
    FFront.Assign((Source as TMediaCenterBusySpinner).Front);
    FBack.Assign((Source as TMediaCenterBusySpinner).Back);
    if Assigned(FOnChange) then FOnChange(Self);
  end else
    inherited;
end;

{*******************************************************}
{                MediaCenter Base Class                 }
{*******************************************************}
constructor TMediaCenterBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { If the ControlStyle property includes csOpaque, the control paints itself
    directly. We dont want the control to accept controls }
  ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csClickEvents,
    csDoubleClicks, csDesignInteractive];

  { We do want to be able to get focus }
  TabStop := True;

  // Create Background
  FBackground := TMediaCenterBackground.Create;
  FBackground.OnChange := OnChanged;
  // Create Navigation
  FNavigation := TMediaCenterNavigation.Create;
  FNavigation.OnChange := OnChanged;
  // Create Clock
  FClock := TMediaCenterClock.Create;
  FClock.OnChange := OnChanged;
  // Create Player Controls
  FPlayerControls := TMediaCenterPlayerControls.Create;
  FPlayerControls.OnChange := OnChanged;
  // Create Busy Spinner
  FBusySpinner := TMediaCenterBusySpinner.Create;
  FBusySpinner.OnChange := OnChanged;
end;

destructor TMediaCenterBase.Destroy;
begin
  FD2DCanvas.Free;
  FBackground.Free;
  FNavigation.Free;
  FClock.Free;
  FPlayerControls.Free;
  FBusySpinner.Free;

  inherited Destroy;
end;

procedure TMediaCenterBase.WMPaint(var Message: TWMPaint);
var
  PaintStruct : TPaintStruct;
  Res         : HRESULT;
begin
  BeginPaint(Handle, PaintStruct);
  try
    if Assigned(FD2DCanvas) then
    begin
      FD2DCanvas.BeginDraw;
      try
        Paint;
      finally
        Res := FD2DCanvas.RenderTarget.EndDraw;
        if Res = D2DERR_RECREATE_TARGET then
          CreateDeviceResources;
      end;
    end;
  finally
    EndPaint(Handle, PaintStruct);
  end;
end;

procedure TMediaCenterBase.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

procedure TMediaCenterBase.WMSize(var Message: TWMSize);
var
  Size : TD2D1SizeU;
begin
  if FD2DCanvas <> nil then
  begin
    Size := D2D1SizeU(Width, Height);
    ID2D1HwndRenderTarget(FD2DCanvas.RenderTarget).Resize(Size);
  end;

   inherited;
end;

procedure TMediaCenterBase.CreateWnd;
begin
  inherited;
  CreateDeviceResources;
end;

procedure TMediaCenterBase.Paint;

  procedure DrawBackground;
  var
    BGAspect   : Double;
    W, H, X, Y : Integer;
  begin
    with FD2DCanvas do
    begin
      X := 0;
      Y := 0;
      // Fill with color
      Brush.Color := Background.Color;
      Brush.Style := bsSolid;
      RenderTarget.Clear(D2D1ColorF(Background.Color));
      // Draw background image if available
      if (Background.Picture.Graphic <> nil) then
      case Background.StretchMode of
        // Stretch both sides
        smStretch:
        begin
          W := ClientWidth;
          H := ClientHeight;
          FD2DCanvas.StretchDraw(Rect(X, Y, X + W, Y + H), Background.Picture.Graphic);
        end;

        // Stretch both sides but keep aspect ratio
        smAspectStretch:
        begin
          BGAspect := Background.Picture.Width / Background.Picture.Height;
          if ClientWidth > ClientHeight then
          begin
            W := ClientWidth;
            H := Round(BGAspect * ClientWidth);
          end else
          begin
            W := Round(BGAspect * ClientHeight);
            H := ClientHeight;
          end;
          if Background.Center then
          begin
            X := (ClientWidth div 2) - (W div 2);
            Y := (ClientHeight div 2) - (H div 2);
          end;
          FD2DCanvas.StretchDraw(Rect(X, Y, X + W, Y + H), Background.Picture.Graphic);
        end;

        // Stretch keep horizontal aspect ratio
        smAspectHorizontal:
        begin
          BGAspect := Background.Picture.Width / Background.Picture.Height;
          W := ClientWidth;
          H := Round(BGAspect * ClientWidth);
          if Background.Center then
          begin
            X := (ClientWidth div 2) - (W div 2);
            Y := (ClientHeight div 2) - (H div 2);
          end;
          FD2DCanvas.StretchDraw(Rect(X, Y, X + W, Y + H), Background.Picture.Graphic);
        end;

        // Stretch keep vertical aspect ratio
        smAspectVertical:
        begin
          BGAspect := Background.Picture.Width / Background.Picture.Height;
          W := Round(BGAspect * ClientHeight);
          H := ClientHeight;
          if Background.Center then
          begin
            X := (ClientWidth div 2) - (W div 2);
            Y := (ClientHeight div 2) - (H div 2);
          end;
          FD2DCanvas.StretchDraw(Rect(X, Y, X + W, Y + H), Background.Picture.Graphic);
        end;

        // No stretching
        smNone:
        begin
          if Background.Center then
          begin
            X := (ClientWidth div 2) - (Background.Picture.Width div 2);
            Y := (ClientHeight div 2) - (Background.Picture.Height div 2);
          end;
          FD2DCanvas.Draw(X, Y, Background.Picture.Graphic);
        end;
      end;
    end;
  end;

  procedure DrawNavigation;
  var
    P : Integer;
  begin
    if Navigation.NeedsPainting then
    with FD2DCanvas do
    begin
      // Corner
      if (Navigation.Corner.Graphic <> nil) then
      begin
        Draw(0, 0, Navigation.Corner.Graphic, Navigation.Opacity);
      end;
      P := -(25 - Navigation.Position);
      // GoBack
      if (Navigation.GoBack.Disabled.Graphic <> nil) and (Navigation.GoBack.NoFocus.Graphic <> nil) and
         (Navigation.GoBack.Focus.Graphic <> nil) and (Navigation.GoBack.Pressed.Graphic <> nil) then
      begin
        Navigation.GoBack.ButtonRect := Rect(
          Navigation.GoBack.Left,
          Navigation.GoBack.Top + P,
          Navigation.GoBack.Left + Navigation.GoBack.NoFocus.Width,
          Navigation.GoBack.Top + P + Navigation.GoBack.NoFocus.Height
        );
        case Navigation.GoBackState of
          bsNoFocus  : Draw(Navigation.GoBack.Left, Navigation.GoBack.Top + P, Navigation.GoBack.NoFocus.Graphic, Navigation.Opacity);
          bsFocus    : Draw(Navigation.GoBack.Left, Navigation.GoBack.Top + P, Navigation.GoBack.Focus.Graphic, Navigation.Opacity);
          bsPressed  : Draw(Navigation.GoBack.Left, Navigation.GoBack.Top + P, Navigation.GoBack.Pressed.Graphic, Navigation.Opacity);
          bsDisabled : Draw(Navigation.GoBack.Left, Navigation.GoBack.Top + P, Navigation.GoBack.Disabled.Graphic, Navigation.Opacity);
        end;
      end;
      // Menu
      if (Navigation.Menu.Disabled.Graphic <> nil) and (Navigation.Menu.NoFocus.Graphic <> nil) and
         (Navigation.Menu.Focus.Graphic <> nil) and (Navigation.Menu.Pressed.Graphic <> nil) then
      begin
        Navigation.Menu.ButtonRect := Rect(
          Navigation.Menu.Left,
          Navigation.Menu.Top + P,
          Navigation.Menu.Left + Navigation.Menu.NoFocus.Width,
          Navigation.Menu.Top + P + Navigation.Menu.NoFocus.Height
        );
        case Navigation.MenuState of
          bsNoFocus  : Draw(Navigation.Menu.Left, Navigation.Menu.Top + P, Navigation.Menu.NoFocus.Graphic, Navigation.Opacity);
          bsFocus    : Draw(Navigation.Menu.Left, Navigation.Menu.Top + P, Navigation.Menu.Focus.Graphic, Navigation.Opacity);
          bsPressed  : Draw(Navigation.Menu.Left, Navigation.Menu.Top + P, Navigation.Menu.Pressed.Graphic, Navigation.Opacity);
          bsDisabled : Draw(Navigation.Menu.Left, Navigation.Menu.Top + P, Navigation.Menu.Disabled.Graphic, Navigation.Opacity);
        end;
      end;
    end;
  end;

  procedure DrawClock;
  var
    X, P : Integer;
    R    : TRect;
    S    : String;
    B    : ID2D1SolidColorBrush;
  begin
    if Clock.NeedsPainting then
    with FD2DCanvas do
    begin
      // Corner
      if (Clock.Corner.Graphic <> nil) then
      begin
        Draw(ClientWidth - Clock.Corner.Width, 0, Clock.Corner.Graphic, Clock.Opacity);
      end;
      X := ClientWidth - Clock.Right;
      P := -(25 - Clock.Position);
      S := FormatDateTime(Clock.Format, Now);
      // Set Font
      Font.Assign(Clock.Font);
      // Create clock font brush
      FD2DCanvas.RenderTarget.CreateSolidColorBrush(D2D1ColorF(Clock.Font.Color, Clock.Opacity / 255), nil, B);
      Font.Brush.Handle := B;
      // Clear brush for drawing text
      Brush.Style := bsClear;
      if (Clock.Logo.Graphic <> nil) then
      begin
        // Logo
        Dec(X, Clock.Logo.Width);
        Draw(X, Clock.Top + P, Clock.Logo.Graphic, Clock.Opacity);
        // Clock
        Dec(X, 6);
        R := Rect(0, Clock.Top + P, X, Clock.Top + P + Clock.Logo.Height);
        TextRect(R, S, [tfRight, tfVerticalCenter, tfSingleLine]);
      end else
      begin
        // Clock
        R := Rect(0, Clock.Top + P, X, ClientHeight);
        TextRect(R, S, [tfRight, tfTop, tfSingleLine]);
      end;
    end;
  end;

  procedure DrawPlayerControls;
  var
    X, Y, P : Integer;
  begin
    if PlayerControls.NeedsPainting then
    with FD2DCanvas do
    begin
      // Corner
      if (PlayerControls.Corner.Graphic <> nil) then
      begin
        Draw(ClientWidth - PlayerControls.Corner.Width, ClientHeight - PlayerControls.Corner.Height, PlayerControls.Corner.Graphic, PlayerControls.Opacity);
      end;
      P := (25 - PlayerControls.Position);
      // Volume Up
      if (PlayerControls.VolumeUp.Disabled.Graphic <> nil) and (PlayerControls.VolumeUp.NoFocus.Graphic <> nil) and
         (PlayerControls.VolumeUp.Focus.Graphic <> nil) and (PlayerControls.VolumeUp.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.VolumeUp.Right + PlayerControls.VolumeUp.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.VolumeUp.Bottom + PlayerControls.VolumeUp.NoFocus.Height);
        PlayerControls.VolumeUp.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.VolumeUp.NoFocus.Width,
          Y + P + PlayerControls.VolumeUp.NoFocus.Height
        );
        case PlayerControls.VolumeUpState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.VolumeUp.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.VolumeUp.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.VolumeUp.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.VolumeUp.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      // Volume Down
      if (PlayerControls.VolumeDown.Disabled.Graphic <> nil) and (PlayerControls.VolumeDown.NoFocus.Graphic <> nil) and
         (PlayerControls.VolumeDown.Focus.Graphic <> nil) and (PlayerControls.VolumeDown.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.VolumeDown.Right + PlayerControls.VolumeDown.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.VolumeDown.Bottom + PlayerControls.VolumeDown.NoFocus.Height);
        PlayerControls.VolumeDown.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.VolumeDown.NoFocus.Width,
          Y + P + PlayerControls.VolumeDown.NoFocus.Height
        );
        case PlayerControls.VolumeDownState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.VolumeDown.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.VolumeDown.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.VolumeDown.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.VolumeDown.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      case PlayerControls.MuteState of
        Mute:
        begin
          // Mute
          if (PlayerControls.Mute.Disabled.Graphic <> nil) and (PlayerControls.Mute.NoFocus.Graphic <> nil) and
             (PlayerControls.Mute.Focus.Graphic <> nil) and (PlayerControls.Mute.Pressed.Graphic <> nil) then
          begin
            X := ClientWidth - (PlayerControls.Mute.Right + PlayerControls.Mute.NoFocus.Width);
            Y := CLientHeight - (PlayerControls.Mute.Bottom + PlayerControls.Mute.NoFocus.Height);
            PlayerControls.Mute.ButtonRect := Rect(
              X,
              Y + P,
              X + PlayerControls.Mute.NoFocus.Width,
              Y + P + PlayerControls.Mute.NoFocus.Height
            );
            case PlayerControls.MuteUnMuteState of
              bsNoFocus  : Draw(X, Y + P, PlayerControls.Mute.NoFocus.Graphic, PlayerControls.Opacity);
              bsFocus    : Draw(X, Y + P, PlayerControls.Mute.Focus.Graphic, PlayerControls.Opacity);
              bsPressed  : Draw(X, Y + P, PlayerControls.Mute.Pressed.Graphic, PlayerControls.Opacity);
              bsDisabled : Draw(X, Y + P, PlayerControls.Mute.Disabled.Graphic, PlayerControls.Opacity);
            end;
          end;
        end;
        UnMute:
        begin
          // UnMute
          if (PlayerControls.UnMute.Disabled.Graphic <> nil) and (PlayerControls.UnMute.NoFocus.Graphic <> nil) and
             (PlayerControls.UnMute.Focus.Graphic <> nil) and (PlayerControls.UnMute.Pressed.Graphic <> nil) then
          begin
            X := ClientWidth - (PlayerControls.UnMute.Right + PlayerControls.UnMute.NoFocus.Width);
            Y := CLientHeight - (PlayerControls.UnMute.Bottom + PlayerControls.UnMute.NoFocus.Height);
            PlayerControls.UnMute.ButtonRect := Rect(
              X,
              Y + P,
              X + PlayerControls.UnMute.NoFocus.Width,
              Y + P + PlayerControls.UnMute.NoFocus.Height
            );
            case PlayerControls.MuteUnMuteState of
              bsNoFocus  : Draw(X, Y + P, PlayerControls.UnMute.NoFocus.Graphic, PlayerControls.Opacity);
              bsFocus    : Draw(X, Y + P, PlayerControls.UnMute.Focus.Graphic, PlayerControls.Opacity);
              bsPressed  : Draw(X, Y + P, PlayerControls.UnMute.Pressed.Graphic, PlayerControls.Opacity);
              bsDisabled : Draw(X, Y + P, PlayerControls.UnMute.Disabled.Graphic, PlayerControls.Opacity);
            end;
          end;
        end;
      end;
      // Divider
      if (PlayerControls.Divider.Graphic <> nil) then
      begin
        Y := ClientHeight - (20 + PlayerControlsDividerHeight);
        X := ClientWidth - (142);
        StretchDraw(Rect(X - PlayerControlsDividerWidth, Y + P, X, Y + P + PlayerControlsDividerHeight), PlayerControls.Divider.Graphic, PlayerControls.Opacity);
      end;
      // Forward
      if (PlayerControls.Forward.Disabled.Graphic <> nil) and (PlayerControls.Forward.NoFocus.Graphic <> nil) and
         (PlayerControls.Forward.Focus.Graphic <> nil) and (PlayerControls.Forward.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.Forward.Right + PlayerControls.Forward.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.Forward.Bottom + PlayerControls.Forward.NoFocus.Height);
        PlayerControls.Forward.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.Forward.NoFocus.Width,
          Y + P + PlayerControls.Forward.NoFocus.Height
        );
        case PlayerControls.ForwardState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.Forward.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.Forward.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.Forward.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.Forward.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      // Next
      if (PlayerControls.Next.Disabled.Graphic <> nil) and (PlayerControls.Next.NoFocus.Graphic <> nil) and
         (PlayerControls.Next.Focus.Graphic <> nil) and (PlayerControls.Next.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.Next.Right + PlayerControls.Next.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.Next.Bottom + PlayerControls.Next.NoFocus.Height);
        PlayerControls.Next.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.Next.NoFocus.Width,
          Y + P + PlayerControls.Next.NoFocus.Height
        );
        case PlayerControls.NextState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.Next.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.Next.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.Next.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.Next.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      case PlayerControls.PlayState of
        Play:
        begin
          // Play
          if (PlayerControls.Play.Disabled.Graphic <> nil) and (PlayerControls.Play.NoFocus.Graphic <> nil) and
             (PlayerControls.Play.Focus.Graphic <> nil) and (PlayerControls.Play.Pressed.Graphic <> nil) then
          begin
            X := ClientWidth - (PlayerControls.Play.Right + PlayerControls.Play.NoFocus.Width);
            Y := CLientHeight - (PlayerControls.Play.Bottom + PlayerControls.Play.NoFocus.Height);
            PlayerControls.Play.ButtonRect := Rect(
              X,
              Y + P,
              X + PlayerControls.Play.NoFocus.Width,
              Y + P + PlayerControls.Play.NoFocus.Height
            );
            case PlayerControls.PlayPauseState of
              bsNoFocus  : Draw(X, Y + P, PlayerControls.Play.NoFocus.Graphic, PlayerControls.Opacity);
              bsFocus    : Draw(X, Y + P, PlayerControls.Play.Focus.Graphic, PlayerControls.Opacity);
              bsPressed  : Draw(X, Y + P, PlayerControls.Play.Pressed.Graphic, PlayerControls.Opacity);
              bsDisabled : Draw(X, Y + P, PlayerControls.Play.Disabled.Graphic, PlayerControls.Opacity);
            end;
          end;
        end;
        Pause:
        begin
          // Pause
          if (PlayerControls.Pause.Disabled.Graphic <> nil) and (PlayerControls.Pause.NoFocus.Graphic <> nil) and
             (PlayerControls.Pause.Focus.Graphic <> nil) and (PlayerControls.Pause.Pressed.Graphic <> nil) then
          begin
            X := ClientWidth - (PlayerControls.Pause.Right + PlayerControls.Pause.NoFocus.Width);
            Y := CLientHeight - (PlayerControls.Pause.Bottom + PlayerControls.Pause.NoFocus.Height);
            PlayerControls.Pause.ButtonRect := Rect(
              X,
              Y + P,
              X + PlayerControls.Pause.NoFocus.Width,
              Y + P + PlayerControls.Pause.NoFocus.Height
            );
            case PlayerControls.PlayPauseState of
              bsNoFocus  : Draw(X, Y + P, PlayerControls.Pause.NoFocus.Graphic, PlayerControls.Opacity);
              bsFocus    : Draw(X, Y + P, PlayerControls.Pause.Focus.Graphic, PlayerControls.Opacity);
              bsPressed  : Draw(X, Y + P, PlayerControls.Pause.Pressed.Graphic, PlayerControls.Opacity);
              bsDisabled : Draw(X, Y + P, PlayerControls.Pause.Disabled.Graphic, PlayerControls.Opacity);
            end;
          end;
        end;
      end;
      // Previous
      if (PlayerControls.Previous.Disabled.Graphic <> nil) and (PlayerControls.Previous.NoFocus.Graphic <> nil) and
         (PlayerControls.Previous.Focus.Graphic <> nil) and (PlayerControls.Previous.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.Previous.Right + PlayerControls.Previous.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.Previous.Bottom + PlayerControls.Previous.NoFocus.Height);
        PlayerControls.Previous.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.Previous.NoFocus.Width,
          Y + P + PlayerControls.Previous.NoFocus.Height
        );
        case PlayerControls.PreviousState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.Previous.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.Previous.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.Previous.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.Previous.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      // Backward
      if (PlayerControls.Backward.Disabled.Graphic <> nil) and (PlayerControls.Backward.NoFocus.Graphic <> nil) and
         (PlayerControls.Backward.Focus.Graphic <> nil) and (PlayerControls.Backward.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.Backward.Right + PlayerControls.Backward.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.Backward.Bottom + PlayerControls.Backward.NoFocus.Height);
        PlayerControls.Backward.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.Backward.NoFocus.Width,
          Y + P + PlayerControls.Backward.NoFocus.Height
        );
        case PlayerControls.BackwardState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.Backward.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.Backward.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.Backward.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.Backward.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
      // Divider
      if (PlayerControls.Divider.Graphic <> nil) then
      begin
        Y := ClientHeight - (20 + PlayerControlsDividerHeight);
        X := ClientWidth - (376);
        StretchDraw(Rect(X - PlayerControlsDividerWidth, Y + P, X, Y + P + PlayerControlsDividerHeight), PlayerControls.Divider.Graphic, PlayerControls.Opacity);
      end;
      // Stop
      if (PlayerControls.Stop.Disabled.Graphic <> nil) and (PlayerControls.Stop.NoFocus.Graphic <> nil) and
         (PlayerControls.Stop.Focus.Graphic <> nil) and (PlayerControls.Stop.Pressed.Graphic <> nil) then
      begin
        X := ClientWidth - (PlayerControls.Stop.Right + PlayerControls.Stop.NoFocus.Width);
        Y := CLientHeight - (PlayerControls.Stop.Bottom + PlayerControls.Stop.NoFocus.Height);
        PlayerControls.Stop.ButtonRect := Rect(
          X,
          Y + P,
          X + PlayerControls.Stop.NoFocus.Width,
          Y + P + PlayerControls.Stop.NoFocus.Height
        );
        case PlayerControls.StopState of
          bsNoFocus  : Draw(X, Y + P, PlayerControls.Stop.NoFocus.Graphic, PlayerControls.Opacity);
          bsFocus    : Draw(X, Y + P, PlayerControls.Stop.Focus.Graphic, PlayerControls.Opacity);
          bsPressed  : Draw(X, Y + P, PlayerControls.Stop.Pressed.Graphic, PlayerControls.Opacity);
          bsDisabled : Draw(X, Y + P, PlayerControls.Stop.Disabled.Graphic, PlayerControls.Opacity);
        end;
      end;
    end;
  end;

  procedure DrawSpinner;
  var
    X, Y      : Integer;
    DefMatrix : TD2DMatrix3x2F;
  begin
    if BusySpinner.NeedsPainting then
    with FD2DCanvas do
    begin
      if (BusySpinner.Back.Graphic <> nil) and (BusySpinner.Front.Graphic <> nil) then
      begin
        X := Round((ClientWidth / 2) - (BusySpinner.Back.Width / 2));
        Y := Round((ClientHeight / 2) - (BusySpinner.Back.Height / 2));
        Draw(X, Y, BusySpinner.Back.Graphic, BusySpinner.Opacity);
        // Get standard transformation
        RenderTarget.GetTransform(DefMatrix);
        // Set rotation transformation
        RenderTarget.SetTransform(TD2DMatrix3X2F.Rotation(BusySpinner.Angle, ClientWidth / 2, ClientHeight / 2));
        Draw(X, Y, BusySpinner.Front.Graphic, BusySpinner.Opacity);
        // Reset to standard transformation
        RenderTarget.SetTransform(DefMatrix);
      end;
    end;
  end;

begin
  DrawBackground;
  if Assigned(FOnPaint) then
  begin
    FOnPaint(FD2DCanvas);
  end;
  DrawNavigation;
  DrawClock;
  DrawPlayerControls;
  DrawSpinner;
end;

procedure TMediaCenterBase.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
begin
  // GoBack
  if Navigation.GoBack.Enabled then
  begin
    if PtInRect(Navigation.GoBack.ButtonRect, Point(X, Y)) and (Navigation.GoBackState <> bsPressed) then
      Navigation.GoBackState := bsFocus
    else
      Navigation.GoBackState := bsNoFocus;
  end;
  // Menu
  if Navigation.Menu.Enabled then
  begin
    if PtInRect(Navigation.Menu.ButtonRect, Point(X, Y)) and (Navigation.MenuState <> bsPressed) then
      Navigation.MenuState := bsFocus
    else
      Navigation.MenuState := bsNoFocus;
  end;
  // Volume Up
  if PlayerControls.VolumeUp.Enabled then
  begin
    if PtInRect(PlayerControls.VolumeUp.ButtonRect, Point(X, Y)) and (PlayerControls.VolumeUpState <> bsPressed) then
      PlayerControls.VolumeUpState := bsFocus
    else
      PlayerControls.VolumeUpState := bsNoFocus;
  end;
  // Volume Down
  if PlayerControls.VolumeDown.Enabled then
  begin
    if PtInRect(PlayerControls.VolumeDown.ButtonRect, Point(X, Y)) and (PlayerControls.VolumeDownState <> bsPressed) then
      PlayerControls.VolumeDownState := bsFocus
    else
      PlayerControls.VolumeDownState := bsNoFocus;
  end;
  // Volume Down
  if PlayerControls.VolumeDown.Enabled then
  begin
    if PtInRect(PlayerControls.VolumeDown.ButtonRect, Point(X, Y)) and (PlayerControls.VolumeDownState <> bsPressed) then
      PlayerControls.VolumeDownState := bsFocus
    else
      PlayerControls.VolumeDownState := bsNoFocus;
  end;
  case PlayerControls.MuteState of
    Mute:
    begin
      // Mute
      if PlayerControls.Mute.Enabled then
      begin
        if PtInRect(PlayerControls.Mute.ButtonRect, Point(X, Y)) and (PlayerControls.MuteUnMuteState <> bsPressed) then
          PlayerControls.MuteUnMuteState := bsFocus
        else
          PlayerControls.MuteUnMuteState := bsNoFocus;
      end;
    end;
    UnMute:
    begin
      // UnMute
      if PlayerControls.UnMute.Enabled then
      begin
        if PtInRect(PlayerControls.UnMute.ButtonRect, Point(X, Y)) and (PlayerControls.MuteUnMuteState <> bsPressed) then
          PlayerControls.MuteUnMuteState := bsFocus
        else
          PlayerControls.MuteUnMuteState := bsNoFocus;
      end;
    end;
  end;
  // Forward
  if PlayerControls.Forward.Enabled then
  begin
    if PtInRect(PlayerControls.Forward.ButtonRect, Point(X, Y)) and (PlayerControls.ForwardState <> bsPressed) then
      PlayerControls.ForwardState := bsFocus
    else
      PlayerControls.ForwardState := bsNoFocus;
  end;
  // Next
  if PlayerControls.Next.Enabled then
  begin
    if PtInRect(PlayerControls.Next.ButtonRect, Point(X, Y)) and (PlayerControls.NextState <> bsPressed) then
      PlayerControls.NextState := bsFocus
    else
      PlayerControls.NextState := bsNoFocus;
  end;
  case PlayerControls.PlayState of
    Play:
    begin
      // Play
      if PlayerControls.Play.Enabled then
      begin
        if PtInRect(PlayerControls.Play.ButtonRect, Point(X, Y)) and (PlayerControls.PlayPauseState <> bsPressed) then
          PlayerControls.PlayPauseState := bsFocus
        else
          PlayerControls.PlayPauseState := bsNoFocus;
      end;
    end;
    Pause:
    begin
      // Pause
      if PlayerControls.Pause.Enabled then
      begin
        if PtInRect(PlayerControls.Pause.ButtonRect, Point(X, Y)) and (PlayerControls.PlayPauseState <> bsPressed) then
          PlayerControls.PlayPauseState := bsFocus
        else
          PlayerControls.PlayPauseState := bsNoFocus;
      end;
    end;
  end;
  // Backward
  if PlayerControls.Backward.Enabled then
  begin
    if PtInRect(PlayerControls.Backward.ButtonRect, Point(X, Y)) and (PlayerControls.BackwardState <> bsPressed) then
      PlayerControls.BackwardState := bsFocus
    else
      PlayerControls.BackwardState := bsNoFocus;
  end;
  // Previous
  if PlayerControls.Previous.Enabled then
  begin
    if PtInRect(PlayerControls.Previous.ButtonRect, Point(X, Y)) and (PlayerControls.PreviousState <> bsPressed) then
      PlayerControls.PreviousState := bsFocus
    else
      PlayerControls.PreviousState := bsNoFocus;
  end;
  // Stop
  if PlayerControls.Stop.Enabled then
  begin
    if PtInRect(PlayerControls.Stop.ButtonRect, Point(X, Y)) and (PlayerControls.StopState <> bsPressed) then
      PlayerControls.StopState := bsFocus
    else
      PlayerControls.StopState := bsNoFocus;
  end;
end;

procedure TMediaCenterBase.MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  // GoBack
  if Navigation.GoBack.Enabled then
  begin
    if PtInRect(Navigation.GoBack.ButtonRect, Point(X, Y)) then
      Navigation.GoBackState := bsPressed;
  end;
  // Menu
  if Navigation.Menu.Enabled then
  begin
    if PtInRect(Navigation.Menu.ButtonRect, Point(X, Y)) then
      Navigation.MenuState := bsPressed;
  end;
  case PlayerControls.MuteState of
    Mute:
    begin
      // Mute
      if PlayerControls.Mute.Enabled then
      begin
        if PtInRect(PlayerControls.Mute.ButtonRect, Point(X, Y)) then
          PlayerControls.MuteUnMuteState := bsPressed;
      end;
    end;
    UnMute:
    begin
      // UnMute
      if PlayerControls.UnMute.Enabled then
      begin
        if PtInRect(PlayerControls.UnMute.ButtonRect, Point(X, Y)) then
          PlayerControls.MuteUnMuteState := bsPressed;
      end;
    end;
  end;
  // Forward
  if PlayerControls.Forward.Enabled then
  begin
    if PtInRect(PlayerControls.Forward.ButtonRect, Point(X, Y)) then
      PlayerControls.ForwardState := bsPressed;
  end;
  // Next
  if PlayerControls.Next.Enabled then
  begin
    if PtInRect(PlayerControls.Next.ButtonRect, Point(X, Y)) then
      PlayerControls.NextState := bsPressed;
  end;
  case PlayerControls.PlayState of
    Play:
    begin
      // Play
      if PlayerControls.Play.Enabled then
      begin
        if PtInRect(PlayerControls.Play.ButtonRect, Point(X, Y)) then
          PlayerControls.PlayPauseState := bsPressed;
      end;
    end;
    Pause:
    begin
      // Pause
      if PlayerControls.Pause.Enabled then
      begin
        if PtInRect(PlayerControls.Pause.ButtonRect, Point(X, Y)) then
          PlayerControls.PlayPauseState := bsPressed;
      end;
    end;
  end;
  // Backward
  if PlayerControls.Backward.Enabled then
  begin
    if PtInRect(PlayerControls.Backward.ButtonRect, Point(X, Y)) then
      PlayerControls.BackwardState := bsPressed;
  end;
  // Previous
  if PlayerControls.Previous.Enabled then
  begin
    if PtInRect(PlayerControls.Previous.ButtonRect, Point(X, Y)) then
      PlayerControls.PreviousState := bsPressed;
  end;
  // Stop
  if PlayerControls.Stop.Enabled then
  begin
    if PtInRect(PlayerControls.Stop.ButtonRect, Point(X, Y)) then
      PlayerControls.StopState := bsPressed;
  end;
end;

procedure TMediaCenterBase.MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  // GoBack
  if Navigation.GoBack.Enabled then
  begin
    if Navigation.GoBackState = bsPressed then
    if Assigned(OnGoBackClick) then OnGoBackClick(Self);

    if PtInRect(Navigation.GoBack.ButtonRect, Point(X, Y)) then
      Navigation.GoBackState := bsFocus
    else
      Navigation.GoBackState := bsNoFocus;
  end;
  // Menu
  if Navigation.Menu.Enabled then
  begin
    if Navigation.MenuState = bsPressed then
    if Assigned(OnMenuClick) then OnMenuClick(Self);

    if PtInRect(Navigation.Menu.ButtonRect, Point(X, Y)) then
      Navigation.MenuState := bsFocus
    else
      Navigation.MenuState := bsNoFocus;
  end;
  case PlayerControls.MuteState of
    Mute:
    begin
      // Mute
      if PlayerControls.Mute.Enabled then
      begin
        if PlayerControls.MuteUnMuteState = bsPressed then
        if Assigned(FOnPlayerClick) then FOnPlayerClick(pbMute);

        if PtInRect(PlayerControls.Mute.ButtonRect, Point(X, Y)) then
          PlayerControls.MuteUnMuteState := bsFocus
        else
          PlayerControls.MuteUnMuteState := bsNoFocus;
      end;
    end;
    UnMute:
    begin
      // UnMute
      if PlayerControls.UnMute.Enabled then
      begin
        if PlayerControls.MuteUnMuteState = bsPressed then
        if Assigned(FOnPlayerClick) then FOnPlayerClick(pbUnMute);

        if PtInRect(PlayerControls.UnMute.ButtonRect, Point(X, Y)) then
          PlayerControls.MuteUnMuteState := bsFocus
        else
          PlayerControls.MuteUnMuteState := bsNoFocus;
      end;
    end;
  end;
  // Forward
  if PlayerControls.Forward.Enabled then
  begin
    if PlayerControls.ForwardState = bsPressed then
    if Assigned(FOnPlayerClick) then FOnPlayerClick(pbForward);

    if PtInRect(PlayerControls.Forward.ButtonRect, Point(X, Y)) then
      PlayerControls.ForwardState := bsFocus
    else
      PlayerControls.ForwardState := bsNoFocus;
  end;
  // Next
  if PlayerControls.Next.Enabled then
  begin
    if PlayerControls.NextState = bsPressed then
    if Assigned(FOnPlayerClick) then FOnPlayerClick(pbNext);

    if PtInRect(PlayerControls.Next.ButtonRect, Point(X, Y)) then
      PlayerControls.NextState := bsFocus
    else
      PlayerControls.NextState := bsNoFocus;
  end;
  case PlayerControls.PlayState of
    Play:
    begin
      // Play
      if PlayerControls.Play.Enabled then
      begin
        if PlayerControls.PlayPauseState = bsPressed then
        if Assigned(FOnPlayerClick) then FOnPlayerClick(pbPlay);

        if PtInRect(PlayerControls.Play.ButtonRect, Point(X, Y)) then
          PlayerControls.PlayPauseState := bsFocus
        else
          PlayerControls.PlayPauseState := bsNoFocus;
      end;
    end;
    Pause:
    begin
      // Pause
      if PlayerControls.Pause.Enabled then
      begin
        if PlayerControls.PlayPauseState = bsPressed then
        if Assigned(FOnPlayerClick) then FOnPlayerClick(pbPause);

        if PtInRect(PlayerControls.Pause.ButtonRect, Point(X, Y)) then
          PlayerControls.PlayPauseState := bsFocus
        else
          PlayerControls.PlayPauseState := bsNoFocus;
      end;
    end;
  end;
  // Backward
  if PlayerControls.Backward.Enabled then
  begin
    if PlayerControls.BackwardState = bsPressed then
    if Assigned(FOnPlayerClick) then FOnPlayerClick(pbBackward);

    if PtInRect(PlayerControls.Backward.ButtonRect, Point(X, Y)) then
      PlayerControls.BackwardState := bsFocus
    else
      PlayerControls.BackwardState := bsNoFocus;
  end;
  // Previous
  if PlayerControls.Previous.Enabled then
  begin
    if PlayerControls.PreviousState = bsPressed then
    if Assigned(FOnPlayerClick) then FOnPlayerClick(pbPrevious);

    if PtInRect(PlayerControls.Previous.ButtonRect, Point(X, Y)) then
      PlayerControls.PreviousState := bsFocus
    else
      PlayerControls.PreviousState := bsNoFocus;
  end;
  // Stop
  if PlayerControls.Stop.Enabled then
  begin
    if PlayerControls.StopState = bsPressed then
    if Assigned(FOnPlayerClick) then FOnPlayerClick(pbStop);

    if PtInRect(PlayerControls.Stop.ButtonRect, Point(X, Y)) then
      PlayerControls.StopState := bsFocus
    else
      PlayerControls.StopState := bsNoFocus;
  end;
end;

procedure TMediaCenterBase.OnChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TMediaCenterBase.CreateDeviceResources;
begin
  FreeAndNil(FD2DCanvas);
  FD2DCanvas := TDirect2DCanvas.Create(Handle);
  // Improve speed?
  FD2DCanvas.RenderTarget.SetAntialiasMode(D2D1_ANTIALIAS_MODE_ALIASED);
  // Improve speed?
  FD2DCanvas.RenderTarget.SetTextAntialiasMode(D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE);
end;

procedure TMediaCenterBase.SetBackground(Background: TMediaCenterBackground);
begin
  FBackground.Assign(Background);
  Invalidate;
end;

procedure TMediaCenterBase.SetNavigation(Navigation: TMediaCenterNavigation);
begin
  FNavigation.Assign(Navigation);
  Invalidate;
end;

procedure TMediaCenterBase.SetClock(Clock: TMediaCenterClock);
begin
  FClock.Assign(Clock);
  Invalidate;
end;

procedure TMediaCenterBase.SetPlayerControls(PlayerControls: TMediaCenterPlayerControls);
begin
  FPlayerControls.Assign(PlayerControls);
  Invalidate;
end;

procedure TMediaCenterBase.SetBusySpinner(BusySpinner: TMediaCenterBusySpinner);
begin
  FBusySpinner.Assign(BusySpinner);
  Invalidate;
end;

procedure Register;
begin
  RegisterComponents('ERDesigns MediaCenter', [TMediaCenter]);
end;

end.
