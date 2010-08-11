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
	/**
	 * The problem that Shodan will learn.
	 * 
	 * <p>A problem can be considered a world. The world will always have a current state that can be quantified.
	 * It will also be able to perform actions on itself and determine a reward from those actions.</p>
	 */
	public interface IProblem 
	{
		/**
		 * Returns the current state of the problem.
		 * For example 023673098 could represent x:023 y:673: battery:098.
		 * 
		 * @return Returns a Number that is unique for each state.
		 */
		function getCurrentProblemState():Number;

		/**
		 * The total amount of different states in the problem.
		 * 
		 * @return The number of total states.
		 */
		function getTotalStates():int;

		/**
		 * Returns the maximum amount of actions for a state. This will be the amount of actions of the state with the most actions.
		 * 
		 * @return Maximum number of actions.
		 */
		function getMaxActions():int;

		/**
		 * Returns a collection of valid actions for the current state.
		 * 
		 * @return A collection of action codes that are valid for the current state.
		 */
		function getValidActions():Vector.<int>;

		/**
		 * Performs an action on the problem.
		 * 
		 * @param actionCode The action code that corresponds with the action that will be taken.
		 */
		function performAction(actionCode:int):void;

		/**
		 * Returns the reward received from that last action performed. The higher the value, the greater the reward.
		 * 
		 * @return The reward.
		 */
		function getReward():int;

	}
}