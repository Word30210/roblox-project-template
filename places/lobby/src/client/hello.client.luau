const Players = game:GetService("Players")

const shared = require("@shared")
const assets = shared.assets

const localPlayer = Players.LocalPlayer
const playerGui = localPlayer.PlayerGui

const screen = Instance.new("ScreenGui")
screen.ResetOnSpawn = false
screen.Parent = playerGui

const imageButton = Instance.new("ImageButton")
imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
imageButton.Position = UDim2.fromScale(0.5, 0.5)
imageButton.Size = UDim2.fromOffset(200, 200)
imageButton.BackgroundTransparency = 1
imageButton.Image = assets["osaka_bird.png"]
imageButton.Parent = screen

const sound = Instance.new("Sound")
sound.SoundId = assets["Osaka_HaHaa.ogg"]
sound.Parent = imageButton

imageButton.MouseButton1Click:Connect(function()
    print("osaka clicked!")

    sound:Play()
end)
