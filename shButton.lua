-- Delay para garantir que o hub carregou
task.delay(5, function()
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")

    -- Procura o ScreenGui principal do hub (Fluent)
    local HubGUI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScreenGui" then
            HubGUI = gui
            break
        end
    end

    if not HubGUI then
        warn("Hub não encontrado!")
        return
    end

    -- Cria o ScreenGui do botão externo
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "HubToggleButton"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = CoreGui

    -- Cria o botão
    local Button = Instance.new("ImageButton")
    Button.Name = "ToggleButton"
    Button.Size = UDim2.new(0, 60, 0, 60)
    Button.Position = UDim2.new(0, 20, 0, 200)
    Button.BackgroundTransparency = 1
    Button.Image = "rbxassetid://12232793816" -- sua imagem aqui
    Button.ScaleType = Enum.ScaleType.Fit
    Button.BorderSizePixel = 0
    Button.Parent = ToggleGui

    -- Variáveis para arrastar o botão
    local dragging = false
    local dragInput, dragStart, startPos

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Minimizar / restaurar hub
    local minimized = false
    Button.MouseButton1Click:Connect(function()
        minimized = not minimized
        HubGUI.Enabled = not minimized
    end)
end)
