---@class CS.Framework.GameUtility : CS.System.Object
CS.Framework.GameUtility = {}

---@field public CS.Framework.GameUtility.AssetsFolderName : CS.System.String
CS.Framework.GameUtility.AssetsFolderName = nil

---@return CS.Framework.GameUtility
function CS.Framework.GameUtility()
end

---@param path : CS.System.String
---@return CS.System.String
function CS.Framework.GameUtility.FormatToUnityPath(path)
end

---@param path : CS.System.String
---@return CS.System.String
function CS.Framework.GameUtility.FormatToSysFilePath(path)
end

---@return CS.System.String
function CS.Framework.GameUtility.GetPlatform()
end

---@return CS.System.Boolean
function CS.Framework.GameUtility.IsMobile()
end

---@param full_path : CS.System.String
---@return CS.System.String
function CS.Framework.GameUtility.FullPathToAssetPath(full_path)
end

---@param path : CS.System.String
---@return CS.System.String
function CS.Framework.GameUtility.GetFileExtension(path)
end

---@param path : CS.System.String
---@param extensions : CS.System.String[]
---@param exclude : CS.System.Boolean
---@return CS.System.String[]
function CS.Framework.GameUtility.GetSpecifyFilesInFolder(path, extensions, exclude)
end

---@param path : CS.System.String
---@param pattern : CS.System.String
---@return CS.System.String[]
function CS.Framework.GameUtility.GetSpecifyFilesInFolder(path, pattern)
end

---@param path : CS.System.String
---@return CS.System.String[]
function CS.Framework.GameUtility.GetAllFilesInFolder(path)
end

---@param path : CS.System.String
---@return CS.System.String[]
function CS.Framework.GameUtility.GetAllDirsInFolder(path)
end

---@param filePath : CS.System.String
function CS.Framework.GameUtility.CheckFileAndCreateDirWhenNeeded(filePath)
end

---@param folderPath : CS.System.String
function CS.Framework.GameUtility.CheckDirAndCreateWhenNeeded(folderPath)
end

---@param outFile : CS.System.String
---@param outBytes : CS.System.Byte[]
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeWriteAllBytes(outFile, outBytes)
end

---@param outFile : CS.System.String
---@param outLines : CS.System.String[]
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeWriteAllLines(outFile, outLines)
end

---@param outFile : CS.System.String
---@param text : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeWriteAllText(outFile, text)
end

---@param inFile : CS.System.String
---@return CS.System.Byte[]
function CS.Framework.GameUtility.SafeReadAllBytes(inFile)
end

---@param inFile : CS.System.String
---@return CS.System.String[]
function CS.Framework.GameUtility.SafeReadAllLines(inFile)
end

---@param inFile : CS.System.String
---@return CS.System.String
function CS.Framework.GameUtility.SafeReadAllText(inFile)
end

---@param dirPath : CS.System.String
function CS.Framework.GameUtility.DeleteDirectory(dirPath)
end

---@param folderPath : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeClearDir(folderPath)
end

---@param folderPath : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeDeleteDir(folderPath)
end

---@param filePath : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeDeleteFile(filePath)
end

---@param sourceFileName : CS.System.String
---@param destFileName : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeRenameFile(sourceFileName, destFileName)
end

---@param fromFile : CS.System.String
---@param toFile : CS.System.String
---@return CS.System.Boolean
function CS.Framework.GameUtility.SafeCopyFile(fromFile, toFile)
end