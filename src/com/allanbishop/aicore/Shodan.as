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

package com.allanbishop.aicore
{
	import com.allanbishop.aicore.reinforcementlearning.IProblem;
	import com.allanbishop.aicore.reinforcementlearning.Qlearning;

	/**
	 * <b>Shodan ©2010 Allan Bishop. Visit http://www.allanbishop.com. Licensed under the MIT license.</b>
	 * <p>Shodan is an implementation of the Q-learning algorithm. 
	 * The Q-learning algorithm is a type of reinforcement learning that enables an agent, "Shodan", to learn from its environment and 
	 * act upon it with intelligence. A problem is defined and is passed to Shodan which will then train 
	 * over a number of iterations until it converges on an optimal solution. The power of this type of reinforcement learning is that the
	 * Shodan can adapt as the problem changes. This resembles human like learning behaviour where we use trial
	 * and error, combined with history, to determine the best action to achieve our goals.</p>
	 **/
	public class Shodan
	{
		/**
		 * The version is represented by the major.minor.revision
		 **/
		public static const VERSION:String = "01.00.00"; //do not modify. Automatically updated.
		public static const AUTHOR:String = "Allan Bishop";
		private var _problem:IProblem;
		private var _learning:Qlearning;

		/**
		 * Determines how much weight is placed on new information. The range is 0-1 with 1 the max learning rate.
		 */
		public function get learningRate():Number 
		{
			return _learning.learningRate;
		}

		/**
		 * @private
		 */
		public function set learningRate(value:Number):void 
		{
			_learning.learningRate = value;
		}

		/**
		 * Probability of taking an exploratory action, that is, taking actions based on what is perceived to be the
		 * best action (greedy) and trying other actions (exploratory). The range is 0-1.
		 */
		public function get explorationProbability():Number
		{
			return _learning.explorationProbability;
		}

		/**
		 * @private
		 */
		public function set explorationProbability(value:Number):void 
		{
			_learning.explorationProbability = value;
		}

		/**
		 * Determines the importance of short term reward verses long term reward. Range is 0-1 with 1 favouring long term reward. 
		 */
		public function get discountFactor():Number
		{
			return _learning.discountRate;
		}

		/**
		 * @private
		 */
		public function set discountFactor(value:Number):void 
		{
			_learning.discountRate = value;
		}

		/**
		 * Constructs a new Shodan instance.
		 *
		 * @param problem The problem that Shodan will train on.
		 */
		public function Shodan(problem:IProblem) 
		{
			_problem = problem;
			init();
		}

		private function init():void
		{
			_learning = new Qlearning(_problem);
		}

		/**
		 * Resets all knowledge to the initial unbiased default.
		 */
		public function reset():void
		{
			_learning.reset();
		}

		/**
		 * Trains Shodan for the specified amount of times. Depending on the amount of states and actions in the 
		 * problem and the settings: learning rate, explorationProbability and discountFactor will determine how long it takes 
		 * for Shodan to converge to an optimal solution.
		 * 
		 * @param iterations The number of times to train for.
		 */
		public function train(iterations:int):void
		{
			_learning.train(iterations);
		}
	}
}
