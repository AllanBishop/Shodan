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
	import com.allanbishop.datastructures.IDoubleLinkedList;
	
	/**
	 * @private
	 * The QStatePool class is responsible for the creation, allocation and recycling of the QState class.
	 * By creating classes at startup, performance should be improved during training.
	 */
	public class QStatePool implements IDoubleLinkedList
	{
		private var _length:int = 0;
		private var _currentNode:IDoubleLinkedListNode;
		private var _firstNode:IDoubleLinkedListNode;
		private var _lastNode:IDoubleLinkedListNode;
		private var _maxActions:int;
		private var _growable:Boolean;

		public function get firstNode():IDoubleLinkedListNode
		{
			return _firstNode;
		}

		public function get lastNode():IDoubleLinkedListNode
		{
			return _lastNode;
		}

		public function get currentNode():IDoubleLinkedListNode
		{
			return _currentNode;
		}

		public function get length():int
		{
			return _length;
		}

		public function set firstNode(node:IDoubleLinkedListNode):void
		{
			_firstNode = firstNode;
		}

		public function set lastNode(node:IDoubleLinkedListNode):void
		{
			_lastNode = lastNode;
		}

		public function set currentNode(node:IDoubleLinkedListNode):void
		{
			_currentNode = currentNode;
		}


		/**
		 * Constructs a new QStatePool instance.
		 * 
		 * @param size The size of the pool.
		 * @param maxActions The maximum actions per QState.
		 * @param growable Determines if the pool can create new resources if empty.
		 */
		public function QStatePool(size:int,maxActions:int,growable:Boolean = false) 
		{
			_maxActions = maxActions;
			_growable = growable;
			init(size);
		}

		/**
		 * Initializes the pool.
		 *
		 * @param size The size of the pool
		 */
		private function init(size:int):void
		{
			for (var i:int = 0;i < size;i++) 
			{
				add(new QState(_maxActions));
			}
		}

		/**
		 * Allocates a QState resource for use.
		 *
		 * @return Returns an unused QState.
		 */
		public function borrow():QState
		{
		
			var nodeToBorrow:IDoubleLinkedListNode = _lastNode;
			if(nodeToBorrow == null)
			{
				if(_growable)
				{
					add(new QState(_maxActions));
				}
				else
				{
					throw new Error("Object pool has no more free resources.");
				}
			}
			remove(nodeToBorrow);
			return nodeToBorrow as QState;
		}

		/**
		 * Returns a QState that was in use back to the pool. The QState is cleaned before it may be reused.
		 *
		 * @param state The QState being recycled.
		 */
		public function recycle(state:QState):void
		{
			state.reset();
			add(state);
		}

		/**
		 * Adds a new node to the linked list.
		 */
		public function add(node:IDoubleLinkedListNode):void
		{
			if(_firstNode == null)
			{
				_firstNode = node;
				_lastNode = node;
				_currentNode = node;
			}
			else
			{
				_lastNode.nextNode = node;
				node.previousNode = lastNode;
				_lastNode = node;
			}
			_length++;
		}

		/**
		 * Clears the linked list.
		 */
		public function clear():void
		{
			_length = 0;
			_firstNode = null;
		}

		/**
		 * Removes a node from the linked list.
		 * @param nodeToRemove The node to be removed.
		 */
		public function remove(nodeToRemove:IDoubleLinkedListNode):void
		{
			if (nodeToRemove.previousNode == null)
			{
				_firstNode = nodeToRemove.nextNode;
			}
			else
			{
				nodeToRemove.previousNode.nextNode = nodeToRemove.nextNode;
			}
			if (nodeToRemove.nextNode == null)
			{
				_lastNode = nodeToRemove.previousNode;
			}
			else
			{
				nodeToRemove.nextNode.previousNode = nodeToRemove.previousNode;
			}
		
			nodeToRemove.nextNode = null;
			nodeToRemove.previousNode = null;
		
			_length--;
		}

		/**
		 * Checks to see if there is another trailing node.
		 */
		public function hasNext():Boolean
		{
			if (_currentNode == null)
			{
				_currentNode = firstNode;
				return false;
			}
			else
			{
				return true;
			}
		}

		/**
		 * Returns the next trailing node.
		 */
		public function next():IDoubleLinkedListNode
		{
			var node:IDoubleLinkedListNode = _currentNode;
			_currentNode = _currentNode.nextNode;
			return node;
		}
	}
}
