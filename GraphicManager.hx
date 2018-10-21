package;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.display.Bitmap;
import flash.geom.Point;
import openfl.Lib;
import openfl.display.SparrowTileset;

class GraphicManager
{
	
	public static var NAME : String = "SCREEN";
	
	private static var instance : GraphicManager;
	
	private static var width : Int;
	
	private static var height : Int;
	
	private static var fixedWidth : Int;
	
	private static var fixedHeight : Int;
	
	private static var bitmapsData : Map<String,BitmapData>;
	
	private static var spritesheetsData : Map<String,Map<String,flash.geom.Rectangle>>;
	
	private static var backgroundsPath : String;
	
	private static var spritesPath : String;
	
	
	public static function InitInstance(fixedWidth : Int,fixedHeight : Int,backgroundsPath : String,spritesPath : String): GraphicManager
	{
		if (instance == null)
			instance = new GraphicManager(fixedWidth,fixedHeight,backgroundsPath,spritesPath);
		
		bitmapsData = new Map<String,BitmapData>();
		spritesheetsData = new Map<String,Map<String,flash.geom.Rectangle>>();
		
		return instance;
	}
	
	/*
	 * Creates and returns a screen manager instance if it's not created yet.
	 * Returns the current instance of this class if it already exists.
	 */
	public static function GetInstance(): GraphicManager
	{
		if ( instance == null )
			throw "The Screen is not initialized. Use function 'InitInstance'";
		
		return instance;
	}
	
	/*
	 * Constructor
	 */
	private function new(fixedW : Int,fixedH : Int,backPath : String,sprtPath : String) 
	{
		fixedWidth = fixedW;
		fixedHeight = fixedH;
		
		//Getting device resolution
		width = Lib.current.stage.stageWidth;
		height = Lib.current.stage.stageHeight;
		backgroundsPath = backPath;
		spritesPath = sprtPath;
	}
	
	public static function Resize() : Void
	{
		//Getting device resolution
		width = Lib.current.stage.stageWidth;
		height = Lib.current.stage.stageHeight;
	}
	
	public static function ScreenSizeChanged() : Bool
	{
		return (width != Lib.current.stage.stageWidth) || (height != Lib.current.stage.stageHeight);
	}
	
	
	public static function GetWidth() : Int
	{
		return width;
	}
	
	public static function GetHeight() : Int
	{
		return height;
	}
	
	public static function GetFixedWidth() : Int
	{
		return fixedWidth;
	}
	
	public static function GetFixedHeight() : Int
	{
		return fixedHeight;
	}
	
	public static function GetBackgroundsPath() : String
	{
		return backgroundsPath;
	}
	
	public static function GetSpritesPath() : String
	{
		return spritesPath;
	}
	
	public static function LoadBitmap(path : String) : Bitmap
	{
		var bitmap : Bitmap;
		var bitmapData : BitmapData;
	
		bitmapData = LoadBitmapData(path);
		bitmap = new Bitmap(bitmapData);
	
		return bitmap;
	}
	
	public static function LoadBitmapData(path : String) : BitmapData
	{
		var bitmapData : BitmapData;

		if (bitmapsData == null)
			throw "Bitmaps are not initialized. Use function 'InitInstance'";

		if(bitmapsData.exists(path))
			bitmapData = bitmapsData.get(path);
		else
		{
			bitmapData = Assets.getBitmapData(path,false);
			bitmapsData.set(path,bitmapData);
		}

		return bitmapData;
	}
	
	public static function CleanBitmaps() : Void
	{
		var bitmapData : BitmapData;
		
		if (bitmapsData == null)
			throw "Bitmaps are not initialized. Use function 'InitInstance'";
		else
		{
			for(k in bitmapsData.keys())
			{
				if(bitmapsData.get(k) != null)
				{
					bitmapsData.get(k).dispose();
					bitmapsData.set(k,null);
				}
				bitmapsData.remove(k);
			}
		}
	}
	
	public static function LoadSpriteSheetData(path : String) : Map<String,flash.geom.Rectangle>
	{
		var data : Map<String,flash.geom.Rectangle>;
		
		if (spritesheetsData.exists(path))
			data = spritesheetsData.get(path);
		else
		{
			data = ParseObjectsData(path);
			spritesheetsData.set(path, data);
		}
		
		return data;
	}
	
	public static function LoadSpritesheet(name : String, extension : String, internalPath : String = "") : BitmapData
	{
		var bitmapData : BitmapData;
	
		//It's always png because it's a spritesheet
		bitmapData = LoadBitmapData(spritesPath + internalPath + name + "." + extension);
	
		return bitmapData;
	}
	
