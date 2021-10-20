writefile("PineApple.txt",syn.request({Url="https://github.com/machport/asd/raw/main/UI.rbxm"}).Body)
function wrap(script)
    f,e = loadstring(script.Source)
    print(f,e)
    env = setmetatable({},{__index= function(self,key) if key == "script" then return script end return getfenv()[key] end})
    setfenv(f,env)
    return f
end
e = game:GetObjects(getsynasset("PineApple.txt"))[1]
e.Parent=game.CoreGui
for i,v in pairs(e:GetDescendants()) do
    if v.ClassName:match("Script") then
        spawn(wrap(v))
    end
end
