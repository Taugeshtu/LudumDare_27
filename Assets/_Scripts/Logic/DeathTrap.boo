import UnityEngine

#===========================================================#===========================================================
class DeathTrap( MonoBehaviour ):
	#===========================================================
	def OnTriggerEnter():
		Player.Instance.Spawn( true )
	#===========================================================
