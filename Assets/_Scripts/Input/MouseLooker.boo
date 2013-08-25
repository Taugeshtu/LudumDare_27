import UnityEngine

#===========================================================#===========================================================
class MouseLooker( MonoBehaviour ):
	#===========================================================
	public Speed as single = 10.0
	public IsPlayerItself as bool = false
	#===========================================================
	def Start():
		unless( IsPlayerItself ):
			Screen.lockCursor = true
	def Update():
		if( IsPlayerItself ):
			transform.Rotate( Vector3.up, Input.GetAxis("mouseX") *Speed *Time.deltaTime, Space.World )
		else:
			if( Input.GetKeyDown( KeyCode.Escape ) ):
				Screen.lockCursor = false
			if( Input.GetMouseButtonDown( 0 ) ):
				Screen.lockCursor = true
			
			if( Screen.lockCursor ):
				diffAngle = Vector3.Angle( transform.forward, Vector3.up )
				rotationAngle = -Input.GetAxis("mouseY") *Speed *Time.deltaTime
				postAngle = diffAngle + rotationAngle
				postAngle = Mathf.Clamp( postAngle, 5, 175 )
				rotationAngle = postAngle - diffAngle
				#Debug.Log( "Rotation angle: "+rotationAngle.ToString("000.0") )
				transform.Rotate( transform.right, rotationAngle, Space.World )
			Screen.showCursor = not Screen.lockCursor
	#===========================================================
	private def SomeFunction():
		pass
	#===========================================================
