package;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Color 
{
	public var r : Float;
	public var g : Float;
	public var b : Float;
	
	public function new(r : Float,g : Float,b : Float) 
	{
		this.r = r/255;
		this.g = g/255;
		this.b = b/255;
	}
}