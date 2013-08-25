import UnityEngine

#===========================================================#===========================================================
class PlayerMover( MonoBehaviour ):
	#===========================================================
	private _onTheFloor as bool = false
	private _movementDirection as Vector3
	private _jumpDirection as Vector3
	
	public MaxSpeed as single = 1.0
	public MoveForce as single = 10.0
	public JumpForce as single = 10.0
	public CastLength as single = 1.2
	public CastRadius as single = 0.3
	public PushoutDistance as single = 0.4
	public PushOutAcceleration as single = 12.0
	#===========================================================
	def Awake():
		CastLength -= CastRadius
	def Update():
		_movementDirection = Vector3( Input.GetAxis( "Horizontal" ), 0, Input.GetAxis( "Vertical" ) )
		_movementDirection.Normalize()
		_jumpDirection = (Vector3.up + _movementDirection*1.5) *Input.GetAxis( "Jump" )
	def FixedUpdate():
		CastCheck()
		rigidbody.AddRelativeForce( _movementDirection *MoveForce )
		if( _onTheFloor ):
			rigidbody.AddRelativeForce( _jumpDirection *JumpForce )
		rigidbody.velocity.x = Mathf.Clamp( rigidbody.velocity.x, -MaxSpeed, MaxSpeed )
		rigidbody.velocity.z = Mathf.Clamp( rigidbody.velocity.z, -MaxSpeed, MaxSpeed )
	#===========================================================
	private def CastCheck():
		_onTheFloor = false
		hitInfo as RaycastHit
		ray = Ray( transform.position, Vector3.down )
		if( Physics.SphereCast( ray, CastRadius, hitInfo, CastLength, 1 ) ):
			if( hitInfo.distance < PushoutDistance ):
				diff = PushoutDistance - hitInfo.distance
				rigidbody.AddForce( Vector3.up *PushOutAcceleration *diff, ForceMode.Acceleration )
			if( hitInfo.distance < (CastLength + CastRadius) ):
				_onTheFloor = true
	#===========================================================
