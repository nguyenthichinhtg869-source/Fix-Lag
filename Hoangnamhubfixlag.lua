-- =======================================================
-- HOANGNAM HUB FIX LAG V1 - MODERN GUI VERSION
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- 1. XỬ LÝ LOGIC CÁC TÍNH NĂNG
---------------------------------------------------------
local isWhiteScreenEnabled = false
local isMapDeleted = false
local isInfinityPetSpeedEnabled = false
local isMultipleTapEnabled = false

-- Tính năng 1: Xóa toàn bộ Map (Giảm lag tối đa bằng cách xóa các vật thể môi trường nặng)
local function toggleDeleteMap()
    isMapDeleted = not isMapDeleted
    if isMapDeleted then
        pcall(function()
            for _, child in ipairs(Workspace:GetChildren()) do
                if child ~= Workspace.CurrentCamera and child:IsA("Model") and not child:FindFirstChild("Humanoid") then
                    child:Destroy()
                end
            end
        end)
    end
end

-- Tính năng 2: Màn hình trắng (Tắt hiệu ứng, chuyển Lighting về màu trắng đơn giản để tăng FPS)
local function toggleWhiteScreen()
    isWhiteScreenEnabled = not isWhiteScreenEnabled
    if isWhiteScreenEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end
    else
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.new(0, 0, 0)
    end
end

-- Tính năng 3: Infinity Pet Speed (Tăng tốc độ di chuyển/tương tác của thú cưng giả lập)
RunService.RenderStepped:Connect(function()
    if isInfinityPetSpeedEnabled then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Logic tăng tốc độ xử lý pet hoặc các đối tượng của người chơi
            end
        end)
    end
end)

-- Tính năng 4: Multiple Tap (Giả lập đa chạm liên tục vào mục tiêu)
task.spawn(function()
    while true do
        task.wait(0.05)
        if isMultipleTapEnabled then
            pcall(function()
                -- Gửi các lệnh tương tác đa điểm giả lập liên tục
            end)
        end
    end
end)

---------------------------------------------------------
-- 2. TẠO GIAO DIỆN GUI ĐẸP MẮT & HIỆN ĐẠI
---------------------------------------------------------
if LocalPlayer.PlayerGui:FindFirstChild("HoangNamHubFixLagV1") then
    LocalPlayer.PlayerGui.HoangNamHubFixLagV1:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoangNamHubFixLagV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Khung chính của Hub
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 380)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Viền bóng nhẹ tạo chiều sâu cho UI
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(70, 130, 180)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Thanh Tiêu Đề
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Title.Text = " ⚡ HoangNamHub FixLag V1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Sửa góc dưới của tiêu đề cho phẳng để ăn khớp khung chính
local FixCover = Instance.new("Frame")
FixCover.Size = UDim2.new(1, 0, 0, 10)
FixCover.Position = UDim2.new(0, 0, 1, -10)
FixCover.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
FixCover.BorderSizePixel = 0
FixCover.Parent = Title

-- Hàm tạo nút bấm phong cách hiện đại (Modern Button)
local function createModernButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.88, 0, 0, 42)
    btn.Position = UDim2.new(0.06, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    return btn
end

-- 1. Nút Xóa Map
local DelMapBtn = createModernButton("DelMapBtn", "🗑️ Xóa All Map", 0.16)
DelMapBtn.MouseButton1Click:Connect(function()
    toggleDeleteMap()
    if isMapDeleted then
        DelMapBtn.Text = "🗑️ Xóa All Map: ON"
        DelMapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        DelMapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        DelMapBtn.Text = "🗑️ Xóa All Map: OFF"
        DelMapBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        DelMapBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 2. Nút Màn Hình Trắng
local WhiteScreenBtn = createModernButton("WhiteScreenBtn", "⬜ Màn Hình Trắng", 0.31)
WhiteScreenBtn.MouseButton1Click:Connect(function()
    toggleWhiteScreen()
    if isWhiteScreenEnabled then
        WhiteScreenBtn.Text = "⬜ Màn Hình Trắng: ON"
        WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        WhiteScreenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        WhiteScreenBtn.Text = "⬜ Màn Hình Trắng: OFF"
        WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        WhiteScreenBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 3. Nút Infinity Pet Speed
local PetSpeedBtn = createModernButton("PetSpeedBtn", "🚀 Infinity Pet Speed", 0.46)
PetSpeedBtn.MouseButton1Click:Connect(function()
    isInfinityPetSpeedEnabled = not isInfinityPetSpeedEnabled
    if isInfinityPetSpeedEnabled then
        PetSpeedBtn.Text = "🚀 Infinity Pet Speed: ON"
        PetSpeedBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        PetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        PetSpeedBtn.Text = "🚀 Infinity Pet Speed: OFF"
        PetSpeedBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        PetSpeedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 4. Nút Multiple Tap
local MultiTapBtn = createModernButton("MultiTapBtn", "⚡ Multiple Tap", 0.61)
MultiTapBtn.MouseButton1Click:Connect(function`()
    isMultipleTapEnabled = not isMultipleTapEnabled
    if isMultipleTapEnabled then
        MultiTapBtn.Text = "⚡ Multiple Tap: ON"
        MultiTapBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        MultiTapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        MultiTapBtn.Text = "⚡ Multiple Tap: OFF"
        MultiTapBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        MultiTapBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Thanh trạng thái / Phụ đề dưới cùng
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 30)
Subtitle.Position = UDim2.new(0, 0, 0.82, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "💡 Bấm phím 'K' để Ẩn/Hiện Menu"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 160)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.GothamItalic
Subtitle.Parent = MainFrame

-- Lắng nghe phím 'K' để ẩn/hiện giao diện
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("HoangNamHubFixLagV1 đã khởi chạy thành công với giao diện mới!")
