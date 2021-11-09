-- Compiled with roblox-ts v1.2.7
local NyctoVersion
do
	NyctoVersion = setmetatable({}, {
		__tostring = function()
			return "NyctoVersion"
		end,
	})
	NyctoVersion.__index = NyctoVersion
	function NyctoVersion.new(...)
		local self = setmetatable({}, NyctoVersion)
		return self:constructor(...) or self
	end
	function NyctoVersion:constructor(major, minor, build, revision)
		self.major = major
		self.minor = minor
		self.build = build
		self.revision = revision
	end
end
return {
	NyctoVersion = NyctoVersion,
}
