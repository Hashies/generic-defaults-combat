// Variables that are used on both client and server
SWEP.Category				= "Generic Default's Weapons"
SWEP.Author				= "Generic Default"
SWEP.Contact				= "AIDS!"
SWEP.Purpose				= "Killing"
SWEP.Instructions				= "Round: 7.62x51 \nVelocity: ~850 m/s \nSights: Mil Dot 9x \nCapacity: 10 rounds \nRate of Fire: 55 rounds per minute"
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.DrawCrosshair			= false	

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_GDCW_AWP.mdl"
SWEP.WorldModel				= "models/weapons/w_GDCAWP.mdl"
SWEP.Base 				= "gdcw_base_rifleman"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("AWPF.single")
SWEP.Primary.Round			= ("gdcwa_7.62x51_ap")
SWEP.Primary.RPM				= 55					// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10					// Size of a clip
SWEP.Primary.DefaultClip			= 11					// Default number of bullets in a clip
SWEP.Primary.KickUp			= 0.6						// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.6						// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.6						// Maximum up recoil (stock)
SWEP.Primary.Automatic			= false					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.ClipSize			= 1					// Size of a clip
SWEP.Secondary.DefaultClip			= 1					// Default number of bullets in a clip
SWEP.Secondary.Automatic			= false					// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""
SWEP.Secondary.ScopeZoom			= 9		
SWEP.Secondary.UseRangefinder		= true	
SWEP.Secondary.UseMilDot			= true	

SWEP.data 				= {}					-- The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 				= 0.7

SWEP.IronSightsPos = Vector (3.2269, -3.3734, 1.3315)
SWEP.IronSightsAng = Vector (0, 0, 0)