import UnityEngine

#===========================================================#===========================================================
class PositionMarker( MonoBehaviour ):
	#===========================================================
	def Update():
		guiText.text = ("Position: "+
		 (Globals.PlayerPosition.x +1).ToString("00")+"-"+
		 (Globals.PlayerPosition.y +1).ToString("00")+"-"+
		 (Globals.PlayerPosition.z +1).ToString("00"))
		#guiText.text = "Position: "+Globals.PlayerPosition
	#===========================================================
