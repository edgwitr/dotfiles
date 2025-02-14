#SingleInstance Force

; ime
IME_SET(SetSts, WinTitle:="A")    {
    hwnd := WinExist(WinTitle)
    if  (WinActive(WinTitle))   {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        cbSize := 4+4+(PtrSize*6)+16
        stGTI := Buffer(cbSize,0)
        NumPut("Uint", cbSize, stGTI.Ptr,0)   ;   DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", "Uint",0, "Uint",stGTI.Ptr)
                 ? NumGet(stGTI.Ptr,8+PtrSize,"Uint") : hwnd
    }
    return DllCall("SendMessage"
          , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "Uint",hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          ,  "Int", 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  "Int", SetSts) ;lParam  : 0 or 1
}

IN_TERMINAL() {
    return WinActive("ahk_exe alacritty.exe") or WinActive("ahk_exe WindowsTerminal.exe")
}

vk1D:: IME_SET(0)
vk1C:: IME_SET(1)
Enter:: Send "`n"

; Caps -> F13(^)
#HotIf IN_TERMINAL()
    F13::Ctrl
#HotIf
#HotIf !IN_TERMINAL()
    F13 & b:: Left
    F13 & f:: Right
    F13 & p:: Up
    F13 & n:: Down
    F13 & a:: Home
    F13 & e:: End
    F13 & h:: BackSpace
    F13 & j:: F6
    F13 & k:: F7
    F13 & l:: F9
    F13 & `;:: F8
    F13 & SC028:: F10
    F13 & Space:: ^Space
    F13 & m:: Send "`r"
#HotIf

; #HotIf GetKeyState("F13", "P") and !IN_TERMINAL()
;     !p:: Send "^{Up}"
;     !n:: Send "^{Down}"
;     !b:: Send "^{Left}"
;     !f:: Send "^{Right}"
;     ^h:: MsgBox "hoge"
;     ^r:: Reload
;     ^k:: KeyHistory
;     ^w:: MsgBox WinGetClass("A")
; #HotIf
