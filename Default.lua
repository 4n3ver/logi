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
    AIM = MouseButton.RIGHT_CLICK
}

function OnEvent(event, arg, family)
    OutputLogMessage("event = %s, arg = %s\n", event, arg)
    Default:OnEvent(event, arg, family)
end

Default = {
    OnEvent = function(self, event, arg, family)
        if event == Event.MOUSE_BUTTON_PRESSED then
            if arg == Configuration.AIM then
                PressMouseButton(3)
            end
        elseif event == Event.MOUSE_BUTTON_RELEASED then
            if arg == Configuration.AIM then
                ReleaseMouseButton(3)
            end
        end
    end,
}

Event = {
    MOUSE_BUTTON_PRESSED = "MOUSE_BUTTON_PRESSED",
    MOUSE_BUTTON_RELEASED = "MOUSE_BUTTON_RELEASED"
}
