package;

/**
	This class contains values r,b,g for a specified color.
**/
class Color 
{
	public var r : Float;
	public var g : Float;
	public var b : Float;
	
	/**
		Creates a color based on values of `r`, `g`, `b`.

		`r`, `g`, `b` should be a values between 0 and 256.
	**/
	public function new(r : Float,g : Float,b : Float) 
	{
		this.r = r/255;
		this.g = g/255;
		this.b = b / 255;
	}
}