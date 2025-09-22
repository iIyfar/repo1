#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

; State
clickingEnabled := false
leftHeld := false
rightHeld := false

; Function to get random interval between 6-25ms
GetRandomInterval() {
    return Random(6, 25)
}

; Toggle with H (plain H key)
h:: {
    global clickingEnabled, leftHeld, rightHeld
    clickingEnabled := !clickingEnabled

    ToolTip clickingEnabled ? "Clicker: ON" : "Clicker: OFF"
    SetTimer HideTooltip, -600

    if !clickingEnabled {
        SetTimer LeftTimer, 0
        SetTimer RightTimer, 0
    } else {
        if leftHeld
            SetTimer LeftTimer, GetRandomInterval()
        if rightHeld
            SetTimer RightTimer, GetRandomInterval()
    }
}

; Left mouse down/up
~*LButton:: {
    global clickingEnabled, leftHeld
    leftHeld := true
    if clickingEnabled
        SetTimer LeftTimer, GetRandomInterval()
}
~LButton Up:: {
    global leftHeld
    leftHeld := false
    SetTimer LeftTimer, 0
}

; Right mouse down/up
~*RButton:: {
    global clickingEnabled, rightHeld
    rightHeld := true
    if clickingEnabled
        SetTimer RightTimer, GetRandomInterval()
}
~RButton Up:: {
    global rightHeld
    rightHeld := false
    SetTimer RightTimer, 0
}

; Timers
LeftTimer() {
    global clickingEnabled, leftHeld
    if clickingEnabled && leftHeld {
        Click "Left"
        SetTimer LeftTimer, GetRandomInterval()  ; Reset timer with new random interval
    } else {
        SetTimer LeftTimer, 0
    }
}
RightTimer() {
    global clickingEnabled, rightHeld
    if clickingEnabled && rightHeld {
        Click "Right"
        SetTimer RightTimer, GetRandomInterval()  ; Reset timer with new random interval
    } else {
        SetTimer RightTimer, 0
    }
}

HideTooltip() {
    ToolTip()  ; clear tooltip
}