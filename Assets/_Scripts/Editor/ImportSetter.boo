import UnityEditor

public class ImportSetter(AssetPostprocessor):
	public def OnPreprocessModel():
		modelImporter = (assetImporter cast ModelImporter)
		modelImporter.globalScale = 1
		modelImporter.importMaterials = false
		modelImporter.generateAnimations = ModelImporterGenerateAnimations.None
		modelImporter.animationType = ModelImporterAnimationType.None