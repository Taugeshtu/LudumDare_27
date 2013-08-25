import UnityEngine

enum CubeState:
	Void
	SemiVoid
	SemiFill
	Fill

enum CubeType:
	Regular
	Hazard
	Blinker
	InverseGravity
	Map
	EndRoom

#===========================================================#===========================================================
class VirtualCube:
	#===========================================================
	private _state as CubeState = CubeState.Fill
	private _isVoid as bool = false
	private _position as Vector3
	private _previousPosition as Vector3
	private _linkedCube as GameObject
	private _contents as GameObject
	
	public Id as int = 0
	public LinkedCap as GameObject
	public static Voids as List = List()
	#===========================================================
	public Position as Vector3:
		get:
			return _position
		set:
			_position = value
			unless( LinkedCap == null ):
				LinkedCap.transform.localPosition = _position
	public LinkedCube as GameObject:
		get:
			return _linkedCube
		set:
			_linkedCube = value
			unless( _linkedCube == null ):
				if( IsVoid ):
					_linkedCube.transform.position = -Vector3.one *100700
				
	public State as CubeState:
		get:
			return _state
	public IsVisible as bool:
		get:
			if( XY == Globals.PlayerXY
			 or XZ == Globals.PlayerXZ
			 or YZ == Globals.PlayerYZ ):
			 	return true
			return false
	public IsVoid as bool:
		get:
			return _isVoid
		set:
			_isVoid = value
			if( _isVoid ):
				_state = CubeState.Void
				Voids.Add( self )
			else:
				_state = CubeState.Fill
				Voids.Remove( self )
	public IsMoving as bool:
		get:
			if( _state == CubeState.SemiVoid or _state == CubeState.SemiFill ):
				return true
			return false
	public MovementDirection as Vector3:
		get:
			if( IsMoving ):
				return Position - _previousPosition
			else:
				if( XY == Globals.PlayerXY ):
					return Vector3.forward
				if( XZ == Globals.PlayerXZ ):
					return Vector3.up
				if( YZ == Globals.PlayerYZ ):
					return Vector3.right
	
	public X as int:
		get:
			return Position.x
	public Y as int:
		get:
			return Position.y
	public Z as int:
		get:
			return Position.z
	
	public XY as Vector2:
		get:
			return Vector2( Position.x, Position.y )
	public XZ as Vector2:
		get:
			return Vector2( Position.x, Position.z )
	public YZ as Vector2:
		get:
			return Vector2( Position.y, Position.z )
	#===========================================================
	def constructor( inX as int, inY as int, inZ as int ):
		Position = Vector3( inX, inY, inZ )
		_previousPosition = Position
		Id = Random.Range( 0, 100600 )
		/*if( Random.value < 0.05 ):
			_isVoid = true
			Voids.Add( self )*/
	#===========================================================
	public static def Swap( inCubeA as VirtualCube, inCubeB as VirtualCube ):
		storedPosition = inCubeA.Position
		inCubeA.SetMoving( inCubeB.Position )
		inCubeB.SetMoving( storedPosition )
	#===========================================================
	public def SetMoving( inTargetPosition as Vector3 ):
		if( IsVoid ):
			_state = CubeState.SemiVoid
		else:
			_state = CubeState.SemiFill
		_previousPosition = Position
		Position = inTargetPosition
	
	public def StopMoving():
		if( IsVoid ):
			_state = CubeState.Void
		else:
			_state = CubeState.Fill
		_previousPosition = Position
		unless( LinkedCap == null ):
			Object.DestroyImmediate( LinkedCap )
			LinkedCap = null
	
	public def SmoothPosition( inFactor as single ) as Vector3:
		if( IsMoving ):
			return Vector3.Lerp( _previousPosition, Position, inFactor )
		else:
			return Position
	#===========================================================
