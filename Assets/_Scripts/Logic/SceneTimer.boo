import UnityEngine

#===========================================================#===========================================================
class SceneTimer( MonoBehaviour ):
	#===========================================================
	private _timer as single
	
	public Delay as single = 10.0
	#===========================================================
	def Start():
		_timer = Time.time + Delay
	
	def Update():
		if( Time.time > _timer ):
			Application.Quit()
	#===========================================================
