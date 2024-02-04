function CheckVersion()
    local updatePath = 'https://raw.githubusercontent.com/ugcore-framework/ug-contextMenu/main/version.json'
    PerformHttpRequest(updatePath, function (status, body, headers, errorData)
        local data = json.decode(body)
        local localData = json.decode(LoadResourceFile(GetCurrentResourceName(), 'version.json'))
        local currentVersion = localData.Version

        if not data or not currentVersion then
            print('^7[ug-contextMenu]: ====================================')
            print('^7[ug-contextMenu]: ^1Error on getting the updates!^7')
            print('^7[ug-contextMenu]: ^1Please try updating the framework to make this working again.^7')
            print('^7[ug-contextMenu]: ^1If you updated and it\'s still not working, then maybe it\'s an API problem, and you must wait.^7')
	        print('^7[ug-contextMenu]: ====================================')
        elseif type(currentVersion) ~= 'number' or type(data.Version) ~= 'number' then
            print('^7[ug-contextMenu]: ====================================')
            print('^7[ug-contextMenu]: ^1Detected Broked Version Checker!^7')
            print('^7[ug-contextMenu]: ^1Your version is not a valid number.^7')
            print('^7[ug-contextMenu]: ^1Please try updating the framework to make this working again.^7')
            print('^7[ug-contextMenu]: ====================================')
        elseif tonumber(currentVersion) > tonumber(data.Version) then
            print('^7[ug-contextMenu]: ====================================')
            print('^7[ug-contextMenu]: ^1Detected Broked Version Checker!^7')
            print('^7[ug-contextMenu]: ^1Your version is greater than the most recently updated version.^7')
            print('^7[ug-contextMenu]: ^1Please try updating the framework to make this working again.^7')
	        print('^7[ug-contextMenu]: ====================================')
        elseif currentVersion ~= data.Version and tonumber(currentVersion) < tonumber(data.Version) then
            print('^7[ug-contextMenu]: ====================================')
            print('^7[ug-contextMenu]: ^3New Update Found!^7')
            print('^7[ug-contextMenu]: ^3Your Version: ^1' .. currentVersion .. '^7')
            print('^7[ug-contextMenu]: ^3New Version: ^2' .. data.Version .. '^7')
            print('^7[ug-contextMenu]: ^3Changelogs: ^2' .. data.Changelogs .. '^7')
            print('^7[ug-contextMenu]: ')
            print('^7[ug-contextMenu]: ^3Update here:')
            print('^7[ug-contextMenu]: ^3https://github.com/ugcore-framework/ug-contextMenu/releases')
	        print('^7[ug-contextMenu]: ====================================')
        end
    end, 'GET')
end

CreateThread(function ()
    Wait(2500)
    CheckVersion()
end)