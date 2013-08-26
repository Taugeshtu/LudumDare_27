import UnityEngine

#===========================================================#===========================================================
class MovingWall( MonoBehaviour ):
	#===========================================================
	public Bias as single = 0.5
	public Speed as single = 0.5
	#===========================================================
	def Update():
		transform.localPosition = Vector3.up *Mathf.Sin( 3.14 *Time.time /Speed ) *Bias
	#===========================================================
