local Config = require("Halloween/config")
local GUI = {}
GUI.__index = GUI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local function addSeparator(parent, y)
    local line = Instance.new("Frame", parent)
    line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    line.BorderSizePixel = 0
    line.Size = UDim2.new(1, -24, 0, 1)
    line.Position = UDim2.fromOffset(12, y)
    return y + Config.ui.SEP_BOTTOM_PADDING
end

local function makeCheckbox(parent, labelText, default, posY, indentX)
    indentX = indentX or 0
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16 - indentX, 0, 24)
    row.Position = UDim2.fromOffset(8 + indentX, posY)
    row.BackgroundTransparency = 1
    row.Parent = parent
    local box = Instance.new("TextButton")
    box.Size = UDim2.fromOffset(20, 20)
    box.Position = UDim2.fromOffset(0, 2)
    box.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    box.Text = default and "✓" or ""
    box.Font = Enum.Font.GothamBold
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(230,230,230)
    box.AutoButtonColor = true
    box.Parent = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke", box)
    s.Color = Color3.fromRGB(70,70,70)
    s.Thickness = 1
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -30, 1, 0)
    lbl.Position = UDim2.fromOffset(28, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = labelText
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local state = default
    local function setState(v) state = v and true or false box.Text = state and "✓" or "" end
    box.MouseButton1Click:Connect(function() setState(not state) end)
    lbl.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then setState(not state) end end)
    return function() return state end, setState
end

local function makeDropdown(gui, parent, labelText, options, default, posY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 30)
    container.Position = UDim2.fromOffset(8, posY)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 90, 0, 22)
    lbl.Position = UDim2.fromOffset(0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = labelText
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, -100, 1, -2)
    dropdown.Position = UDim2.fromOffset(90, 1)
    dropdown.BackgroundColor3 = Color3.fromRGB(38,38,38)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = container
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,8)
    local ddStroke = Instance.new("UIStroke", dropdown)
    ddStroke.Thickness = 1
    ddStroke.Color = Color3.fromRGB(70,70,70)
    local ddButton = Instance.new("TextButton")
    ddButton.Size = UDim2.new(1, -28, 1, 0)
    ddButton.Position = UDim2.fromOffset(8, 0)
    ddButton.BackgroundTransparency = 1
    ddButton.Font = Enum.Font.GothamBold
    ddButton.Text = default
    ddButton.TextSize = 14
    ddButton.TextColor3 = Color3.fromRGB(230,230,230)
    ddButton.TextXAlignment = Enum.TextXAlignment.Left
    ddButton.Parent = dropdown
    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.fromOffset(18, 18)
    chevron.Position = UDim2.new(1, -22, 0.5, -9)
    chevron.BackgroundTransparency = 1
    chevron.Text = "▼"
    chevron.Font = Enum.Font.GothamBold
    chevron.TextSize = 14
    chevron.TextColor3 = Color3.fromRGB(200,200,200)
    chevron.Parent = dropdown
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Visible = false
    listFrame.BackgroundColor3 = Color3.fromRGB(38,38,38)
    listFrame.BorderSizePixel = 0
    listFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.ScrollBarThickness = 6
    listFrame.ScrollBarImageColor3 = Color3.fromRGB(90,90,90)
    listFrame.Parent = dropdown
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0,8)
    local listStroke = Instance.new("UIStroke", listFrame)
    listStroke.Thickness = 1
    listStroke.Color = Color3.fromRGB(70,70,70)
    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0,4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local padding = Instance.new("UIPadding", listFrame)
    padding.PaddingTop = UDim.new(0,6)
    padding.PaddingBottom = UDim.new(0,6)
    padding.PaddingLeft = UDim.new(0,6)
    padding.PaddingRight = UDim.new(0,6)
    local current = default
    for _, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, 24)
        btn.BackgroundColor3 = Color3.fromRGB(48,48,48)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = option
        btn.TextColor3 = Color3.fromRGB(230,230,230)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = true
        btn.Parent = listFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(function()
            current = option
            ddButton.Text = current
            listFrame.Visible = false
            chevron.Text = "▼"
            listFrame.Parent = dropdown
        end)
    end
    local total = #options * 28 + 12
    local popupHeight = math.min(total, 160)
    listFrame.Size = UDim2.new(0, dropdown.AbsoluteSize.X, 0, popupHeight)
    local function openList()
        local root = gui
        listFrame.Parent = root
        local pos, size = dropdown.AbsolutePosition, dropdown.AbsoluteSize
        listFrame.Position = UDim2.fromOffset(pos.X, pos.Y + size.Y + 4)
        listFrame.Size = UDim2.new(0, size.X, 0, popupHeight)
        listFrame.ZIndex = 50
        listFrame.Visible = true
        chevron.Text = "▲"
    end
    local function closeList()
        listFrame.Visible = false
        chevron.Text = "▼"
        listFrame.Parent = dropdown
    end
    local function toggleList(force)
        if force == nil then if listFrame.Visible then closeList() else openList() end
        else if force then openList() else closeList() end end
    end
    ddButton.MouseButton1Click:Connect(toggleList)
    chevron.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then toggleList() end end)
    UserInputService.InputBegan:Connect(function(i,gp)
        if gp or not listFrame.Visible then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local m = UserInputService:GetMouseLocation()
            local a,s = listFrame.AbsolutePosition, listFrame.AbsoluteSize
            if m.X < a.X or m.X > a.X + s.X or m.Y < a.Y or m.Y > a.Y + s.Y then closeList() end
        end
    end)
    dropdown:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if listFrame.Visible then
            local pos,size = dropdown.AbsolutePosition, dropdown.AbsoluteSize
            listFrame.Position = UDim2.fromOffset(pos.X, pos.Y + size.Y + 4)
            listFrame.Size = UDim2.new(0, size.X, 0, popupHeight)
        end
    end)
    return function() return current end
