import UnityEngine

#===========================================================#===========================================================
class Player( MonoBehaviour ):
	#===========================================================
	private _lightBlinking as bool = false
	private _lastBlinkTime as single
	private _lastLightSwitchTime as single
	
	public BlinkTime as single = 0.2
	public MaxLightSwitchTime as single = 5.0
	public MapCamera as Camera
	public Light as Light
	
	public static Instance as Player
	#===========================================================
	
	#Application.LoadLevel( "EndGame" )
	
	def Awake():
		Instance = self
		Spawn()
	
	def Update():
		roundPosition = transform.position /CubesGrid.Instance.transform.lossyScale.x
		roundPosition.x = Mathf.Round( roundPosition.x )
		roundPosition.y = Mathf.Round( roundPosition.y )
		roundPosition.z = Mathf.Round( roundPosition.z )
		Globals.PlayerPosition = roundPosition
		
		if( _lightBlinking ):
			if( Time.time > _lastBlinkTime ):
				Light.enabled = not Light.enabled
				_lastBlinkTime = Time.time + BlinkTime
		else:
			Light.enabled = true
		currentCube as VirtualCube = CubesGrid.Instance.GetCube( roundPosition )
		unless( currentCube == null ):
			MapCamera.enabled = currentCube.RoomType == CubeType.Map
			if( currentCube.RoomType == CubeType.Blinker ):
				if( Time.time > _lastLightSwitchTime ):
					_lastLightSwitchTime = Time.time + MaxLightSwitchTime #*Random.value
					_lightBlinking = not _lightBlinking
	def OnCollisionStay( inCollision as Collision ):
		for c1 as ContactPoint in inCollision.contacts:
			for c2 as ContactPoint in inCollision.contacts:
				if( Vector3.Distance((c1.point + c2.point)/2, transform.position) < 0.1 ):
					Spawn()
	#===========================================================
	public def Spawn():
		transform.localPosition.x = Random.Range(0, CubesGrid.Instance.GridSize)
		transform.localPosition.y = Random.Range(0, CubesGrid.Instance.GridSize)
		transform.localPosition.z = Random.Range(0, CubesGrid.Instance.GridSize)
		transform.position -= Vector3.one *2
	#===========================================================
