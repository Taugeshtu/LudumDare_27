import UnityEngine

#===========================================================#===========================================================
class CubesGrid( MonoBehaviour ):
	#===========================================================
	private static _instance as CubesGrid
	private _cubes as (VirtualCube, 3)
	private _pool as List
	private _mapPool as List
	
	private _shuffleDirections as (Vector3) = (
	 Vector3.forward, -Vector3.forward,
	 Vector3.right, -Vector3.right,
	 Vector3.up, -Vector3.up )
	private _lastShuffleDirection as int = 0	# Probably won't make any sense furthermore
	private _lastShufflesTime as single
	private _lastShuffleTime as single			# for multiple shuffles per turn
	
	public CubePrototype as GameObject			# will be cloned to pool
	public MapCubePrototype as GameObject			# will be cloned to mapPool
	public InverseCubePrototype as GameObject
	
	public CeilingObject as Transform
	public GridSize as int = 20
	public ShuffleInterval as single = 10
	public ShuffleTime as single = 1
	#===========================================================
	public static Instance as CubesGrid:
		get:
			return _instance
	#===========================================================
	def Awake():
		_instance = self
		GridSize = Mathf.Max( GridSize, 2 )
		_pool = List()
		_mapPool = List()
		for lines in range(3):
			for singleCube in range(GridSize -1):
				AddCubeToPool()
		AddCubeToPool()
		
		_cubes = matrix[of VirtualCube]( GridSize, GridSize, GridSize )
		for y in range(GridSize):
			for x in range(GridSize):
				for z in range(GridSize):
					_cubes[x, y, z] = VirtualCube( x, y, z )
					AddMapCubeToPool()
		
		CeilingObject.localPosition.y = GridSize - 0.5
		_cubes[0, 0, 0].IsVoid = true
		_cubes[1, 0, 0].RoomType = CubeType.Map
	
	def Update():
		if( Input.GetKeyDown( "up" ) ):
			Globals.PlayerPosition += Vector3.forward
		if( Input.GetKeyDown( "down" ) ):
			Globals.PlayerPosition += Vector3.back
		if( Input.GetKeyDown( "left" ) ):
			Globals.PlayerPosition += Vector3.left
		if( Input.GetKeyDown( "right" ) ):
			Globals.PlayerPosition += Vector3.right
		if( Input.GetKeyDown( KeyCode.PageUp ) ):
			Globals.PlayerPosition += Vector3.up
		if( Input.GetKeyDown( KeyCode.PageDown ) ):
			Globals.PlayerPosition += Vector3.down
		
		if( Time.time >= _lastShufflesTime + ShuffleInterval ):
			_lastShufflesTime = Time.time
			ShuffleCubes()							# HERE I could add multiple shuffles per turn
		
		poolCounter as int = 0
		mapPoolCounter as int = 0
		for cube as VirtualCube in _cubes:
			factor = Mathf.Clamp01( (Time.time - _lastShuffleTime) /ShuffleTime )
			cube.LinkedCube = null
			if( Time.time >= _lastShuffleTime + ShuffleTime ):
				cube.StopMoving()
			if( cube.IsVisible ):
				(_pool[poolCounter] cast GameObject).transform.localPosition = cube.Position
				cube.LinkedCube = _pool[poolCounter] cast GameObject
				if( cube.IsVoid or cube.IsMoving ):
					if( cube.IsVoid ):
						cube.LinkedCube.transform.position = Vector3.one *-100600
					unless( Globals.PlayerPosition == cube.Position ):
						AddCapToCube( cube )
					if( cube.IsMoving ):
						if( Time.time < _lastShuffleTime + ShuffleTime ):
							unless( cube.IsVoid ):
								cube.LinkedCube.transform.localPosition = cube.SmoothPosition( factor )
				poolCounter += 1
			
			unless( cube.Contents == null ):
				cube.Contents.transform.localPosition = cube.SmoothPosition( factor )
			
			if( cube.IsVoid ):
				(_mapPool[mapPoolCounter] cast GameObject).transform.position = Vector3.one *-100600
			else:
				(_mapPool[mapPoolCounter] cast GameObject).transform.localPosition = cube.SmoothPosition( factor )
			mapPoolCounter += 1
		
		/*for i in range(mapPoolCounter, _mapPool.Count):
			(_mapPool[i] cast GameObject).transform.position = Vector3.one *-100600*/
	#===========================================================
	public def GetCubeWrapped( inPosition as Vector3 ) as VirtualCube:
		inPosition.x = inPosition.x % GridSize
		inPosition.y = inPosition.y % GridSize
		inPosition.z = inPosition.z % GridSize
		return _cubes[inPosition.x, inPosition.y, inPosition.z]
	
	public def GetCube( inPosition as Vector3 ) as VirtualCube:
		if( inPosition.x < 0
		 or inPosition.y < 0
		 or inPosition.z < 0 ):
		 	return null
		if( inPosition.x >= GridSize
		 or inPosition.y >= GridSize
		 or inPosition.z >= GridSize ):
		 	return null
		return _cubes[inPosition.x, inPosition.y, inPosition.z]
	#===========================================================
	private def AddCubeToPool():
		cube as GameObject = GameObject.Instantiate( CubePrototype )
		cube.transform.position = Vector3.one *-100600
		cube.transform.parent = transform
		_pool.Add( cube )
	
	private def AddMapCubeToPool():
		cube as GameObject = GameObject.Instantiate( MapCubePrototype )
		cube.transform.position = Vector3.one *-100600
		cube.transform.parent = Globals.Instance.MapParent
		_mapPool.Add( cube )
	
	private def AddCapToCube( inCube as VirtualCube ):
		unless( inCube.LinkedCap == null ):
			return
		cap as GameObject = GameObject.Instantiate( InverseCubePrototype )
		cap.transform.parent = transform
		cap.transform.localPosition = inCube.Position
		cap.transform.forward = inCube.MovementDirection
		inCube.LinkedCap = cap
	
	private def SetCube( inPosition as Vector3, inCube as VirtualCube ):
		if( inPosition.x < 0
		 or inPosition.y < 0
		 or inPosition.z < 0 ):
		 	return
		if( inPosition.x >= GridSize
		 or inPosition.y >= GridSize
		 or inPosition.z >= GridSize ):
		 	return
		_cubes[inPosition.x, inPosition.y, inPosition.z] = inCube
	
	private def ShuffleCubes():
		shuffleDirection = _lastShuffleDirection
		#while shuffleDirection == _lastShuffleDirection:
		#	shuffleDirection = Random.Range(0, 5)
		
		_lastShuffleTime = Time.time
		for voidCube as VirtualCube in VirtualCube.Voids:
			cubeToMove = GetCubeWrapped( voidCube.Position + _shuffleDirections[shuffleDirection] )
			unless( cubeToMove == null ):
				SetCube( voidCube.Position, cubeToMove )
				SetCube( cubeToMove.Position, voidCube )
				VirtualCube.Swap( voidCube, cubeToMove )
		#_lastShuffleDirection = shuffleDirection
	#===========================================================
