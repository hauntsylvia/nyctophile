-- Compiled with roblox-ts v1.2.7
local Database
do
	Database = setmetatable({}, {
		__tostring = function()
			return "Database"
		end,
	})
	Database.__index = Database
	function Database.new(...)
		local self = setmetatable({}, Database)
		return self:constructor(...) or self
	end
	function Database:constructor()
		local name = "11-02-2021.A.1"
		print("initialized database: " .. name)
		self.database = game:GetService("DataStoreService"):GetDataStore(name)
	end
end
return {
	Database = Database,
}
