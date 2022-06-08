Family = {
    MOUSE = "mouse"
}

MouseEvent = {
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
            OutputLogMessage("Stopped Firing " .. self._selected .. "\n")
        else
            self._toggled = true
            PlayMacro("Toggle Press " .. self._selected)
            OutputLogMessage("Start Firing " .. self._selected .. "\n")
        end
    end,

    _selectPrev = function(self)
        if not self._toggled and self._selected > self.MIN then
            self._selected = self._selected - 1
            OutputLogMessage("Selecting " .. self._selected .. "\n")
        end
    end,

    _selectNext = function(self)
        if not self._toggled and self._selected < self.MAX then
            self._selected = self._selected + 1
            OutputLogMessage("Selecting " .. self._selected .. "\n")
        end
    end,

    _holdFire = function(self)
        self._firing = true
        if self._firing then
            PressMouseButton(MouseButton.LEFT)
            OutputLogMessage("FIRE Pressed\n")
        end
    end,

    _holdAim = function(self)
        self._aiming = true
        if self._aiming then
            PressMouseButton(MouseButton.RIGHT)
            OutputLogMessage("AIM Pressed\n")
        end
    end,

    _releaseFire = function(self)
        self._firing = false
        if not self._firing then
            ReleaseMouseButton(MouseButton.LEFT)
            OutputLogMessage("FIRE Released\n")
        end
    end,

    _releaseAim = function(self)
        self._aiming = false
        if not self._aiming then
            ReleaseMouseButton(MouseButton.RIGHT)
            OutputLogMessage("AIM Released\n")
        end
    end,

    OnMouseEvent = function(self, event, arg)
        if event == MouseEvent.MOUSE_BUTTON_PRESSED then
            if not self._firing and arg == Configuration.FIRE then
                self:_holdFire()
            elseif not self._aiming and arg == Configuration.AIM then
                self:_holdAim()
            elseif not self._aiming and arg == Configuration.TOGGLE then
                self:_togglePressSelected()
            elseif arg == Configuration.PREV then
                self:_selectPrev()
            elseif arg == Configuration.NEXT then
                self:_selectNext()
            end
        elseif event == MouseEvent.MOUSE_BUTTON_RELEASED then
            if self._firing and arg == Configuration.FIRE then
                self:_releaseFire()
            elseif self._aiming and arg == Configuration.AIM then
                self:_releaseAim()
            end
        end
    end
}

function OnEvent(event, arg, family)
    OutputLogMessage("event = %s, arg = %s, family = %s\n", event, arg, family)
    if family == Family.MOUSE then
        AutoPower:OnMouseEvent(event, arg)
    end
end

EnablePrimaryMouseButtonEvents(true)
OutputLogMessage("Starting AutoPower\n")
