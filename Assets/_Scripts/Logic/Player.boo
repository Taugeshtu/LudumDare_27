import UnityEngine

#===========================================================#===========================================================
class Player( MonoBehaviour ):
	#===========================================================
	
	#===========================================================
	def Start():
		pass
	
	def Update():
		roundPosition = transform.localPosition
		roundPosition.x = Mathf.Round( roundPosition.x )
		roundPosition.y = Mathf.Round( roundPosition.y )
		roundPosition.z = Mathf.Round( roundPosition.z )
		Globals.PlayerPosition = roundPosition
		
		currentCube as VirtualCube = CubesGrid.Instance.GetCube( roundPosition )
	#===========================================================
	private def SomeFunction():
		pass
	#===========================================================
