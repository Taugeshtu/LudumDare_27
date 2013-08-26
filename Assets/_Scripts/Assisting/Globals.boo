import UnityEngine
import System.Collections
import System.Collections.Generic

#===========================================================#===========================================================
class Globals( MonoBehaviour ):
	#===========================================================
	public Platforms as GameObject
	public DeathWall as GameObject
	public Lasers as GameObject
	
	public MapParent as Transform
	public ContentsParent as Transform
	
	public static Instance as Globals
	public static PlayerPosition as Vector3 = Vector3.zero
	#===========================================================
	public static PlayerX as int:
		get:
			return PlayerPosition.x
	public static PlayerY as int:
		get:
			return PlayerPosition.y
	public static PlayerZ as int:
		get:
			return PlayerPosition.z
	
	public static PlayerXY as Vector2:
		get:
			return Vector2( PlayerPosition.x, PlayerPosition.y )
	public static PlayerXZ as Vector2:
		get:
			return Vector2( PlayerPosition.x, PlayerPosition.z )
	public static PlayerYZ as Vector2:
		get:
			return Vector2( PlayerPosition.y, PlayerPosition.z )
	#===========================================================
	def Awake():
		Instance = self
	#===========================================================