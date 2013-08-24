import UnityEditor

public class MaxAtlasSize(EditorWindow):
	private kSizeValues as (int) = (256, 512, 1024, 2048, 4096)
	private kSizeStrings as (string) = ('256', '512', '1024', '2048', '4096')
	private def OnGUI():
		LightmapEditorSettings.maxAtlasHeight = EditorGUILayout.IntPopup('Max Atlas Size', LightmapEditorSettings.maxAtlasHeight, kSizeStrings, kSizeValues)
		LightmapEditorSettings.maxAtlasWidth = LightmapEditorSettings.maxAtlasHeight

	[MenuItem('Utilities/Max Atlas Size')]
	private static def Init():
		window as EditorWindow = EditorWindow.GetWindow(typeof(MaxAtlasSize))
		window.Show()
