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
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 * The Qlearning class is the implementation of the Q-learning algorithm. This is where the training of the problem occurs. 
	 **/
	public class Qlearning 
	{
		private const LEARNING_RATE:Number = 0.7;
		private const DISCOUNT_RATE:Number =  0.7;
		private const PROBABILITY:Number =  0.4;
		private var _problem:IProblem;
		private var _states:Dictionary;
		private var _explorationProbability:Number;
		private var _learningRate:Number;
		private var _discountRate:Number;
		private var _totalStates:int;
		private var _pool:QStatePool;

		/**
		 * Probability of taking an exploratory action. With Q-learning the agent balances taking actions based on what it has
		 * perceived to be the best (greedy) and trying other actions (exploratory). This is known as the policy. The range is 0-1.
		 */
		public function get explorationProbability():Number 
		{
			return _explorationProbability;
		}

		/**
		 * @private
		 */
		public function set explorationProbability(value:Number):void 
		{
			_explorationProbability = value;
		}

		/**
		 * Determines how much weight is placed on new information. The range is 0-1 with 1 the max learning rate.
		 */
		public function get learningRate():Number 
		{
			return _learningRate;
		}

		/**
		 * @private
		 */
		public function set learningRate(value:Number):void 
		{
			_learningRate = value;
		}

		/**
		 * Determines how concerned Q-learning is with short term reward or long term reward. Range is 0-1 with 1 favouring long term reward. 
		 */
		public function get discountRate():Number 
		{
			return _discountRate;
		}

		/**
		 * @private 
		 */
		public function set discountRate(value:Number):void 
		{
			_discountRate = value;
		}

		/**
		 * Constructs a new Qlearning instance.
		 * 
		 * @param problem The problem that Q-learning will learn.
		 */
		public function Qlearning(problem:IProblem) 
		{
			_learningRate = LEARNING_RATE;
			_discountRate = DISCOUNT_RATE;
			_explorationProbability = PROBABILITY;
			_problem = problem;
			_totalStates = _problem.getTotalStates();
			_states = new Dictionary();
			_pool = new QStatePool(_totalStates, _problem.getMaxActions());
		}

		/**
		 * A lookup for the QState from a problem state.
		 *
		 * @param problemState The unique state for looking up the corresponding QState.
		 *
		 * @return Corresponding QState.
		 */
		public function getQState(problemState:Number):QState
		{
			var state:QState = _states[problemState];
			
			if(state == null)
			{
				state = _pool.borrow();
				_states[problemState] = state;
			}
			
			return state;
		}

		/**
		 * Resets all the states to the default value of 0. All prior learnings are lost.
		 */
		public function reset():void
		{
			for each (var qState:QState in _states) 
			{
				qState.reset();
				_pool.recycle(qState);
			}
			_states = new Dictionary();
		}

		/**
		 * Executes one training step of the Q-learning algorithm.
		 */
		public function step():void
		{
			var newProblemState:Number;
			var state:QState;
			var newState:QState;
			var actionId:int;
			var actionList:Vector.<int>;
			var problemState:Number = _problem.getCurrentProblemState();
			state = getQState(problemState);
		
			//the policy - determine if we will take the current known best action or random action
			if(Math.random() < _explorationProbability)
			{
				actionList = _problem.getValidActions();
				var aIndex:int = Math.random() * actionList.length;

				actionId = actionList[aIndex];
			}
			else
			{
				actionList = _problem.getValidActions();
		
				actionId = state.getBestAction(actionList);
			}
				
			_problem.performAction(actionId);
			newProblemState = _problem.getCurrentProblemState();
			var reward:int = _problem.getReward();
			newState = getQState(newProblemState);
			var newStateQValue:Number = newState.getValue(newState.getBestAction(_problem.getValidActions()));
			var currentStateQValue:Number = state.getValue(actionId);
			//the Q-learning algorithm
			var qValue:Number = (1 - _learningRate) * currentStateQValue + _learningRate * (reward + (_discountRate * newStateQValue));
			state.setValue(actionId, qValue);
			state = newState;
		}
	
		/**
		 * Iterates through step.
		 *
		 * @param iterations Number of times to iterate.
		 * 
		 * @see step
		 */
		public function train(interations:int):void
		{
			var i:int = 0;
			while (i < interations)
			{
				step();
				i++;
			}
		}
	}
}
