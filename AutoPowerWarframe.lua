Event = {
    MOUSE_BUTTON_PRESSED = "MOUSE_BUTTON_PRESSED",
    MOUSE_BUTTON_RELEASED = "MOUSE_BUTTON_RELEASED"
}

MouseButtonEvent = {
    G5 = 5,
    G10 = 10,
    G11 = 11,
    LEFT = 1,
    MIDDLE = 3,
    RIGHT = 2,
    SCROLL_LEFT = 12,
    SCROLL_RIGHT = 13,
    DISABLE = 999
}

MouseButton = {
    LEFT = 1,
    MIDDLE = 2,
    RIGHT = 3,
    X1 = 4,
    X2 = 5
}

Configuration = {
    TOGGLE = MouseButtonEvent.MIDDLE,
    FIRE = MouseButtonEvent.LEFT,
    AIM = MouseButtonEvent.RIGHT,
    PREV = MouseButtonEvent.SCROLL_LEFT,
    NEXT = MouseButtonEvent.SCROLL_RIGHT
}

AutoPower = {
    MAX = 4,
    MIN = 1,

    _selected = 1,
    _toggled = false,
    _aiming = false,
    _firing = false,

    _togglePressSelected = function(self)
        if self._toggled then
            AbortMacro()
            self._toggled = false
        else
            self._toggled = true
            PlayMacro("Toggle Press " .. self._selected)
        end
    end,

    _selectPrev = function(self)
        if self._selected > self.MIN and not self._toggled then
            self._selected = self._selected - 1
        end
    end,

    _selectNext = function(self)
        if self._selected < self.MAX and not self._toggled then
            self._selected = self._selected + 1
        end
    end,

    OnEvent = function(self, event, arg, family)
        if event == Event.MOUSE_BUTTON_PRESSED then
            if arg == Configuration.FIRE and not self._firing then
                self._firing = true
                if self._firing then
                    PressMouseButton(MouseButton.LEFT)
                    OutputLogMessage("FIRE Pressed\n")
                end
            elseif arg == Configuration.AIM and not self._aiming then
                self._aiming = true
                if self._aiming then
                    PressMouseButton(MouseButton.RIGHT)
                    OutputLogMessage("AIM Pressed\n")
                end
            elseif arg == Configuration.PREV then
                self:_selectPrev()
            elseif arg == Configuration.NEXT then
                self:_selectNext()
            elseif arg == Configuration.TOGGLE and not self._aiming then
                self:_togglePressSelected()
            end
        elseif event == Event.MOUSE_BUTTON_RELEASED then
            if arg == Configuration.FIRE and self._firing then
                self._firing = false
                if not self._firing then
                    ReleaseMouseButton(MouseButton.LEFT)
                    OutputLogMessage("FIRE Released\n")
                end
            elseif arg == Configuration.AIM and self._aiming then
                self._aiming = false
                if not self._aiming then
                    ReleaseMouseButton(MouseButton.RIGHT)
                    OutputLogMessage("AIM Released\n")
                end
            end
        end
    end,
}

function OnEvent(event, arg, family)
    OutputLogMessage("event = %s, arg = %s, family = %s\n", event, arg, family)
    EnablePrimaryMouseButtonEvents(true)
    AutoPower:OnEvent(event, arg, family)
end

OutputLogMessage("Starting AutoPower\n")
