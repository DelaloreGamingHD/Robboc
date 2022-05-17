getgenv().exp = "Torso"
function hitbox2x()
    local players = game:GetService("Workspace").Players

    local OldIndex = nil

    OldIndex =
        hookmetamethod(
        players,
        "__index",
        function(Self, Key)
            if not checkcaller() and getgenv().expandHitbox then
                
                if not checkcaller() and tostring(Self) == getgenv().exp and Key == "Size" then
                    return Vector3.new(getgenv().head_size, getgenv().head_size, getgenv().head_size)
                end
            end

            return OldIndex(Self, Key)
        end
    )
end



tab:DropDown({
    Text = "Hitbox",
    PlaceHolder = 'Choose An Part...',
    Options = {'Head', "Torso"},
    Callback = function(args)
        getgenv().exp = args
    end
})

tab:Slider({
    Title = "Hitbox Size",
    MinValue = 1,
    Def = 2,
    MaxValue = 5,
    callback = function(args)
        getgenv().head_size = args
    end
})

tab:Toggle({
    Title = "Enable",
    Description = "Hitbox becomes bigger!",
    Callback = function(args)
        if not getgenv().expandHitbox then
            hitbox2x()
        end
        getgenv().expandHitbox = args
    end
})
