﻿package {
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import agi.utils.Format;
	
	public class Mortgage extends Sprite
	{
		public var mortgageBalanceBOM:Number = 0;
		public var mortgageBalanceEOM:Number = 0;
		public var houseValueNum:Number = 0;		
		public var homeValueEOM:Number = 0;	
		public var month:Number = 0;
		public var bigArray:Array;
		public var summaryArray:Array;
		public var valuesArray:Array = [];
		
		private var _monthly:Number = 0 ;
		private var _interestRateNum:Number;								
		private var monthlyMortgagePayment:Number = 0;
		private var monthlyMortgageInterest:Number = 0;
		private var monthlyPrincipalPayment:Number = 0;
		private var _houseAppreciationRateChosen:Number = 0;
		private var netHomeEquity:Number = 0;
		private var monthlyAllocationToSaving:Number = 0;
		private var monthlySavingsBalanceEOM:Number = 0;
		private var netHomeEquityAndSavings:Number = 0;	
		private var _totalCashFlowAllocatedToMortgageAndSaving:Number = 0;	
		
		private var _format:Format = new Format();
		
		public function Mortgage(totalCashFlowAllocatedToMortgageAndSaving:Number, mortgageBalance:Number, monthly:Number, interestRateNum:Number, houseValue:Number, houseAppreciationRateChosen:Number):void
		{
			mortgageBalanceBOM = mortgageBalance;
			houseValueNum = houseValue;
			_monthly = monthly;
			_interestRateNum = interestRateNum;										
			_houseAppreciationRateChosen = houseAppreciationRateChosen;	
			_totalCashFlowAllocatedToMortgageAndSaving = totalCashFlowAllocatedToMortgageAndSaving
			bigArray = new Array();
			summaryArray = new Array();
		}
		
		public function recalculate():void
		{
			//monthlyMortgagePayment = _monthly;
			
			if (mortgageBalanceBOM > 0)
			{
				monthlyMortgagePayment = _monthly;
			} else 
			{
				monthlyMortgagePayment = 0 
			}
			
			monthlyMortgageInterest = mortgageBalanceBOM * (_interestRateNum / 12);

			
			monthlyPrincipalPayment = monthlyMortgagePayment - monthlyMortgageInterest;											

			mortgageBalanceEOM = mortgageBalanceBOM - monthlyPrincipalPayment;								
			homeValueEOM = houseValueNum * (1 + (_houseAppreciationRateChosen / 12));											
			netHomeEquity = homeValueEOM - mortgageBalanceEOM;																	
			monthlyAllocationToSaving = _totalCashFlowAllocatedToMortgageAndSaving - monthlyMortgagePayment;						
			
			monthlySavingsBalanceEOM = monthlyAllocationToSaving + (monthlySavingsBalanceEOM * ( 1 + (_interestRateNum / 12)));			
			netHomeEquityAndSavings = netHomeEquity + monthlySavingsBalanceEOM;		

			//var allMonth:Array = [this.month +1, reformate(_totalCashFlowAllocatedToMortgageAndSaving), reformate(monthlyMortgagePayment), reformate(mortgageBalanceBOM), reformate(monthlyMortgageInterest), reformate(monthlyPrincipalPayment), reformate(mortgageBalanceEOM), reformate(homeValueEOM), reformate(netHomeEquity), reformate(monthlyAllocationToSaving), reformate(monthlySavingsBalanceEOM), reformate(netHomeEquityAndSavings)];
			
			var allMonth:Array = [this.month +1, _totalCashFlowAllocatedToMortgageAndSaving, monthlyMortgagePayment, mortgageBalanceBOM, monthlyMortgageInterest, monthlyPrincipalPayment, mortgageBalanceEOM, homeValueEOM, netHomeEquity, monthlyAllocationToSaving, monthlySavingsBalanceEOM, netHomeEquityAndSavings];
			
			bigArray.push(allMonth);
				
			// create summaryArray for 1 - 5 - 10 - 15 - 20 - 30 year:
			if (this.month == 11 || this.month == 59 || this.month == 119 || this.month == 179 || this.month == 239 || this.month == 359)
			{
				var summaryMonth:Array = [(this.month + 1) / 12, allMonth[7], allMonth[6], allMonth[8], allMonth[10], allMonth[11] ]
				summaryArray.push(summaryMonth);	
			}
						
			
			// create monthlySavingsBalanceEOMArray and netHomeEquityArray from year 0 to year 30:
			if (!((this.month / 12) % 1) || this.month == 359) 
			{
				var myArray:Array = new Array();
				myArray = [ Math.round(netHomeEquity), Math.round(monthlySavingsBalanceEOM)];
				
				valuesArray.push(myArray);
			}
			
		}
		
		public function reformate(value:Number):String
		{
			if(value <= 0) {value = 0}
			var formatedValue:String = _format.currency(value, 0, "$");			//_format.currency(value,2,"$")
			return(formatedValue);
		}
		
	}
}