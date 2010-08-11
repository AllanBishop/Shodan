/**
* Copyright (c) 2010 Allan Bishop http://www.allanbishop.com
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package
{
	import Vector2D;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Allan Bishop
	 */
	public class GridTile 
	{

		private var _location:Vector2D;
		private var _image:MovieClip;
		private var _isHazard:Boolean = false;
		private var _isStart:Boolean = false;
		private var _isFinish:Boolean = false;

		public function GridTile(image:MovieClip, location:Vector2D,offset:Vector2D) 
		{
			_location = location;
			_image = image;
			_image.x = (_image.width * location.x) + offset.x;
			_image.y = (_image.height * location.y) + offset.y;
			_image.addEventListener(MouseEvent.CLICK, onMouseClick);
			_image.mouseHitArea.buttonMode = true;
		}

		/**
		 * Get function for _isStart.
		 * @return _isStart : Boolean
		 */
		public function get isStart():Boolean 
		{
			return _isStart;
		}

		/**
		 * Set function for _isStart.
		 * @param value : Boolean
		 */
		public function set isStart(value:Boolean):void 
		{
			_isStart = value;
			if(_isStart)
			{
				_image.gotoAndStop("StartFrame");
				_image.mouseHitArea.buttonMode = false;
			}
		}

		/**
		 * Get function for _isFinish.
		 * @return _isFinish : Boolean
		 */
		public function get isFinish():Boolean 
		{
			return _isFinish;
		}

		/**
		 * Set function for _isFinish.
		 * @param value : Boolean
		 */
		public function set isFinish(value:Boolean):void 
		{
			_isFinish = value;
			if(_isFinish)
			{
				_image.gotoAndStop("FinishFrame");
				_image.mouseHitArea.buttonMode = false;
			}
		}

		
		private function onMouseClick(e:MouseEvent):void 
		{
			if(_isFinish || _isStart)
				return;
				
			_isHazard = !_isHazard;
			if(_isHazard)
			{
				_image.gotoAndStop("HazardFrame");
			}
			else
			{
				_image.gotoAndStop("SafeFrame");
			}

		}

		public function get isHazard():Boolean
		{
			return _isHazard;
		}
	}
}
