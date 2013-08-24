import UnityEngine

#===========================================================#===========================================================
class CubesGrid( MonoBehaviour ):
	#===========================================================
	private _cubes as (VirtualCube, 3)
	private _pool as List
	
	private _shuffleDirections as (Vector3) = (
	 Vector3.forward, -Vector3.forward,
	 Vector3.right, -Vector3.right,
	 Vector3.up, -Vector3.up )
	private _lastShuffleDirection as int = 0	# Probably won't make any sense furthermore
	private _lastShufflesTime as single
	private _lastShuffleTime as single			# for multiple shuffles per turn
	
	public CubePrototype as GameObject			# will be cloned to pool
	public InverseCubePrototype as GameObject
	public GridSize as int = 20
	public ShuffleInterval as single = 10
	public ShuffleTime as single = 1
	#===========================================================
	def Awake():
		GridSize = Mathf.Max( GridSize, 2 )
		_pool = List()
		for lines in range(3):
			for singleCube in range(GridSize -1):
				AddCubeToPool()
		AddCubeToPool()
		
		_cubes = matrix[of VirtualCube]( GridSize, GridSize, GridSize )
		for y in range(GridSize):
			for x in range(GridSize):
				for z in range(GridSize):
					_cubes[x, y, z] = VirtualCube( x, y, z )
		_cubes[0, 0, 0].IsVoid = true
	
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
		for cube as VirtualCube in _cubes:
			cube.LinkedCube = null
			if( cube.IsVisible ):
				(_pool[poolCounter] cast GameObject).transform.localPosition = cube.Position
				cube.LinkedCube = _pool[poolCounter] cast GameObject
				if( cube.IsVoid or cube.IsMoving ):
					unless( Globals.PlayerPosition == cube.Position ):
						AddCapToCube( cube )
					if( cube.IsMoving ):
						if( Time.time < _lastShuffleTime + ShuffleTime ):
							unless( cube.IsVoid ):
								factor = (Time.time - _lastShuffleTime) /ShuffleTime
								cube.LinkedCube.transform.localPosition = cube.SmoothPosition( factor )
						else:
							cube.StopMoving()
				poolCounter += 1
	#===========================================================
	private def AddCubeToPool():
		cube as GameObject = GameObject.Instantiate( CubePrototype )
		cube.transform.position = Vector3.one * -100600
		cube.transform.parent = transform
		_pool.Add( cube )
	
	private def AddCapToCube( inCube as VirtualCube ):
		unless( inCube.LinkedCap == null ):
			return
		Debug.Log( "Created cap  for #"+inCube.Id+", void: "+inCube.IsVoid+", moving: "+inCube.IsMoving )
		cap as GameObject = GameObject.Instantiate( InverseCubePrototype )
		cap.transform.parent = transform
		cap.transform.localPosition = inCube.Position
		cap.transform.forward = inCube.MovementDirection
		inCube.LinkedCap = cap
	
	private def GetCubeWrapped( inPosition as Vector3 ) as VirtualCube:
		inPosition.x = inPosition.x % GridSize
		inPosition.y = inPosition.y % GridSize
		inPosition.z = inPosition.z % GridSize
		return _cubes[inPosition.x, inPosition.y, inPosition.z]
	
	private def GetCube( inPosition as Vector3 ) as VirtualCube:
		if( inPosition.x < 0
		 or inPosition.y < 0
		 or inPosition.z < 0 ):
		 	return null
		if( inPosition.x >= GridSize
		 or inPosition.y >= GridSize
		 or inPosition.z >= GridSize ):
		 	return null
		return _cubes[inPosition.x, inPosition.y, inPosition.z]
	
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
