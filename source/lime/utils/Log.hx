package lime.utils;

import openfl.Lib;
import haxe.PosInfos;
import lime.app.Application;
import lime.system.System;

#if android
import android.widget.Toast;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Log
{
	public static var level:LogLevel;
	public static var throwErrors:Bool = true;

	public static function debug(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.DEBUG)
		{
			#if js
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").debug("[" + info.className + "] " + Std.string(message));
			#else
			println("[" + info.className + "] " + Std.string(message));
			#end
		}
	}

	public static function error(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.ERROR)
		{
			var msg:String = "[" + info.className + "] ERROR: " + Std.string(message);

			if (throwErrors)
			{
				#if sys
				try
				{
					#if mobile
					// Versão mobile interna: sem salvar log em arquivo
					trace("Log interno no Android/iOS (não salvo em arquivo):\n" + msg);
					#else
					final logDir = "logs/";
					if (!FileSystem.exists(SUtil.getStorageDirectory(logDir))) FileSystem.createDirectory(SUtil.getStorageDirectory(logDir));

					final logFile = logDir
						+ Lib.application.meta.get('file')
						+ '-'
						+ Date.now().toString().replace(' ', '-').replace(':', "'")
						+ '.txt';

					File.saveContent(logFile, msg + "\n");
					#end
				}
				catch (e:Dynamic)
				{
					#if android
					Toast.makeText("Erro ao salvar log:\n" + e, Toast.LENGTH_LONG);
					#else
					println("Erro ao salvar log:\n" + e);
					#end
				}
				#end

				println(msg);
				Application.current.window.alert(msg, "Erro!");
				System.exit(1);
			}
			else
			{
				#if js
				untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").error(msg);
				#else
				println(msg);
				#end
			}
		}
	}

	public static function info(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.INFO)
		{
			#if js
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").info("[" + info.className + "] " + Std.string(message));
			#else
			println("[" + info.className + "] " + Std.string(message));
			#end
		}
	}

	public static function verbose(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.VERBOSE)
		{
			println("[" + info.className + "] " + Std.string(message));
		}
	}

	public static function warn(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.WARN)
		{
			#if js
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").warn("[" + info.className + "] WARNING: " + Std.string(message));
			#else
			println("[" + info.className + "] WARNING: " + Std.string(message));
			#end
		}
	}

	public static inline function print(message:Dynamic):Void
	{
		#if sys
		Sys.print(Std.string(message));
		#else
		trace(Std.string(message));
		#end
	}

	public static inline function println(message:Dynamic):Void
	{
		#if sys
		Sys.println(Std.string(message));
		#else
		trace(Std.string(message));
		#end
	}

	private static function __init__():Void
	{
		#if no_traces
		level = NONE;
		#elseif verbose
		level = VERBOSE;
		#else
		#if sys
		var args = Sys.args();
		if (args.indexOf("-v") > -1 || args.indexOf("-verbose") > -1)
		{
			level = VERBOSE;
		}
		else
		#end
		{
			#if debug
			level = DEBUG;
			#else
			level = INFO;
			#end
		}
		#end

		#if js
		if (untyped #if haxe4 js.Syntax.code #else __js__ #end ("typeof console") == "undefined")
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("console = {}");
		}
		if (untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").log == null)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").log = function() {};
		}
		#end
	}
}