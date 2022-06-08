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
    NEXT = MouseButtonEvent.SCROLL_RIGHT,
    DEBOUNCE_DELAY_MS = 30,
}

DebouncedButton = {
    RELEASED = MouseEvent.MOUSE_BUTTON_RELEASED,
    PRESSED = MouseEvent.MOUSE_BUTTON_PRESSED,

    debounce_delay = Configuration.DEBOUNCE_DELAY_MS,
    button = -1,

    state = MouseEvent.MOUSE_BUTTON_RELEASED,
    lastDebounceTime = GetRunningTime(),
}

function DebouncedButton:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function DebouncedButton:isPressed()
    return self.state == self.PRESSED
end

function DebouncedButton:switch()
    if self:isPressed() then
        PressMouseButton(self.button)
        OutputLogMessage("\tButton %s pressed\n", self.button)
    else
        ReleaseMouseButton(self.button)
        OutputLogMessage("\tButton %s released\n", self.button)
    end
end

function DebouncedButton:onEvent(new_state)
    local sinceLastDebounce = GetRunningTime() - self.lastDebounceTime
    self.lastDebounceTime = GetRunningTime()
    if sinceLastDebounce > self.debounce_delay then
        OutputLogMessage("Since last debounce of button %s: %sms\n", self.button, sinceLastDebounce)
        self.state = new_state
        self:switch()
    else
        OutputLogMessage("\tButton %s debounced\n", self.button)
    end
end

AutoPower = {
    MAX = 4,
    MIN = 1,

    selected = 1,
    isActive = false,

    activate = function(self)
        if self.isActive then
            AbortMacro()
            self.isActive = false
            OutputLogMessage("\tStopped Firing %s\n", self.selected)
        else
            self.isActive = true
            PlayMacro("Toggle Press " .. self.selected)
            OutputLogMessage("\tStart Firing %s\n", self.selected)
        end
    end,

    previous = function(self)
        if not self.isActive and self.selected > self.MIN then
            self.selected = self.selected - 1
            OutputLogMessage("\tSelecting %s\n", self.selected)
        end
    end,

    next = function(self)
        if not self.isActive and self.selected < self.MAX then
            self.selected = self.selected + 1
            OutputLogMessage("\tSelecting %s\n", self.selected)
        end
    end
}

Mouse = {
    leftButton = DebouncedButton:new{button = MouseButton.LEFT},
    rightButton = DebouncedButton:new{button = MouseButton.RIGHT, debounce_delay = 75},

    onEvent = function(self, event, arg)
        if arg == Configuration.FIRE then
            self.leftButton:onEvent(event)
        elseif arg == Configuration.AIM then
            self.rightButton:onEvent(event)
        elseif event == MouseEvent.MOUSE_BUTTON_PRESSED then
            if arg == Configuration.TOGGLE and not self.rightButton:isPressed() then
                AutoPower:activate()
            elseif arg == Configuration.PREV then
                AutoPower:previous()
            elseif arg == Configuration.NEXT then
                AutoPower:next()
            end
        end
    end
}

function OnEvent(event, arg, family)
    OutputLogMessage("runtime = %sms, event = %s, arg = %s, family = %s\n", GetRunningTime(), event, arg, family)
    if family == Family.MOUSE then
        Mouse:onEvent(event, arg)
    end
end
EnablePrimaryMouseButtonEvents(true)
OutputLogMessage("Starting AutoPower\n")