end

function GUI.mount(playerGui)
    local self = setmetatable({}, GUI)
    self._gui = Instance.new("ScreenGui")
    self._gui.Name = "AluraGUI"
    self._gui.ResetOnSpawn = false
    self._gui.IgnoreGuiInset = true
    self._gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self._gui.DisplayOrder = 999
    self._gui.Parent = playerGui
    self.frame = Instance.new("Frame", self._gui)
    self.frame.Name = "Container"
    self.frame.Size = UDim2.fromOffset(Config.ui.FRAME_WIDTH, 420)
    self.frame.Position = UDim2.new(0, 20, 0, 150)
    self.frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    self.frame.BorderSizePixel = 0
    Instance.new("UICorner", self.frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", self.frame).Color = Color3.fromRGB(70,70,70)
    local title = Instance.new("TextLabel", self.frame)
    title.Size = UDim2.new(1, -16, 0, 24)
    title.Position = UDim2.fromOffset(8, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Alura"
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(235,235,235)
    title.TextXAlignment = Enum.TextXAlignment.Center
    local Y = 50
    self.getEgg = makeDropdown(self._gui, self.frame, "Egg:", Config.EGG_OPTIONS, Config.defaults.selectedEgg, Y)
    Y = Y + 36 + Config.ui.GAP
    self.getEggs, self.setEggs = makeCheckbox(self.frame, "Open Eggs", Config.defaults.doOpenEggs, Y)
    Y = Y + 24 + Config.ui.GAP
    self.getMaxEggs, self.setMaxEggs = makeCheckbox(self.frame, "Open Max Eggs", Config.defaults.doOpenMaxEggs, Y, 18)
    Y = Y + 24
    Y = Y + Config.ui.SEP_TOP_PADDING
    Y = addSeparator(self.frame, Y)
    self.getHouse = makeDropdown(self._gui, self.frame, "House:", Config.HOUSE_OPTIONS, Config.defaults.selectedHouse, Y)
    Y = Y + 36 + Config.ui.GAP
    self.getHouseT, self.setHouseT = makeCheckbox(self.frame, "Open House", Config.defaults.doOpenHouse, Y)
    Y = Y + 24
    Y = Y + Config.ui.SEP_TOP_PADDING
    Y = addSeparator(self.frame, Y)
    self.getClaim, self.setClaim = makeCheckbox(self.frame, "Claim Candy", Config.defaults.doClaimCandy, Y)
    Y = Y + 24 + 12
    self.toggleBtn = Instance.new("TextButton", self.frame)
    self.toggleBtn.Size = UDim2.new(1, -16, 0, 36)
    self.toggleBtn.Position = UDim2.fromOffset(8, Y)
    self.toggleBtn.BackgroundColor3 = Color3.fromRGB(44, 126, 76)
    self.toggleBtn.Font = Enum.Font.GothamBold
    self.toggleBtn.Text = "Start"
    self.toggleBtn.TextSize = 16
    self.toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", self.toggleBtn).CornerRadius = UDim.new(0, 8)
    Y = Y + 36 + 12
    self.exitBtn = Instance.new("TextButton", self.frame)
    self.exitBtn.Size = UDim2.new(1, -16, 0, 34)
    self.exitBtn.Position = UDim2.fromOffset(8, Y)
    self.exitBtn.BackgroundColor3 = Color3.fromRGB(168, 48, 48)
    self.exitBtn.Font = Enum.Font.GothamBold
    self.exitBtn.Text = "Exit"
    self.exitBtn.TextSize = 15
    self.exitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", self.exitBtn).CornerRadius = UDim.new(0, 8)
    Y = Y + 34 + 12
    self.frame.Size = UDim2.fromOffset(Config.ui.FRAME_WIDTH, math.max(Y, 300))
    local dragging, dragStart, startPos
    self.frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = self.frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            self.frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    self._onStart = nil
    self._onStop = nil
    self._onExit = nil
    self._running = false
    local function setUI(r)
        self._running = r
        self.toggleBtn.Text = r and "Stop" or "Start"
        self.toggleBtn.BackgroundColor3 = r and Color3.fromRGB(168,48,48) or Color3.fromRGB(44,126,76)
    end
    setUI(false)
    self.toggleBtn.MouseButton1Click:Connect(function()
        if self._running then
            setUI(false)
            if self._onStop then self._onStop() end
        else
            setUI(true)
            if self._onStart then self._onStart() end
        end
    end)
    self.exitBtn.MouseButton1Click:Connect(function()
        if self._onStop and self._running then self._onStop() end
        if self._onExit then self._onExit() end
        if self._gui and self._gui.Parent then self._gui:Destroy() end
    end)
    function self:getToggles()
        return {
            openEggs = self.getEggs(),
            openMaxEggs = self.getMaxEggs(),
            openHouse = self.getHouseT(),
            claimCandy = self.getClaim()
        }
    end
    function self:onStart(cb) self._onStart = cb end
    function self:onStop(cb) self._onStop = cb end
    function self:onExit(cb) self._onExit = cb end
    return self
end

return GUI
