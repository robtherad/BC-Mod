class ctrlMenuStrip;
class display3DEN
{
	class Controls
	{
		class MenuStrip : ctrlMenuStrip
		{
			class Items
			{
				items[] += {"TMF_Folder"};
				class TMF_Folder {
					text = "Teamwork";
					items[] = {"TMF_Settings"};
				};
				class TMF_Settings
				{
					text = "TMF Settings";
					action = "edit3DENMissionAttributes 'TMF_Settings';";
					picture = "\y\bc\addons\common\UI\icon_gear_ca";
				};
			};
		};
	};
};