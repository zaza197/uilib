-- UI Library Code
local library = {tabs = {}, options = {}, flags = {}, theme = {}, instances = {}, connections = {}}

-- Services
local runService = game:GetService("RunService")
local textService = game:GetService("TextService")
local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Library Defaults
library.design = "default"
library.draggable = true
library.title = "UI Library"
library.open = false
library.mousestate = inputService.MouseIconEnabled
library.popup = nil
library.tabSize = 0
library.foldername = "UI_Library"
library.fileext = ".json"

-- Rounding Function
library.round = function(num, bracket)
    if typeof(num) == "Vector2" then
        return Vector2.new(library.round(num.X), library.round(num.Y))
    elseif typeof(num) == "Vector3" then
        return Vector3.new(library.round(num.X), library.round(num.Y), library.round(num.Z))
    elseif typeof(num) == "Color3" then
        return library.round(num.r * 255), library.round(num.g * 255), library.round(num.b * 255)
    else
        return num - num % (bracket or 1)
    end
end

-- Create GUI Elements
function library:Create(class, properties)
    properties = properties or {}
    local instance = Instance.new(class)
    for property, value in next, properties do
        instance[property] = value
    end
    table.insert(self.instances, instance)
    return instance
end

-- Add Connections
function library:AddConnection(connection, name, callback)
    callback = type(name) == "function" and name or callback
    connection = connection:Connect(callback)
    if name ~= callback then
        self.connections[name] = connection
    else
        table.insert(self.connections, connection)
    end
    return connection
end

-- Unload Library
function library:Unload()
    inputService.MouseIconEnabled = self.mousestate
    for _, c in next, self.connections do
        c:Disconnect()
    end
    for _, i in next, self.instances do
        i:Destroy()
    end
    for _, o in next, self.options do
        if o.type == "toggle" then
            coroutine.resume(coroutine.create(o.SetState, o))
        end
    end
    library = nil
end

-- Add Tab
function library:AddTab(title, pos)
    local tab = {canInit = true, tabs = {}, columns = {}, title = tostring(title)}
    table.insert(self.tabs, pos or #self.tabs + 1, tab)

    function tab:AddColumn()
        local column = {sections = {}, position = #self.columns, canInit = true, tab = self}
        table.insert(self.columns, column)

        function column:AddSection(title)
            local section = {title = tostring(title), options = {}, canInit = true, column = self}
            table.insert(self.sections, section)

            function section:AddLabel(text)
                local option = {text = text}
                option.section = self
                option.type = "label"
                option.position = #self.options
                option.canInit = true
                table.insert(self.options, option)

                if library.hasInit and self.hasInit then
                    library.createLabel(option, self.content)
                else
                    option.Init = library.createLabel
                end

                return option
            end

            function section:AddToggle(option)
                option = typeof(option) == "table" and option or {}
                option.section = self
                option.text = tostring(option.text)
                option.state = option.state == nil and nil or (typeof(option.state) == "boolean" and option.state or false)
                option.callback = typeof(option.callback) == "function" and option.callback or function() end
                option.type = "toggle"
                option.position = #self.options
                option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
                option.subcount = 0
                option.canInit = (option.canInit ~= nil and option.canInit) or true
                option.tip = option.tip and tostring(option.tip)
                option.style = option.style == 2
                library.flags[option.flag] = option.state
                table.insert(self.options, option)
                library.options[option.flag] = option

                function option:AddColor(subOption)
                    subOption = typeof(subOption) == "table" and subOption or {}
                    subOption.sub = true
                    subOption.subpos = self.subcount * 24
                    function subOption:getMain() return option.main end
                    self.subcount = self.subcount + 1
                    return section:AddColor(subOption)
                end

                if library.hasInit and self.hasInit then
                    library.createToggle(option, self.content)
                else
                    option.Init = library.createToggle
                end

                return option
            end

            function section:AddButton(option)
                option = typeof(option) == "table" and option or {}
                option.section = self
                option.text = tostring(option.text)
                option.callback = typeof(option.callback) == "function" and option.callback or function() end
                option.type = "button"
                option.position = #self.options
                option.flag = (library.flagprefix and library.flagprefix .. " " or "") .. (option.flag or option.text)
                option.subcount = 0
                option.canInit = (option.canInit ~= nil and option.canInit) or true
                option.tip = option.tip and tostring(option.tip)
                table.insert(self.options, option)
                library.options[option.flag] = option

                if library.hasInit and self.hasInit then
                    library.createButton(option, self.content)
                else
                    option.Init = library.createButton
                end

                return option
            end

            return section
        end

        return column
    end

    return tab
end

-- Initialize Library
function library:Init()
    if self.hasInit then return end
    self.hasInit = true

    self.base = self:Create("ScreenGui", {IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global})
    self.base.Parent = game:GetService("CoreGui")

    self.main = self:Create("Frame", {
        Position = UDim2.new(0, 100, 0, 46),
        Size = UDim2.new(0, 500, 0, 600),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderColor3 = Color3.new(),
        Visible = false,
        Parent = self.base
    })

    -- Add more UI elements here (e.g., tabs, buttons, sliders)
end

-- Return Library
return library
