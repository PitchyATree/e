--[[made by tenkai into v3rmillion
https://v3rmillion.net/member.php?action=profile&uid=2704198
]]
local Players = game:GetService("Players")
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/1201/infinite/Functionality.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/1201/infinite/Extensions/Visuals.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/1337-svg/1201/infinite/Extensions/Data.lua'))()

local Window = Library:CreateWindow({
   Title = 'V1.1',
   Center = true,
   AutoShow = true,
   TabPadding = 8,
   MenuFadeTime = .11
})

local Tabs = {
   ['General'] = Window:AddTab('General'),
}

local Categories = {
   ['Waypoints'] = Tabs['General']:AddLeftGroupbox('Waypoints');
   ['Menu'] = Tabs['General']:AddRightGroupbox('Menu');
   ['Settings'] = Tabs['General']:AddRightGroupbox('Settings');

   ['Mods1'] = Tabs['General']:AddLeftTabbox();
}

local MiniTabs = {
   ['Mods1_1'] = Categories['Mods1']:AddTab('Modifiers');
   ['Mods1_2'] = Categories['Mods1']:AddTab('Descent');
}

Categories['Menu']:AddLabel('Hide/Show the Library'):AddKeyPicker('MenuKeybind', { Default = 'Semicolon', NoUI = true, Text = 'Hide UI'}) Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
Categories['Menu']:AddButton('Unload', function() Library:Unload() end)
Categories['Settings']:AddButton('Rejoin', function() local tpservice= game:GetService("TeleportService") local plr= game.Players.LocalPlayer tpservice:Teleport(game.PlaceId, plr) end)

-- // Variables
local Location = nil
local fdcall_mode: nil = false
local fdcall_modifier: nil = 1

-- // Actual Code //
Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
   FrameCounter += 1;

   if (tick() - FrameTimer) >= 1 then
       FPS = FrameCounter;
       FrameTimer = tick();
       FrameCounter = 0;
   end;

   Library:SetWatermark(('%s fps | %s ms'):format(
       math.floor(FPS),
       math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
   ));
end);

MiniTabs['Mods1_1']:AddLabel("Coming soon, don't know what to add here.", true)
MiniTabs['Mods1_2']:AddLabel("Legitimate/ Reduces fall damage\nbased on percentage.\nBlatant/ Immnue to fall damage.\nFixed/ Always take a set number \nof fall damage based on percentage.", true)

-- Waypoints // Teleports
Categories['Waypoints']:AddDropdown('CPs', {
   Default = 1,
   Tooltip = 'Select a level checkpoint to teleport too.',
   Values = {
    'Level 0', 'Level 1',
    'Level 2', 'Level 3',
    'Level 4', 'Level 5',
    'Level 6', 'Level 7',
    'Level 8', 'Level 9',
    'Level 10', 'Level 11',
    'Level 12'
   },

   Callback = function(v)
       local Checkpoints = {
           [0] = Vector3.new(-49.385, 21415.140, 330.098);
           [1] = Vector3.new(-11.140, 21254.804, -105.859);
           [2] = Vector3.new(40.798, 21014.205, -166.890);
           [3] = Vector3.new(-298.291, 20995.705, -412.291);
           [4] = Vector3.new(-39.154, 20781.117, -595.470);
           [5] = Vector3.new(-82.000244, 20344.205, -786.166);
           [6] = Vector3.new(-205.733, 20041.533, -185.299);
           [7] = Vector3.new(-413.639, 19797.994, -498.603);
           [8] = Vector3.new(186.499, 19421.814, -79.00022);
           [9] = Vector3.new(-411.593, 19156.703, -552.936);
           [10] = Vector3.new(286.097, 19112.621, -690.477);
           [11] = Vector3.new(323.138, 18789.066, -281.298);
           [12] = Vector3.new(-297.139, 18716.789, -724.757);
       }

       for level,checkpoint in next, Checkpoints do
           local sp = string.split(v, " ")
           for _,integer in pairs(sp) do
               pcall(function() if typeof(tonumber(integer)) == "number" then
                       if level == tonumber(integer) then
                           Location = checkpoint
                       end
                   end
               end)
           end
       end
   end
 
});

Categories['Waypoints']:AddButton({
   Text = 'Teleport',
   DoubleClick = false,
   Tooltip = 'Teleport to the selected checkpoint.',
   Func = function()
       if Location ~= nil then
           game:GetService("TweenService"):Create(
               Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart'),
               TweenInfo.new(.02, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, 0, false, 0),
               {Position = Location}
           ):Play()
       end
   end
});

-- Fall Damage Modifications // FDs
MiniTabs['Mods1_2']:AddDropdown('CPs', {
   Default = 'Legitimate',
   Tooltip = 'Select a level checkpoint to teleport too.',
   Values = {
       'Fixed',
    'Legitimate',
       'Blatant',
   },

   Callback = function(v)
       fdcall_mode = tostring(v)
   end
 
});

MiniTabs['Mods1_2']:AddSlider('FD_Mod', {
   Text = 'Amount/Percentage',
   Default = 0,
   Min = 0,
   Max = 100,
   Rounding = 1,
   Suffix = "%",
   Compact = false,

   Callback = function(v)
       if fdcall_mode == "Legitimate" then
           if v == 0 then
               fdcall_modifier = 1
           else
               fdcall_modifier = (1 + v/100)
           end
       elseif fdcall_mode == "Fixed" then
           fdcall_modifier = v
       end
   end
})

-- Functionality //

local fdcall: nil
fdcall = hookmetamethod(game, "__namecall", function(self, ...)
   local link = tostring(self):lower()
   local modifiedargs, args = {...}, {...}
   local method = tostring(getnamecallmethod()):lower()
   if not checkcaller() and method == 'fireserver' and link == 'fallreport' then
       if typeof(fdcall_mode) == "string" then
           if fdcall_mode == "Legitimate" then
               modifiedargs[1] = (args[1]/fdcall_modifier)
               return fdcall(self, unpack(modifiedargs))
           elseif fdcall_mode == "Blatant" then
               modifiedargs[1] = math.huge
               return fdcall(self, unpack(modifiedargs))
           elseif fdcall_mode == "Fixed" then
               modifiedargs[1] = (-100 - fdcall_modifier)
               return fdcall(self, unpack(modifiedargs))
           end
       else
           fdcall(self, ...)
       end
   end
   return fdcall(self, ...)
end)

local __hookcall: nil
__hookcall = hookmetamethod(game, "__namecall", function(self, ...)
   local link = tostring(self):lower()
   local modifiedargs, args = {...}, {...}
   local method = tostring(getnamecallmethod()):lower()
   if not checkcaller() and method == 'fireserver' and link == 'updatevelocity' then
       print("[/255] aka please don't fuck up my jump directory!")
       return
   end
   return __hookcall(self, ...)
end)
