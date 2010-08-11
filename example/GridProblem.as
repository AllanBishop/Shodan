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

 ad88888ba   88                                 88                           
d8"     "8b  88                                 88                           
Y8,          88                                 88                           
`Y8aaaaa,    88,dPPYba,    ,adPPYba,    ,adPPYb,88  ,adPPYYba,  8b,dPPYba,   
  `"""""8b,  88P'    "8a  a8"     "8a  a8"    `Y88  ""     `Y8  88P'   `"8a  
        `8b  88       88  8b       d8  8b       88  ,adPPPPP88  88       88  
Y8a     a8P  88       88  "8a,   ,a8"  "8a,   ,d88  88,    ,88  88       88  
 "Y88888P"   88       88   `"YbbdP"'    `"8bbdP"Y8  `"8bbdP"Y8  88       88  
*/
package
{
	import com.allanbishop.aicore.reinforcementlearning.IProblem;
	import Vector2D;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Allan Bishop
	 */
	public class GridProblem extends Sprite implements IProblem
	{
		private var _columns:int;
		private var _rows:int;
		private var _agentPosition:Vector2D;
		private var _start:Vector2D;
		private var _end:Vector2D;
		private var _gridTiles:Array;
		private var _agent:MovieClip;
		public var hazardStateReward:int;
		public var finishStateReward:int;
		public var safeStateReward:int;

		public function GridProblem() 
		{
			_gridTiles = new Array();
			createGrid();
			var AgentImageClass:Class = getDefinitionByName("AgentImage") as Class;
			_agent = new AgentImageClass() as MovieClip;
			addChild(_agent);
			_agentPosition = new Vector2D();
			_agentPosition.x = _start.x;
			_agentPosition.y = _start.y;
		}

		public function render():void
		{
			_agent.x = (_agentPosition.x * 75)+20;
			_agent.y = (_agentPosition.y * 75)+20;
		}

		private function createGrid():void 
		{
			var TileClass:Class = getDefinitionByName("Tile") as Class;
			_rows = 5;
			_columns = 5;
			
			for (var y:int = 0;y < _rows;y++) 
			{
				for (var x:int = 0;x < _columns;x++) 
				{
					var tileImage:MovieClip = new TileClass() as MovieClip;
					addChild(tileImage);
					_gridTiles.push(new GridTile(tileImage, new Vector2D(x, y),new Vector2D(20,20)));
				}
			}
			setStart();
			setFinish();
		}

		private function setStart():void 
		{
			_start = new Vector2D(0, 0);
			GridTile(_gridTiles[0]).isStart = true;
		}

		private function setFinish():void 
		{
			_end = new Vector2D(_columns - 1, _rows - 1);
			GridTile(_gridTiles[_gridTiles.length - 1]).isFinish = true;
		}

		public function getIndex(x:int,y:int):int
		{
			return _columns * y + x;
		}

		public function getCurrentProblemState():Number
		{
			return _agentPosition.x*100+_agentPosition.y;
		}

		public function getTotalStates():int
		{
			return _columns*_rows;
		}

		public function getMaxActions():int
		{
			return 4;
		}

		public function getValidActions():Vector.<int>
		{
			var actions:Vector.<int> = new Vector.<int>();
			const UP:int = 8;//1000
			const DOWN:int = 4;//0100
			const LEFT:int = 2;//0010
			const RIGHT:int = 1; //0001
			var positions:int;

			
			if (_agentPosition.x < _columns - 1)
			{
				positions |= RIGHT;//0100
			}
			if (_agentPosition.x > 0)
			{
				positions |= LEFT;//1000
			}
	
			if (_agentPosition.y < _rows - 1)
			{
				positions |= DOWN;//0001
			}
	
			if (_agentPosition.y > 0)
			{
				positions |= UP;//0010
			}
		
			if ((UP & positions) == UP)
			{
				actions.push(3);
			}
			if ((DOWN & positions) == DOWN)
			{
				actions.push(2);
			}
			if ((LEFT & positions) == LEFT)
			{
				actions.push(1);
			}
			if ((RIGHT & positions) == RIGHT)
			{
				actions.push(0);
			}
		
			return actions;
		}
		
		public function performAction(actionCode:int):void
		{
			switch(actionCode)
			{
				case 0:
					_agentPosition.x++;
					break;
				case 1:
					_agentPosition.x--;
					break;
				case 2:
					_agentPosition.y++;
					break;
				case 3:
					_agentPosition.y--;
					break;
			}
		}

		public function reset():void
		{
			_agentPosition.x = _start.x;
			_agentPosition.y = _start.x;
		}
		
		private function encounteredHazard():Boolean
		{
			return GridTile(_gridTiles[getIndex(_agentPosition.x, _agentPosition.y)]).isHazard;
		}
		
		public function getReward():int
		{
			var reward:int = 0;
			if(isFinalState())
			{
				reward += finishStateReward;
			}
			else
			{
				if(encounteredHazard())
				{
					reward += hazardStateReward;
				}
				else
				{
					reward += safeStateReward; 
				}
			}
						
			if(isFinalState()||encounteredHazard())
			{
				reset();
			}
			return reward;
		}

		private function isFinalState():Boolean
		{
			return _agentPosition.x == _end.x && _agentPosition.y == _end.y;
		}
	}
}
