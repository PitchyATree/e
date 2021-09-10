local Dex = rawget(game:GetObjects("rbxassetid://3567096419"), 0X1)
if type(syn) == "table" and type(syn.protect_gui) == "function" then
    xpcall(syn.protect_gui, warn, Dex)
end
Dex.Name, Dex.Parent = "SynapseDex", game:GetService("CoreGui")
function Load(x)
    if x:IsA("Script") then
        xpcall(coroutine.wrap(function()
            local Fenv, FenvMt, RealFenv, Func = {}, {}, {
                script = x
            }, loadstring(x.Source, "=" .. x:GetFullName())
            FenvMt.__index = function(a, b)
                if RealFenv[b] == nil then
                    return getfenv()[b]
                else
                    return RealFenv[b]
                end
            end
            FenvMt.__newindex = function(a, b, c)
                if RealFenv[b] == nil then
                    getfenv()[b] = c
                else
                    RealFenv[b] = c
                end
            end
            setmetatable(Fenv, FenvMt)
            setfenv(Func, Fenv)
            return Func()
        end), warn)
    end
    for _, v in pairs(x:GetChildren()) do
        xpcall(Load, warn, v)
    end
end
xpcall(Load, warn, Dex)
