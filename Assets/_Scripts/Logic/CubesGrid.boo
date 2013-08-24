import UnityEngine

#===========================================================#===========================================================
class CubesGrid( MonoBehaviour ):
	#===========================================================
	private _cubes as (VirtualCube, 3)
	private _pool as List
	private _lastShiffleTime as single
	
	public CubePrototype as GameObject	# will be cloned to pool
	public GridSize as int = 20
	public ShuffleInterval as single = 10
	#===========================================================
	def Awake():
		GridSize = Mathf.Max( GridSize, 1 )
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
	
	def Update():
		if( Time.time >= _lastShiffleTime + ShuffleInterval ):
			_lastShiffleTime = Time.time
			ShuffleCubes()
		
		poolCounter as int = 0
		for cube as VirtualCube in _cubes:
			if( cube.IsVisible ):
				#Debug.Log( "Visible cube, pool counter: "+poolCounter+", pool size: "+_pool.Count )
				(_pool[poolCounter] cast GameObject).transform.localPosition = cube.Position
				poolCounter += 1
	#===========================================================
	private def AddCubeToPool():
		cube as GameObject = GameObject.Instantiate( CubePrototype )
		cube.transform.position = Vector3.one * -100600
		cube.transform.parent = transform
		_pool.Add( cube )
	
	private def ShuffleCubes():
		pass
	#===========================================================
