// Variables that are used on both client and server
SWEP.Category				= "Generic Default's Weapons"
SWEP.Author				= "Generic Default"
SWEP.Contact				= "AIDS!"
SWEP.Purpose				= "Armor piercing rounds."
SWEP.Instructions				= "Round: 5.7mm \nVelocity: ~625 m/s \nSights: Iron \nCapacity: 20 rounds \nRate of Fire: 1000 rounds per minute"
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false	

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_GDCW_FIVESEVEN.mdl"
SWEP.WorldModel				= "models/weapons/w_GDC_FiveSeven.mdl"
SWEP.Base 				= "gdcw_base_pistol"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("FiveSevenF.single")
SWEP.Primary.Round			= ("gdcwa_5.7x28_625")
SWEP.Primary.RPM				= 1000						// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 20						// Size of a clip
SWEP.Primary.DefaultClip			= 21
SWEP.Primary.KickUp			= 0.3					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.3					// Maximum up recoil (stock)
SWEP.Primary.Automatic			= false					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize			= 1						// Size of a clip
SWEP.Secondary.DefaultClip			= 1						// Default number of bullets in a clip
SWEP.Secondary.Automatic			= false						// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""
SWEP.Secondary.IronFOV			= 50						// How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}						// The starting firemode
SWEP.data.ironsights			= 1


SWEP.IronSightsPos = Vector (2.7613, 0, 0.7447)
SWEP.IronSightsAng = Vector (1.3772, -0.0429, 0)
SWEP.SightsPos = Vector (2.7613, 0, 0.7447)
SWEP.SightsAng = Vector (1.3772, -0.0429, 0)
SWEP.RunSightsPos = Vector (0.4386, 0, 3.9572)
SWEP.RunSightsAng = Vector (-25.8692, -0.9294, 0)
SWEP.GSightsPos = Vector (0.6, -2.6, -1.7)
SWEP.GSightsAng = Vector (0, 0, 65)
