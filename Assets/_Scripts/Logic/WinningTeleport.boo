import UnityEngine

#===========================================================#===========================================================
class WinningTeleport( MonoBehaviour ):
	#===========================================================
	def OnTriggerEnter():
		Application.LoadLevel( "EndGame" )
	#===========================================================
