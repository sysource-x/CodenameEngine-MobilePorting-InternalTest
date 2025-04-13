/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Internal-only version of StorageUtil for Android/iOS ports using only embedded assets (.apk) by sysource-xyz.
 */
package mobile.funkin.backend.utils;

import openfl.utils.Assets;
import haxe.Json;
import sys.io.File;
 
using StringTools;
 
class StorageUtil
{
	#if sys
	public static function getStorageDirectory():String
	{
	// return haxe.io.Path.addTrailingSlash(sys.FileSystem.applicationStorageDirectory());
		return #if android haxe.io.Path.addTrailingSlash(AndroidContext.getFilesDir()) 
		       #elseif ios lime.system.System.documentsDirectory 
		       #else Sys.getCwd() #end;
	}

    public static function exists(path:String):Bool
    {
        #if mobile
        return Assets.exists(path);
        #else
        return sys.FileSystem.exists(path);
        #end
    }
 
    public static function loadText(path:String):String
    {
        #if mobile
        return Assets.getText(path);
        #else
        return sys.io.File.getContent(path);
        #end
    }
 
    public static function loadJson<T>(path:String):T
    {
        var raw = loadText(path);
        return Json.parse(raw);
    }
 
    public static function loadBytes(path:String):haxe.io.Bytes
    {
        #if mobile
        return Assets.getBytes(path);
        #else
        return sys.io.File.getBytes(path);
        #end
    }
	#end
}