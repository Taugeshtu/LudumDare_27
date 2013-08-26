import UnityEngine

#===========================================================#===========================================================
class Utils:
	#===========================================================
	private static _instance as Utils
	
	static Instance as Utils:
		get:
			if( _instance == null ):
				_instance = Utils()
			return _instance
	#===========================================================
	def constructor():
		pass
	#===========================================================
	static def DrawCross( inPosition as Vector3, inColor as Color, inSize as single, inDuration as single ):
		Debug.DrawRay( inPosition - Vector3.up *inSize, Vector3.up *inSize *2, inColor, inDuration )
		Debug.DrawRay( inPosition - Vector3.right *inSize, Vector3.right *inSize *2, inColor, inDuration )
		Debug.DrawRay( inPosition - Vector3.forward *inSize, Vector3.forward *inSize *2, inColor, inDuration )
	
	static def NextCollectionElement( inCollection as IEnumerable ) as duck:
		if( inCollection == null ):
			return null
		if( (inCollection cast List).Count > 0 ):
			return (inCollection cast List)[0]
		return null
	
	static def NextCollectionElement( inCollection as IEnumerable, inElement as System.Object ) as duck:
		if( inElement == null ):
			return null
		if( inCollection == null ):
			return null
		gotcha = false
		for element in inCollection:
			if( gotcha ):
				return element
			if( element == inElement ):
				gotcha = true
		if( gotcha ):
			return (inCollection cast List)[0]
		return null
	#===========================================================
	static def GetComponentInParents[of T]( inStartObject as GameObject ) as duck:
		return GetComponentInParents[of T]( inStartObject.transform )
	
	static def GetComponentInParents[of T]( inStartComponent as Component ) as duck:
		workTransform = inStartComponent.transform
		
		selfSearch as T = workTransform.GetComponent( T ) cast T
		unless( selfSearch == null ):
			return selfSearch
		
		if( workTransform.parent == null ):
			return null
		
		result as T = workTransform.parent.GetComponent( T ) cast T
		if( result == null ):
			return GetComponentInParents[of T]( workTransform.parent )
		return result
	
	
	
	static def GetComponentFromParents[of T]( inStartObject as GameObject ) as duck:
		return GetComponentFromParents[of T]( inStartObject.transform )
	
	static def GetComponentFromParents[of T]( inStartComponent as Component ) as duck:
		workTransform = inStartComponent.transform
		if( workTransform.parent == null ):
			return null
		
		result as T = workTransform.parent.GetComponent( T ) cast T
		if( result == null ):
			return GetComponentFromParents[of T]( workTransform.parent )
		return result
	#===========================================================
	static def RandomOnCube() as Vector3:
		clampBounds as Bounds = Bounds( Vector3.zero, Vector3.one )
		point as Vector3 = Random.onUnitSphere *10
		clampBounds.Encapsulate( point )
		clampBounds.Encapsulate( -point )
		point /= Mathf.Max( clampBounds.size.x, clampBounds.size.y, clampBounds.size.z )
		return point *2
	static def RandomOnPositiveCube() as Vector3:
		point = RandomOnCube()
		point = VectorAbs( point )
		return point
	
	static def RandomInCube() as Vector3:
		point as Vector3
		point.x = Random.value*2-1
		point.y = Random.value*2-1
		point.z = Random.value*2-1
		return point
		
	static def RandomInPositiveCube() as Vector3:
		point = RandomInCube()
		point = VectorAbs( point )
		return point
	#===========================================================
	static def VectorAbs( inVector as Vector2 ) as Vector2:
		inVector.x = Mathf.Abs( inVector.x )
		inVector.y = Mathf.Abs( inVector.y )
		return inVector
	
	static def VectorAbs( inVector as Vector3 ) as Vector3:
		inVector.x = Mathf.Abs( inVector.x )
		inVector.y = Mathf.Abs( inVector.y )
		inVector.z = Mathf.Abs( inVector.z )
		return inVector

	static def VectorAbs( inVector as Vector4 ) as Vector4:
		inVector.x = Mathf.Abs( inVector.x )
		inVector.y = Mathf.Abs( inVector.y )
		inVector.z = Mathf.Abs( inVector.z )
		inVector.w = Mathf.Abs( inVector.w )
		return inVector
	#===========================================================
	static def VectorRound( inVector as Vector2 ) as Vector2:
		inVector.x = Mathf.Round( inVector.x )
		inVector.y = Mathf.Round( inVector.y )
		return inVector
	
	static def VectorRound( inVector as Vector3 ) as Vector3:
		inVector.x = Mathf.Round( inVector.x )
		inVector.y = Mathf.Round( inVector.y )
		inVector.z = Mathf.Round( inVector.z )
		return inVector

	static def VectorRound( inVector as Vector4 ) as Vector4:
		inVector.x = Mathf.Round( inVector.x )
		inVector.y = Mathf.Round( inVector.y )
		inVector.z = Mathf.Round( inVector.z )
		inVector.w = Mathf.Round( inVector.w )
		return inVector
	#===========================================================
