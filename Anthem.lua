MouseButton = {
    G5 = 5,
    G10 = 10,
    G11 = 11,
    MIDDLE_CLICK = 3,
    RIGHT_CLICK = 2,
    SCROLL_LEFT = 12,
    SCROLL_RIGHT = 13,
    DISABLE = 999
}

Configuration = {
    AIM = MouseButton.RIGHT_CLICK,
    HOVER = MouseButton.G5,
    TOGGLE = MouseButton.MIDDLE_CLICK
}

function OnEvent(event, arg, family)
    OutputLogMessage("event = %s, arg = %s\n", event, arg)
    HoverOnAim:OnEvent(event, arg, family)
end

HoverOnAim = {
    _hover = false,
    _enable = true,
    _aiming = false,

    _pressHoverButton = function(self)
        if self._enable and not self._hover then
            PressKey("semicolon")
            Sleep(3)
            ReleaseKey("semicolon")
        end
    end,

    OnEvent = function(self, event, arg, family)
        if event == Event.MOUSE_BUTTON_PRESSED then
            if arg == Configuration.AIM then
                self._aiming = true
                HoverOnAim:_pressHoverButton()
            elseif arg == Configuration.HOVER then
                self._hover = not self._hover
            elseif arg == Configuration.TOGGLE and not self._aiming then
                self._hover = false
                self._enable = not self._enable
            end
        elseif event ==  Event.MOUSE_BUTTON_RELEASED then
            if arg == Configuration.AIM then
                self._aiming = false
                HoverOnAim:_pressHoverButton()
            end
        end
    end,
}

Event = {
    MOUSE_BUTTON_PRESSED = "MOUSE_BUTTON_PRESSED",
    MOUSE_BUTTON_RELEASED = "MOUSE_BUTTON_RELEASED"
}
