import UnityEngine
import System.Collections
import System.Collections.Generic
#===========================================================#===========================================================
class Globals( MonoBehaviour ):
	#===========================================================
	private static _instance as Globals
	
	public ModulePanelPrototype as GameObject
	#===========================================================
	public static ModulePanel as GameObject:
		get:
			return _instance.ModulePanelPrototype
	#===========================================================
	def Awake():
		_instance = self
	def Update ():
		pass
	#===========================================================