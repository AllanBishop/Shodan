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
package com.allanbishop.aicore.reinforcementlearning 
{
	import com.allanbishop.datastructures.IDoubleLinkedListNode;
	
	/**
	 * @private
	 * The QState class contains a list of actions. Each action stores a Q value.
	 */
	public class QState implements IDoubleLinkedListNode
	{
		private const VERY_SMALL_VALUE:Number = -Number.MAX_VALUE;
		private var _actions:Vector.<int>;
		private var _next:IDoubleLinkedListNode;
		private var _previous:IDoubleLinkedListNode;

		/**
		 *  @return Returns the next node
		 */
		public function get nextNode():IDoubleLinkedListNode
		{
			return _next;
		}

		/**
		 *  @private
		 */
		public function set nextNode(next:IDoubleLinkedListNode):void
		{
			_next = next;
		}

		/**
		 *  @return Returns the previous node
		 */
		public function get previousNode():IDoubleLinkedListNode
		{
			return _previous;
		}

		/**
		 *  @private
		 */
		public function set previousNode(previous:IDoubleLinkedListNode):void
		{
			_previous = previous;
		}

		/**
		 * Constructs a new QState instance.
		 * 
		 * Initializes all the actions to contain the default Q value of 0.
		 *
		 * @param maxActions The maximum number of actions for the state.
		 */
		public function QState(maxActions:int) 
		{
			_actions = new Vector.<int>();
			
			for (var i:int = 0;i < maxActions;i++) 
			{
				_actions[i] = 0.0;
			}
		}

		/**
		 * Sets the Q value for the action/state pair.
		 *
		 * @param actionId The id of the action.
		 *
		 * @return Returns the Q value
		 */
		public function getValue(actionId:int):Number
		{
			return _actions[actionId];
		}

		/**
		 * Sets the Q value for the action/state pair.
		 *
		 * @param actionCode The unique code for an action.
		 * @param The Q value that represents how good it is to be in that state.
		 */
		public function setValue(actionCode:int,Q:Number):void
		{
			_actions[actionCode] = Q;
		}
		
		/**
		 * Returns the code for the best action for the QState.
		 *
		 * @param actions A Vector of int that correspond to a unique action.
		 *
		 * @return The code of the best action.
		 */
		public function getBestAction(actions:Vector.<int>):int
		{
			var maxQ:Number = VERY_SMALL_VALUE;
			var bestActionCode:int = 0;

			for (var i:int = 0;i < actions.length;i++) 
			{
				var actionCode:int = actions[i];
				var q:Number = _actions[actionCode];
				
				if(q > maxQ)
				{
					maxQ = q;
					bestActionCode = actionCode;
				}
			}
			return bestActionCode;
		}

		/**
		 * Resets the Q value for each action to the default.
		 */
		public function reset():void
		{
			for (var i:int = 0;i < _actions.length;i++) 
			{
				_actions[i] = 0.0;
			}
		}
	}
}
