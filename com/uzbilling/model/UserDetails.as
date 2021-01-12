package com.uzbilling.model {

	public class UserDetails {
		public var subscriber:String;
		public var user_ip:String;
		public var from:String;
		public var login:String;
		public var tariff_name:String;
		public var traffic_balance:Number;
		public var monthly_payment:Number;
		public var current_balance:Number;
		public var inet_tariff_capacity:Number;
		public var traffic_world:Number;
		public var traffic_tasix:Number;
		public var balance_id:String;
		public var user_status:int;
		public var tariff_id:String;
		public var pass_state:int;
		public var macAddress:String;
		public var reserved_tariff:String;
		
		public function UserDetails() {
			// constructor code
		}
		
		public function setObject(obj:Object):void {
			//var myPattern:RegExp = /,/g;
			//debet = Number(String(obj.debet).replace(myPattern, "."));
			subscriber = obj.fio;
			user_ip = obj.user_ip;
			from = obj.from;
			login = obj.login;
			tariff_name = obj.tariff_name;
			traffic_balance = obj.traffic_balance;
			monthly_payment = obj.monthly_payment;
			current_balance = obj.current_balance;
			inet_tariff_capacity = obj.inet_tariff_capacity;
			traffic_world = obj.traffic_world;
			traffic_tasix = obj.traffic_tasix;
			balance_id = obj.balance_id;
			user_status = obj.user_status;
			tariff_id = obj.tariff_id;
			pass_state = obj.pass_state;
			reserved_tariff = obj.bron_serv_id;
		}		
	}
	
}