import UnityEngine

#===========================================================#===========================================================
class VirtualCube:
	#===========================================================
	private _isVoid as bool = false
	private _position as Vector3
	#===========================================================
	public IsVisible as bool:
		get:
			if( XY == Globals.PlayerXY
			 or XZ == Globals.PlayerXZ
			 or YZ == Globals.PlayerYZ ):
			 	return true
			return false
	public Position as Vector3:
		get:
			return _position
	
	public X as int:
		get:
			return _position.x
	public Y as int:
		get:
			return _position.y
	public Z as int:
		get:
			return _position.z
	
	public XY as Vector2:
		get:
			return Vector2( _position.x, _position.y )
	public XZ as Vector2:
		get:
			return Vector2( _position.x, _position.z )
	public YZ as Vector2:
		get:
			return Vector2( _position.y, _position.z )
	#===========================================================
	def constructor( inX as int, inY as int, inZ as int ):
		_position = Vector3( inX, inY, inZ )
		if( Random.value < 0.03 ):
			_isVoid = true
	#===========================================================