	public static function LoadSpritesheetData(name : String, extension : String, internalPath : String = "") : String
	{
		var data : String;
	
		//It's always xml because it's the spritesheet data
		data = Assets.getText(spritesPath + internalPath + name + "." + extension);
		return data;
	}
	
	public static function LoadTileLayer(name : String,order : Int = 0,internalPath : String = "") : Layer
	{
		var data : String;
		var imagesSpriteheet : BitmapData;
		var imagesTileLayer : SparrowTileset;
		var tilelayer : Layer;
	
		imagesSpriteheet = LoadSpritesheet(name,"png",internalPath);
		data = LoadSpritesheetData(name, "xml", internalPath);
		imagesTileLayer = new SparrowTileset(imagesSpriteheet, data);
			
		tilelayer = new Layer(imagesTileLayer,imagesTileLayer.bitmapData.width,imagesTileLayer.bitmapData.height,order);
		
		return tilelayer;
	}
	
	public static function ParseObjectsData(path : String) : Map<String,flash.geom.Rectangle>
	{
		var str,name : String;
		var xml : Xml;
		var x, y, w, h : Int;
		
		var data : Map<String,flash.geom.Rectangle> = new Map<String,flash.geom.Rectangle>();
			
		try
		{
			str = Assets.getText(path);
			xml = Xml.parse(str).firstElement();
			for (i in xml.iterator())
			{
				if (i.nodeType == Xml.Element)
				{
					name = i.get("name");
					x = Std.parseInt(i.get("x"));
					y = Std.parseInt(i.get("y"));
					w = Std.parseInt(i.get("width"));
					h = Std.parseInt(i.get("height"));
					
					data.set(name, new flash.geom.Rectangle(x, y, w, h));
				}
			}
		}
		catch (e : String)
		{
			trace(e);
		}
		
		return data;
	}
	
	/*
	 * Fixed point to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixPoint2Screen(value : Point) : Point
	{
		var scale : Point;
		
		scale = new Point(width/fixedWidth, height/fixedHeight );
		
		return new Point(value.x * scale.x,value.y * scale.y);
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixFloat2ScreenX(value : Float) : Float
	{
		var scale : Float;
		
		scale = width/fixedWidth;
		
		return value * scale;
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixFloat2ScreenY(value : Float) : Float
	{
		var scale : Float;
		
		scale = height/fixedHeight;
		
		return value * scale;
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixInt2ScreenX(value : Int) : Int
	{
		var scale : Float;
		
		scale = width/fixedWidth;
		
		return Math.round(value * scale);
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixInt2ScreenY(value : Int) : Int
	{
		var scale : Float;
		
		scale = height/fixedHeight;
		
		return Math.round(value * scale);
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixIntScale2Screen(value : Int) : Int
	{
		var scaleX,scaleY, scale : Float;
		
		scaleX = width/fixedWidth;
		scaleY = height/fixedHeight;
		//scale = Math.max(scaleX, scaleY);
		scale = Math.min(scaleX, scaleY);
		
		
		return Math.round(value * scale);
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function FixFloatScale2Screen(value : Float) : Float
	{
		var scaleX,scaleY, scale : Float;
		
		scaleX = width/fixedWidth;
		scaleY = height/fixedHeight;
		//scale = Math.max(scaleX, scaleY);
		scale = Math.min(scaleX, scaleY);
		
		
		return value * scale;
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function GetFixScale() : Float
	{
		var scaleX,scaleY, scale : Float;
		
		scaleX = width/fixedWidth;
		scaleY = height/fixedHeight;
		//scale = Math.max(scaleX, scaleY);
		scale = Math.min(scaleX, scaleY);
		
		
		return scale;
	}
	
	public static function GetWidthScale() : Float
	{
		return  1 + (width - fixedWidth) / fixedWidth;
	}
	
	public static function GetHeightScale() : Float
	{
		return  1 + (height - fixedHeight) / fixedHeight;
	}
	
	/*
	 * Fixed float to Screen: Generate relative values, using fixed screen width and height.
	 * */
	public static function GetMaxScale() : Float
	{
		var scaleX,scaleY, scale : Float;
		
		scaleX = width/fixedWidth;
		scaleY = height/fixedHeight;
		scale = Math.max(scaleX, scaleY);
		//scale = Math.min(scaleX, scaleY);
		
		
		return scale;
	}
	
	public static function GetXScale() : Float
	{
		return width/fixedWidth;
	}
	
	public static function GetYScale() : Float
	{
		return height/fixedHeight;
	}
}